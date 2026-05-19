//
//  VideoCall+Agora.swift
//  DoubleDotExpert
//
//  Created by apple on 27/06/24.
//

import Foundation
import AgoraRtcKit
import UIKit
import PIPKit
import AVKit

extension VideoCallViewC{
//    func loadAgoraLiveStreamingKit(uid:UInt, channelId:String,token:String) {
//        self.setIdleTimerActive(false)
//        self.agoraKit?.delegate = self
//        self.agoraKit?.setChannelProfile(.communication)
//        self.agoraKit?.setClientRole(self.role)
//        self.agoraKit?.enableDualStreamMode(false)
//        self.agoraKit?.enableVideo()
//        self.agoraKit?.setEnableSpeakerphone(true)
//        self.agoraKit?.setVideoEncoderConfiguration(
//            AgoraVideoEncoderConfiguration(
//                size: self.dimension,
//                frameRate: self.framerate,
//                bitrate: AgoraVideoBitrateStandard,
//                orientationMode: .adaptative, mirrorMode: .auto
//            )
//        )
//        self.addLocalSession()
//        self.agoraKit?.joinChannel(byToken: token, channelId: channelId, info: nil, uid: uid ,joinSuccess: { _, _, _ in
//            print("success")
//        })
//    }
    
//    func addLocalSession() {
//        self.agoraKit?.setupLocalVideo(self.localCanvas)
//        self.agoraKit?.startPreview()
//    }
    
    func addLocalAudio() {
        self.agoraKit?.enableAudio() // Enable audio
    }
    
    func leaveChannel(){
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@ Leave Channnel @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
 
        self.agoraKit?.leaveChannel { (stats) in
            print("Left channel with stats: \(stats)")
        }
        AgoraRtcEngineKit.destroy()
        self.agoraKit = nil
    }
    
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
}

//// MARK: - AgoraRtcEngineDelegate
//extension VideoCallViewC: AgoraRtcEngineDelegate {
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
//        print(size)
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
//        print("didOfflineOfUid")
//        guard self.userConnect else {return}
//        self.pipStatus = false
//        self.setUpPipVw()
//        self.delegate?.videoCallData(patientName: self.patientName ?? EMPTY, bookingId: self.bookingId ?? EMPTY, callDuration: self.timerLbl.text ?? EMPTY)
//        self.leaveChannel()
//        PIPKit.dismiss(animated: true)
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
//        print("Video Send/Recv: \(stats.txVideoKBitrate)kbps/\(stats.rxVideoKBitrate)kbps")
//        if stats.rxVideoKBitrate == 0 {
//            if self.pipStatus {
//                self.videoDefaultVw.isHidden = false
//                self.timerImage.tintColor = UIColor.black
//                self.timerLbl.textColor = UIColor.black
//                self.titleNameLbl.tintColor = UIColor.black
//            }else{
//                self.videoDefaultVw.isHidden = true
//            }
//        }else{
//            self.videoDefaultVw.isHidden = true
//            self.timerImage.tintColor = UIColor.white
//            self.timerLbl.textColor = UIColor.white
//            self.titleNameLbl.tintColor = UIColor.white
//        }
//        
//        if stats.txVideoKBitrate == 0 {
//            self.localCanvas.view = nil
//            self.agoraKit?.setupLocalVideo(self.localCanvas)
//        }else{
//            self.localCanvas.view = self.draggableView
//            self.agoraKit?.setupLocalVideo(self.localCanvas)
//        }
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
//        print("=====================\(uid)==============================")
//        print(size)
//        self.remoteCanvas = AgoraRtcVideoCanvas()
//        self.remoteCanvas.uid = uid
//        self.remoteCanvas.view = self.videoVw
//        self.agoraKit?.setupRemoteVideo(self.remoteCanvas)
//        if #available(iOS 15.0, *) {
//                self.setupPictureInPicture()
//            }
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
//        print("didJoinChannel")
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
//        print("didJoinedOfUid")
//        self.userConnect = true
//        self.startTimer()
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didjoin channel: String, withUid uid: UInt, elapsed: Int) {
//        print("didjoin channel")
//    }
//}



//extension VideoCallViewC:AVPictureInPictureControllerDelegate{
//    @available(iOS 15.0, *)
//    func setupPictureInPicture() {
//
//        pipVideoCallVC = AVPictureInPictureVideoCallViewController()
//
//        guard let pipVideoCallVC else { return }
//
//        pipVideoCallVC.preferredContentSize = CGSize(width: 300, height: 500)
//
//        // PiP rendering view
//        let pipVideoView = UIView(frame: pipVideoCallVC.view.bounds)
//        pipVideoView.backgroundColor = .black
//        pipVideoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        pipVideoCallVC.view.addSubview(pipVideoView)
//
//        // IMPORTANT:
//        // Use a SEPARATE canvas for PiP
//        let pipCanvas = AgoraRtcVideoCanvas()
//        pipCanvas.uid = remoteCanvas.uid
//        pipCanvas.view = pipVideoView
//        pipCanvas.renderMode = .hidden
//
//        agoraKit?.setupRemoteVideo(pipCanvas)
//
//        let contentSource = AVPictureInPictureController.ContentSource(
//            activeVideoCallSourceView: self.videoVw,
//            contentViewController: pipVideoCallVC
//        )
//
//        pipController = AVPictureInPictureController(contentSource: contentSource)
//
//        pipController?.delegate = self
//        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
//    }
//}
