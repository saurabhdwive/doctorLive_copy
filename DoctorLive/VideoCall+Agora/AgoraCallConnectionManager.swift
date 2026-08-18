//
//  AgoraCallConnectionManager.swift
//  DoctorLive
//
//  Reusable connection/reconnection/network-quality state machine for
//  AgoraRtcEngineKit (native SDK, not Agora UIKit). Mirrors the Android
//  behavior around onUserOffline / onConnectionStateChanged / onNetworkQuality
//  using the equivalent iOS AgoraRtcEngineDelegate callbacks:
//
//    Android                                iOS (AgoraRtcEngineDelegate)
//    ---------------------------------------------------------------------
//    onUserOffline(uid, reason)          -> rtcEngine(_:didOfflineOfUid:reason:)
//    onConnectionStateChanged            -> rtcEngine(_:connectionChangedTo:reason:)
//    onNetworkQuality(uid, tx, rx)        -> rtcEngine(_:networkQuality:txQuality:rxQuality:)
//
//  AgoraUserOfflineReason  ~ Android's USER_OFFLINE_* constants (.quit / .dropped / .becomeAudience)
//  AgoraConnectionState    ~ Android's CONNECTION_STATE_* constants
//  AgoraNetworkQuality     ~ Android's QUALITY_* constants

import Foundation
import AgoraRtcKit

protocol AgoraCallConnectionManagerDelegate: AnyObject {
    /// Remote user left on purpose (AgoraUserOfflineReasonQuit) -> caller should end the call.
    func connectionManager(_ manager: AgoraCallConnectionManager, remoteUserLeftIntentionally uid: UInt)

    /// Connection lost (remote dropped, or local disconnected/failed) but we are still inside
    /// the reconnect window. Show a "reconnecting" indicator; keep the remote view/call alive.
    func connectionManagerDidStartReconnecting(_ manager: AgoraCallConnectionManager)

    /// Connection came back before the reconnect window expired.
    func connectionManagerDidRestoreConnection(_ manager: AgoraCallConnectionManager)

    /// Reconnect window expired without recovery -> caller should end the call.
    func connectionManagerDidEndCallAfterTimeout(_ manager: AgoraCallConnectionManager)

    /// Local network quality has been consistently poor/consistently good for the configured
    /// number of consecutive samples. `disabled == true` -> pause local video (audio stays live).
    /// `disabled == false` -> network recovered; caller must still respect the user's manual
    /// camera preference before actually re-enabling video.
    func connectionManager(_ manager: AgoraCallConnectionManager, didChangeVideoDisabledBecauseOfNetwork disabled: Bool)

    /// The *remote* user's own upload/download quality (as they report it) has been consistently
    /// poor/good for the configured number of consecutive samples. Their video is still arriving,
    /// just degraded/stuttering — the caller should visually flag it (e.g. blur the remote view)
    /// rather than doing anything to the local camera.
    func connectionManager(_ manager: AgoraCallConnectionManager, didChangeRemoteVideoStuckBecauseOfNetwork stuck: Bool)
    
    /// The remote user's connection is weak based on high packet/audio loss or poor rx quality.
    func connectionManager(_ manager: AgoraCallConnectionManager, didChangeRemoteConnectionWeak weak: Bool)
}

/// Tracks Agora connection/reconnection state and local network quality, and decides when to
/// end a call vs. keep it alive through a temporary network blip. All delegate callbacks and all
/// internal state mutation happen on the main thread so callers can update UIKit directly.
final class AgoraCallConnectionManager {

    weak var delegate: AgoraCallConnectionManagerDelegate?

    // MARK: - Configuration

    /// How long to wait for the connection to recover before ending the call. Configurable;
    /// Android used no fixed constant here either. 20s sits in the requested 15-30s range.
    let reconnectTimeoutSeconds: TimeInterval

    /// Number of consecutive poor-quality samples required before disabling video.
    let networkPoorRequiredCount: Int

    /// Number of consecutive good-quality samples required before restoring video.
    let networkRecoveryRequiredCount: Int

    init(
        reconnectTimeoutSeconds: TimeInterval = 20,
        networkPoorRequiredCount: Int = 3,
        networkRecoveryRequiredCount: Int = 3
    ) {
        self.reconnectTimeoutSeconds = reconnectTimeoutSeconds
        self.networkPoorRequiredCount = networkPoorRequiredCount
        self.networkRecoveryRequiredCount = networkRecoveryRequiredCount
    }

    // MARK: - State (only ever touched on main queue, see `runOnMain`)

    private(set) var isUserJoined = false
    private(set) var lastRemoteUid: UInt?
    private(set) var isVideoDisabledBecauseOfNetwork = false

    /// The user's manual camera preference (mirrors the VC's own "camera on/off" button state).
    /// The caller is expected to keep this in sync via `updateUserVideoEnabled(_:)` whenever the
    /// user taps the camera button. Network recovery will not turn video back on if this is false.
    private(set) var isUserVideoEnabled = true

    private(set) var isRemoteVideoStuckBecauseOfNetwork = false

    private var poorNetworkCount = 0
    private var goodNetworkCount = 0
    private var poorRemoteNetworkCount = 0
    private var goodRemoteNetworkCount = 0
    private var reconnectTimer: Timer?
    
    // Weak connection state
    private var remoteAudioLossCount = 0
    private var remoteVideoLossCount = 0
    private var isRemoteConnectionWeak = false
    private var weakConnectionShowTime: TimeInterval = 0
    private let minBannerDisplaySeconds: TimeInterval = 5.0
    private var currentRxQuality: AgoraNetworkQuality = .unknown
    private var isRemoteVideoBitrateZero = false

    private func runOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }

    // MARK: - Lifecycle

    /// Call from `rtcEngine(_:didJoinedOfUid:elapsed:)` once the remote user has joined.
    func markUserJoined(uid: UInt) {
        runOnMain { [weak self] in
            guard let self else { return }
            self.isUserJoined = true
            self.lastRemoteUid = uid
            self.cancelReconnectTimerLocked()
            self.poorRemoteNetworkCount = 0
            self.goodRemoteNetworkCount = 0
            self.isRemoteVideoStuckBecauseOfNetwork = false
        }
    }

    /// Call when the call is torn down (leaveChannel / VC dismissal) to reset all state.
    func reset() {
        runOnMain { [weak self] in
            guard let self else { return }
            self.isUserJoined = false
            self.lastRemoteUid = nil
            self.cancelReconnectTimerLocked()
            self.poorNetworkCount = 0
            self.goodNetworkCount = 0
            self.isVideoDisabledBecauseOfNetwork = false
            self.poorRemoteNetworkCount = 0
            self.goodRemoteNetworkCount = 0
            self.isRemoteVideoStuckBecauseOfNetwork = false
            
            self.remoteAudioLossCount = 0
            self.remoteVideoLossCount = 0
            self.isRemoteConnectionWeak = false
            self.weakConnectionShowTime = 0
            self.currentRxQuality = .unknown
            self.isRemoteVideoBitrateZero = false
        }
    }

    /// Keep this in sync with the user's manual camera toggle so network-recovery logic never
    /// re-enables video the user turned off themselves.
    func updateUserVideoEnabled(_ enabled: Bool) {
        runOnMain { [weak self] in
            self?.isUserVideoEnabled = enabled
        }
    }

    // MARK: - rtcEngine(_:didOfflineOfUid:reason:)

    func handleUserOffline(uid: UInt, reason: AgoraUserOfflineReason) {
        runOnMain { [weak self] in
            guard let self else { return }
            switch reason {
            case .quit:
                // Remote user intentionally left the channel -> end the call.
                self.cancelReconnectTimerLocked()
                self.delegate?.connectionManager(self, remoteUserLeftIntentionally: uid)

            case .dropped, .becomeAudience:
                // Temporary connection loss, or the remote switched to audience — keep the call
                // alive and give them a window to come back.
                self.beginReconnectWindowLocked()

            @unknown default:
                // Unknown reason: don't assume the worst, just start the reconnect window.
                self.beginReconnectWindowLocked()
            }
        }
    }

    // MARK: - rtcEngine(_:connectionChangedTo:reason:)

    func handleConnectionStateChanged(state: AgoraConnectionState, reason: AgoraConnectionChangedReason) {
        runOnMain { [weak self] in
            guard let self else { return }
            switch state {
            case .connected:
                self.cancelReconnectTimerLocked()
                self.delegate?.connectionManagerDidRestoreConnection(self)

            case .connecting:
                // Initial join or a benign transient state — never terminate here.
                break

            case .reconnecting:
                // SDK is actively retrying under the hood; surface a "reconnecting" UI but do
                // not end the call. This also (re)starts the timeout window if one isn't running.
                self.beginReconnectWindowLocked()

            case .disconnected, .failed:
                guard self.isUserJoined else { return }
                self.beginReconnectWindowLocked()

            @unknown default:
                break
            }
        }
    }

    // MARK: - Reconnect window

    /// Starts (or leaves running, if already active) the reconnect timeout window. Safe to call
    /// repeatedly — it never creates more than one live timer.
    func startReconnectWindow() {
        runOnMain { [weak self] in
            self?.beginReconnectWindowLocked()
        }
    }

    /// Call when the SDK/remote user reports a healthy connection again.
    func handleConnectionRestored() {
        runOnMain { [weak self] in
            guard let self else { return }
            self.cancelReconnectTimerLocked()
            self.delegate?.connectionManagerDidRestoreConnection(self)
        }
    }

    private func beginReconnectWindowLocked() {
        guard reconnectTimer == nil else { return } // never stack multiple timers
        delegate?.connectionManagerDidStartReconnecting(self)
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: reconnectTimeoutSeconds, repeats: false) { [weak self] _ in
            self?.finishCallAfterConnectionFailure()
        }
    }

    private func finishCallAfterConnectionFailure() {
        runOnMain { [weak self] in
            guard let self else { return }
            self.cancelReconnectTimerLocked()
            self.delegate?.connectionManagerDidEndCallAfterTimeout(self)
        }
    }

    private func cancelReconnectTimerLocked() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }

    // MARK: - rtcEngine(_:networkQuality:txQuality:rxQuality:) — local user only (uid == 0)

    func handleLocalNetworkQuality(txQuality: AgoraNetworkQuality, rxQuality: AgoraNetworkQuality) {
        let poorUpload = Self.isPoor(txQuality)
        let poorDownload = Self.isPoor(rxQuality)
        let poorNetwork = poorUpload || poorDownload

        runOnMain { [weak self] in
            guard let self else { return }

            if poorNetwork {
                self.poorNetworkCount += 1
                self.goodNetworkCount = 0

                if self.poorNetworkCount >= self.networkPoorRequiredCount, !self.isVideoDisabledBecauseOfNetwork {
                    self.isVideoDisabledBecauseOfNetwork = true
                    self.delegate?.connectionManager(self, didChangeVideoDisabledBecauseOfNetwork: true)
                }
            } else {
                self.goodNetworkCount += 1
                self.poorNetworkCount = 0

                if self.goodNetworkCount >= self.networkRecoveryRequiredCount, self.isVideoDisabledBecauseOfNetwork {
                    self.isVideoDisabledBecauseOfNetwork = false
                    self.delegate?.connectionManager(self, didChangeVideoDisabledBecauseOfNetwork: false)
                }
            }
        }
    }

    // MARK: - rtcEngine(_:networkQuality:txQuality:rxQuality:) — remote user (uid != 0)

    /// Feed this the quality report for the currently joined remote user (match against
    /// `lastRemoteUid`, since the callback fires once per uid in the channel including any
    /// audience members). Unlike the local-video path, a poor reading here never touches the
    /// engine — it only tells the caller the remote feed is likely to look stuck/degraded so it
    /// can show a visual hint (e.g. blur) while audio and the call itself stay untouched.
    func handleRemoteNetworkQuality(uid: UInt, txQuality: AgoraNetworkQuality, rxQuality: AgoraNetworkQuality) {
        runOnMain { [weak self] in
            guard let self else { return }
            guard uid == self.lastRemoteUid else { return }
            
            self.currentRxQuality = rxQuality
            self.evaluateWeakConnection()
            
            let poorNetwork = Self.isPoor(txQuality) || Self.isPoor(rxQuality)

            if poorNetwork {
                self.poorRemoteNetworkCount += 1
                self.goodRemoteNetworkCount = 0

                if self.poorRemoteNetworkCount >= self.networkPoorRequiredCount, !self.isRemoteVideoStuckBecauseOfNetwork {
                    self.isRemoteVideoStuckBecauseOfNetwork = true
                    self.delegate?.connectionManager(self, didChangeRemoteVideoStuckBecauseOfNetwork: true)
                }
            } else {
                self.goodRemoteNetworkCount += 1
                self.poorRemoteNetworkCount = 0

                if self.goodRemoteNetworkCount >= self.networkRecoveryRequiredCount, self.isRemoteVideoStuckBecauseOfNetwork {
                    self.isRemoteVideoStuckBecauseOfNetwork = false
                    self.delegate?.connectionManager(self, didChangeRemoteVideoStuckBecauseOfNetwork: false)
                }
            }
        }
    }

    private static func isPoor(_ quality: AgoraNetworkQuality) -> Bool {
        switch quality {
        case .poor, .bad, .vBad, .down:
            return true
        case .unknown, .excellent, .good, .unsupported, .detecting:
            return false
        @unknown default:
            return false
        }
    }
    
    // MARK: - Weak Connection Evaluation
    
    func handleRemoteAudioStats(uid: UInt, audioLossRate: UInt) {
        runOnMain { [weak self] in
            guard let self = self, uid == self.lastRemoteUid else { return }
            if audioLossRate > 15 {
                self.remoteAudioLossCount += 1
            } else {
                self.remoteAudioLossCount = 0
            }
            self.evaluateWeakConnection()
        }
    }

    func handleRemoteVideoStats(uid: UInt, packetLossRate: UInt) {
        runOnMain { [weak self] in
            guard let self = self, uid == self.lastRemoteUid else { return }
            if packetLossRate > 15 {
                self.remoteVideoLossCount += 1
            } else {
                self.remoteVideoLossCount = 0
            }
            self.evaluateWeakConnection()
        }
    }
    
    func handleRemoteVideoBitrate(rxVideoKBitrate: Int) {
        runOnMain { [weak self] in
            guard let self = self else { return }
            self.isRemoteVideoBitrateZero = (rxVideoKBitrate == 0)
            self.evaluateWeakConnection()
        }
    }
    
    private func evaluateWeakConnection() {
        let qualityWeak = Self.isPoor(currentRxQuality)
        let lossWeak = remoteAudioLossCount >= 3 || remoteVideoLossCount >= 3
        let bitrateWeak = isRemoteVideoBitrateZero
        
        if qualityWeak || lossWeak || bitrateWeak {
            if !isRemoteConnectionWeak {
                isRemoteConnectionWeak = true
                weakConnectionShowTime = Date().timeIntervalSince1970
                delegate?.connectionManager(self, didChangeRemoteConnectionWeak: true)
            }
        } else {
            if isRemoteConnectionWeak, Date().timeIntervalSince1970 - weakConnectionShowTime >= minBannerDisplaySeconds {
                isRemoteConnectionWeak = false
                delegate?.connectionManager(self, didChangeRemoteConnectionWeak: false)
            }
        }
    }
}
