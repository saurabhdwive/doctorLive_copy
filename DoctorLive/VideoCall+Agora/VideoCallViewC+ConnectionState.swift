//
//  VideoCallViewC+ConnectionState.swift
//  DoctorLive
//
//  Wires AgoraCallConnectionManager into VideoCallViewC: UI setup for the
//  reconnecting / poor-network / video-disabled indicators, and the
//  AgoraCallConnectionManagerDelegate callbacks that react to connection and
//  network-quality changes reported by AgoraRtcEngineDelegate.

import UIKit
import AgoraRtcKit

extension VideoCallViewC {

    /// Lays out the three status pills used to surface reconnect/network state, plus the blur
    /// overlay for a missing/stuck remote video stream. Added programmatically so no storyboard
    /// changes are required.
    func setUpConnectionIndicators() {
        connectionManager.delegate = self
        
        let bannerStack = UIStackView(arrangedSubviews: [reconnectingIndicatorVw, weakConnectionIndicatorVw])
        bannerStack.axis = .vertical
        bannerStack.spacing = 0
        bannerStack.translatesAutoresizingMaskIntoConstraints = false
        bannerStack.layer.shadowColor = UIColor.black.cgColor
        bannerStack.layer.shadowOpacity = 0.3
        bannerStack.layer.shadowOffset = CGSize(width: 0, height: 4)
        bannerStack.layer.shadowRadius = 4
        self.view.addSubview(bannerStack)
        
        NSLayoutConstraint.activate([
            bannerStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            bannerStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bannerStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

//        [poorNetworkIndicatorVw, videoDisabledIndicatorVw].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            $0.isHidden = true
//            self.view.addSubview($0)
//        }

        NSLayoutConstraint.activate([
//            poorNetworkIndicatorVw.topAnchor.constraint(equalTo: bannerStack.bottomAnchor, constant: 8),
//            poorNetworkIndicatorVw.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//
//            videoDisabledIndicatorVw.topAnchor.constraint(equalTo: poorNetworkIndicatorVw.bottomAnchor, constant: 8),
//            videoDisabledIndicatorVw.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        // Sits directly on top of remoteVideoView (already embedded into videoVw by
        // setUpDragableVw), so it blurs the last rendered/frozen remote frame in place.
        remoteVideoBlurVw.isHidden = true
        videoVw.embed(remoteVideoBlurVw)
        videoVw.bringSubviewToFront(remoteVideoBlurVw)
    }

    // MARK: - Remote video blur

    /// Blur reason: remote user's connection is dropped/reconnecting.
    func setRemoteConnectionBlur(_ active: Bool) {
        isRemoteConnectionBlurActive = active
        updateRemoteVideoBlurVisibility()
    }

    /// Blur reason: call is connected but no video bitrate is coming in (frozen / camera off / stuck).
    func setRemoteVideoStreamStuckBlur(_ active: Bool) {
        guard isRemoteVideoStreamStuckBlurActive != active else { return }
        isRemoteVideoStreamStuckBlurActive = active
        updateRemoteVideoBlurVisibility()
    }

    /// Blur reason: the remote user's own upload/download quality has been reported as poor for
    /// several consecutive samples — their video is still technically arriving, just degraded
    /// enough (low bitrate, choppy, stale frames) to look stuck.
    func setRemoteNetworkPoorBlur(_ active: Bool) {
        guard isRemoteNetworkPoorBlurActive != active else { return }
        isRemoteNetworkPoorBlurActive = active
        updateRemoteVideoBlurVisibility()
    }

    private func updateRemoteVideoBlurVisibility() {
        let shouldBlur = isRemoteConnectionBlurActive
            || isRemoteVideoStreamStuckBlurActive
            || isRemoteNetworkPoorBlurActive
        remoteVideoBlurVw.setHidden(!shouldBlur, animated: true)
    }

    /// poorNetworkIndicatorVw reflects either side's poor-network state, so each side just
    /// reports its own bool here instead of setting visibility directly.
    private func updatePoorNetworkIndicator() {
        let shouldShow = isLocalNetworkPoorIndicatorActive || isRemoteNetworkPoorBlurActive
//        poorNetworkIndicatorVw.setHidden(!shouldShow, animated: true)
    }

    func updateWeakConnectionIndicatorVisibility() {
        let shouldShow = isRemoteConnectionWeakActive && !isRemoteConnectionBlurActive && isWeakConnectionInitialDelayPassed && userConnect
        weakConnectionIndicatorVw.setHidden(!shouldShow, animated: true)
    }
}

// MARK: - AgoraCallConnectionManagerDelegate

extension VideoCallViewC: AgoraCallConnectionManagerDelegate {

    // Remote user left the channel on purpose (AgoraUserOfflineReasonQuit).
    // Equivalent of the Android flow: hide remote video -> end call.
    func connectionManager(_ manager: AgoraCallConnectionManager, remoteUserLeftIntentionally uid: UInt) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.reconnectingIndicatorVw.hide()
            self.delegate?.videoCallData(
                patientName: self.patientName ?? EMPTY,
                bookingId: self.bookingId ?? EMPTY,
                callDuration: self.timerLbl.text ?? EMPTY
            )
            self.disconnectCallAndDismiss(myself: true)
        }
    }

    // Connection lost (remote dropped / local disconnected / failed) but still inside the
    // reconnect window. Keep the call and the remote container alive, just show a hint.
    func connectionManagerDidStartReconnecting(_ manager: AgoraCallConnectionManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.reconnectingIndicatorVw.show()
            self.setRemoteConnectionBlur(true)
            self.updateWeakConnectionIndicatorVisibility()
        }
    }

    // Connection recovered before the timeout — cancel the pending "end call" and clear the UI.
    func connectionManagerDidRestoreConnection(_ manager: AgoraCallConnectionManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.reconnectingIndicatorVw.hide()
            self.setRemoteConnectionBlur(false)
            self.updateWeakConnectionIndicatorVisibility()
        }
    }

    // Reconnect window expired without recovery — end the call the same way the existing
    // "end call" button flow does.
    func connectionManagerDidEndCallAfterTimeout(_ manager: AgoraCallConnectionManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.reconnectingIndicatorVw.hide()
            self.delegate?.videoCallData(
                patientName: self.patientName ?? EMPTY,
                bookingId: self.bookingId ?? EMPTY,
                callDuration: self.timerLbl.text ?? EMPTY
            )
            self.disconnectCallAndDismiss(myself: true)
        }
    }

    // Local network has been consistently poor/good for several consecutive samples.
    func connectionManager(_ manager: AgoraCallConnectionManager, didChangeVideoDisabledBecauseOfNetwork disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.isLocalNetworkPoorIndicatorActive = disabled
            self.updatePoorNetworkIndicator()

            if disabled {
                // Pause local camera video, keep audio alive. Only touch the engine if video
                // isn't already off, so we never spam enableLocalVideo on every callback.
                if self.isUsingLocalCamera {
                    self.agoraKit?.enableLocalVideo(false)
                }
//                self.videoDisabledIndicatorVw.show()
            } else {
//                self.videoDisabledIndicatorVw.hide()
                // Only restore video if the user had it enabled manually before the network
                // problem started — never override a manual camera-off choice.
                if self.isUsingLocalCamera {
                    self.agoraKit?.enableLocalVideo(true)
                }
            }
        }
    }

    // The remote user's own network is consistently poor/good — their video is still coming in,
    // just degraded, so only toggle the blur; never touch the local camera or engine state.
    func connectionManager(_ manager: AgoraCallConnectionManager, didChangeRemoteVideoStuckBecauseOfNetwork stuck: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.setRemoteNetworkPoorBlur(stuck)
            self.updatePoorNetworkIndicator()
        }
    }
    
    func connectionManager(_ manager: AgoraCallConnectionManager, didChangeRemoteConnectionWeak weak: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.isRemoteConnectionWeakActive = weak
            self.updateWeakConnectionIndicatorVisibility()
        }
    }
}

// MARK: - Remote video blur overlay

/// Frosted-glass overlay placed on top of the remote video view. Blurs whatever frame is
/// currently on screen (typically the last, now-stale, rendered frame) so a frozen/absent
/// remote feed reads as "stalled" rather than as a live picture, without hiding the container.
final class RemoteVideoBlurView: UIView {

    private let blurView: UIVisualEffectView = {
        let style: UIBlurEffect.Style
        if #available(iOS 13.0, *) {
            style = .systemUltraThinMaterialDark
        } else {
            style = .dark
        }
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }()

    private let spinner = UIActivityIndicatorView(style: .medium)
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        label.text = "Waiting for video…"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)

        spinner.color = .white

        let stack = UIStackView(arrangedSubviews: [spinner, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
//        blurView.contentView.addSubview(stack)
//        NSLayoutConstraint.activate([
//            stack.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
//            stack.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
//        ])

        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHidden: Bool {
        didSet {
            isHidden ? spinner.stopAnimating() : spinner.startAnimating()
        }
    }

    func setHidden(_ hidden: Bool, animated: Bool) {
        guard isHidden != hidden else { return }
        guard animated else {
            isHidden = hidden
            return
        }
        if !hidden {
            alpha = 0
            isHidden = false
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = hidden ? 0 : 1
        }, completion: { _ in
            self.isHidden = hidden
        })
    }
}

// MARK: - Lightweight status pill

/// Small reusable status pill ("Reconnecting…", "Poor network connection", etc). Not tied to
/// Agora — a plain UIKit view so it can be reused elsewhere in the app.
final class CallStatusIndicatorView: UIView {

    private let label = UILabel()

    init(text: String) {
        super.init(frame: .zero)

        backgroundColor = UIColor.black.withAlphaComponent(0.65)
        layer.cornerRadius = 14
        clipsToBounds = true

        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        setHidden(false, animated: true)
    }

    func hide() {
        setHidden(true, animated: true)
    }

    func setHidden(_ hidden: Bool, animated: Bool) {
        guard isHidden != hidden else { return }
        guard animated else {
            isHidden = hidden
            return
        }
        if !hidden {
            alpha = 0
            isHidden = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = hidden ? 0 : 1
        }, completion: { _ in
            self.isHidden = hidden
        })
    }
}

// MARK: - Full Width Banner

final class BannerStatusIndicatorView: UIView {

    private let label = UILabel()

    init(text: String, bgColor: UIColor) {
        super.init(frame: .zero)
        
        isHidden = true
        backgroundColor = bgColor

        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        setHidden(false, animated: true)
    }

    func hide() {
        setHidden(true, animated: true)
    }

    func setHidden(_ hidden: Bool, animated: Bool) {
        guard isHidden != hidden else { return }
        guard animated else {
            isHidden = hidden
            return
        }
        if !hidden {
            alpha = 0
            isHidden = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = hidden ? 0 : 1
        }, completion: { _ in
            self.isHidden = hidden
        })
    }
}
