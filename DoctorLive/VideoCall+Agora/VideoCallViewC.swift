 

import UIKit
import AVFoundation
import AgoraRtcKit
import Mobilisten
import AVKit
//import PIPKit

class VideoCallViewC: UIViewController, PIPUsable {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pipBtn: UIButton!
    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var flipBtn: UIButton!
    @IBOutlet weak var fotterVw: UIView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var timerImage: UIImageView!
    @IBOutlet weak var timerVw: UIView!
    @IBOutlet weak var videoDefaultVw: UIView!
    @IBOutlet weak var videoVw: UIView!
    
    var initialState: PIPState = .full
    var pipStatus: Bool = true
    
    var channelId: String?
    var rtcAgoroToken: String?
    var patientName: String?
    var bookingId: String?
    
    var draggableView: DraggableView!
    var agoraKit:AgoraRtcEngineKit?
    var role = AgoraClientRole.broadcaster
    var dimension:CGSize = AgoraVideoDimension640x360
    var framerate = AgoraVideoFrameRate.fps15
//    var remoteCanvas = AgoraRtcVideoCanvas()
//    var localCanvas = AgoraRtcVideoCanvas()
    
    var timer: Timer?
    var callCutTimer: Timer?
    var elapsedTime: Int = 0
    var callCutElapsedTime: Int = 30
    
    var isMuted = false
    var isUsingFrontCamera = true
    var isUsingLocalCamera = true
    
    var userConnect: Bool = false
//    var videoCallCallBack: ((String, String, String)->())?
    
    var userId: String?
    var doctorId: String?
    var viewmodel = ViewModel()
    var delegate: VideoCallData?
    
    var pipController: AVPictureInPictureController?
    var pipVideoCallVC: AVPictureInPictureVideoCallViewController?
    
    // Strong reference to keep the call alive when the modal is dismissed for PiP
    static var pipKeepAlive: VideoCallViewC?
    
    // NEW======
    let localVideoView = PiPVideoView()
    let remoteVideoView = PiPVideoView()
    let ciContext = CIContext()
    var isLoggingOut = false
    var isStartButtonPressed:Bool = false

    // MARK: - Connection / network state
    let connectionManager = AgoraCallConnectionManager()
    let reconnectingIndicatorVw = BannerStatusIndicatorView(text: "Reconnecting…", bgColor: UIColor(red: 0x19/255.0, green: 0x76/255.0, blue: 0xD2/255.0, alpha: 1.0))
//    let poorNetworkIndicatorVw = CallStatusIndicatorView(text: "Poor network connection")
//    let videoDisabledIndicatorVw = CallStatusIndicatorView(text: "Video paused due to poor network")
    lazy var weakConnectionIndicatorVw = BannerStatusIndicatorView(text: "Weak connection from \(self.patientName ?? "patient")", bgColor: UIColor(red: 0xFF/255.0, green: 0xA5/255.0, blue: 0x00/255.0, alpha: 1.0))

    // Blur shown over the remote video when it's absent or stuck (frozen frame).
    let remoteVideoBlurVw = RemoteVideoBlurView()
    // Two independent reasons can trigger the same blur; tracked separately so hiding one
    // doesn't clear a blur still needed for the other reason.
    var isRemoteConnectionBlurActive = false
    var isRemoteVideoStreamStuckBlurActive = false
    var isRemoteNetworkPoorBlurActive = false
    // Drives poorNetworkIndicatorVw, which reflects either side's poor-network state.
    var isLocalNetworkPoorIndicatorActive = false
    
    // Weak connection indicator state
    var isRemoteConnectionWeakActive = false
    var isWeakConnectionInitialDelayPassed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.setUpDragableVw()
        self.setUpConnectionIndicators()
        self.setUpAgora()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        ZohoSalesIQ.Tracking.setPageTitle("Video call Screen")
    }
    
    private func setUpViews(){
        self.titleNameLbl.text = self.patientName ?? EMPTY
        NotificationCenter.default.addObserver(self, selector: #selector(handleData(notification:)), name: .refereshCallData, object: nil)
        self.startCallCutTimer()
        self.flipBtn.setImage(UIImage.generatedFlipIcon(selected: false), for: .normal)
    }
    
    @objc func handleData(notification: Notification) {
//        self.leaveChannel()
//        PIPKit.dismiss(animated: true)
        disconnectCallAndDismiss()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .refereshCallData, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopCallCutTimer()
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
//        self.pipStatus = true
//        self.setUpPipVw()
        isStartButtonPressed = true
        startPiP()
      
    }
    
    @IBAction func pipBtn_Action(_ sender: Any) {
//        self.pipStatus = false
//        self.setUpPipVw()
    }
    
    @IBAction func flipBtn_Action(_ sender: Any) {
        self.isUsingFrontCamera.toggle()
        self.agoraKit?.switchCamera()
        self.updateVideoMirrorMode()
        self.flipBtn.setImage(UIImage.generatedFlipIcon(selected: !self.isUsingFrontCamera), for: .normal)
    }
    
    @IBAction func cameraBtn_Action(_ sender: Any) {
        self.isUsingLocalCamera = !self.isUsingLocalCamera
        // Track the user's manual preference so poor-network recovery never re-enables a camera
        // the user turned off on purpose.
        self.connectionManager.updateUserVideoEnabled(self.isUsingLocalCamera)
        self.agoraKit?.enableLocalVideo(self.isUsingLocalCamera)
        if self.isUsingLocalCamera {
            self.cameraBtn.setImage(UIImage(named: "videoOn"), for: .normal)
            self.localVideoView.setPaused(false)
        }else{
            self.cameraBtn.setImage(UIImage(named: "videoOff"), for: .normal)
            self.localVideoView.setPaused(true)
        }
    }
    
    @IBAction func audioBtn_Action(_ sender: Any) {
        self.isMuted = !self.isMuted
        self.agoraKit?.muteLocalAudioStream(isMuted)
        if isMuted {
            self.audioBtn.setImage(UIImage(named: "mikeOff"), for: .normal)
        } else {
            self.audioBtn.setImage(UIImage(named: "mikeOn"), for: .normal)
        }
    }
    
    @IBAction func callBtn_Action(_ sender: Any) {
        guard self.userConnect else {
//            self.leaveChannel()
//            PIPKit.dismiss(animated: true)
            self.disconnectCallAndDismiss(myself: true)
            self.cutCallApi()
            return
        }
        EndCallPopUp.instance.showAlertViewwPopUp(title: self.patientName ?? EMPTY)
        EndCallPopUp.instance.endCallButtonCallBack = {
            self.delegate?.videoCallData(patientName: self.patientName ?? EMPTY, bookingId: self.bookingId ?? EMPTY, callDuration: self.timerLbl.text ?? EMPTY)
//            self.leaveChannel()
//            PIPKit.dismiss(animated: true)
            self.disconnectCallAndDismiss(myself: true)
        }
    }
    
    func disconnectCallAndDismiss(myself:Bool = false,isLogout:Bool = false) {

        // Stop timer
        stopTimer()

        // Reset reconnect/network state so nothing fires after teardown
        connectionManager.reset()
        isRemoteConnectionBlurActive = false
        isRemoteVideoStreamStuckBlurActive = false
        isRemoteNetworkPoorBlurActive = false
        isLocalNetworkPoorIndicatorActive = false
        remoteVideoBlurVw.isHidden = true
        weakConnectionIndicatorVw.hide()

        // MARK: Stop PiP first
        if pipController?.isPictureInPictureActive == true {
            pipController?.stopPictureInPicture()
        }
        pipVideoCallVC?.view.removeFromSuperview()
          pipVideoCallVC = nil
          pipController?.delegate = nil
          pipController = nil

        // Leave Agora
        agoraKit?.stopPreview()
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
        agoraKit = nil

        // Remove views
        remoteVideoView.flush()
        localVideoView.flush()

        // Remove presented screens
        self.dismiss(animated: false)

        if isLogout {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.setLoginViewController()
        }


        // if myself{
        //     DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //         let chatViewC = DIConfigurator.sharedInst().getChatViewC()
        //         chatViewC.senderId = self.doctorId
        //         chatViewC.recieverId = self.userId
        //         chatViewC.roomId = self.bookingId
        //         chatViewC.profilePic = ""
        //         chatViewC.patientName = self.patientName
        //         chatViewC.sinchToken = self.channelId
        //         chatViewC.userId = self.userId
        //         chatViewC.bookingId = self.bookingId
        //         chatViewC.doctorId = self.doctorId
        //         chatViewC.rtcAgoroToken = self.rtcAgoroToken

        //         DIConfigurator.sharedInst().setVideoCallAsRoot(viewC: chatViewC)
        //     }
        // }else if isLogout{
        //     let appDel = UIApplication.shared.delegate as! AppDelegate
        //     appDel.setLoginViewController()
        // }else{
        //     DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //         let chatViewC = DIConfigurator.sharedInst().getChatViewC()
        //         chatViewC.senderId = self.doctorId
        //         chatViewC.recieverId = self.userId
        //         chatViewC.roomId = self.bookingId
        //         chatViewC.profilePic = ""
        //         chatViewC.patientName = self.patientName
        //         chatViewC.sinchToken = self.channelId
        //         chatViewC.userId = self.userId
        //         chatViewC.bookingId = self.bookingId
        //         chatViewC.doctorId = self.doctorId
        //         chatViewC.rtcAgoroToken = self.rtcAgoroToken

        //         DIConfigurator.sharedInst().setVideoCallAsRoot(viewC: chatViewC)
        //     }
        // }
    }
}

protocol VideoCallData {
    func videoCallData(patientName: String, bookingId: String, callDuration: String)
}


extension UIView {
    func embed(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

    //============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================


import Foundation
import AgoraRtcKit
import PIPKit
import AVKit


extension VideoCallViewC{
    // MARK: Create PiP

    func createPiP() {
//
        let vc = PiPVideoCallViewController(
            localView:localVideoView,
            remoteView: remoteVideoView
        )
        vc.preferredContentSize = CGSize(width: 9, height: 16)

        self.pipVideoCallVC = vc
//        PiPWindowManager.shared.showPiPWindow(
//            localView: localVideoView,
//            remoteView: remoteVideoView
//        )
//        guard let pipVC =
//                    PiPWindowManager.shared.pipViewController
//            else {
//                return
//            }
                  let source =
                  AVPictureInPictureController.ContentSource(
                    activeVideoCallSourceView: remoteVideoView,
                      contentViewController: vc
                  )
 
        
        let pipController =
        AVPictureInPictureController(
            contentSource: source
        )
        
        pipController.delegate = self
        
//        pipController.requiresLinearPlayback = true
        
        pipController
            .canStartPictureInPictureAutomaticallyFromInline = true
        
        self.pipController = pipController
                
    }

    // MARK:  PiP
    func startPiP() {
        guard let pipController = pipController else {
            print("PiP not initialized")
            return
        }

        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("PiP not supported on this device")
            return
        }

        pipController.startPictureInPicture()
    }

    // MARK: Stop PiP

    func stopPiP() {

        pipController?
            .stopPictureInPicture()
    }
}

extension VideoCallViewC {
    
    func loadAgoraLiveStreamingKit(room:String,token:String,uid:UInt) {
        self.setIdleTimerActive(false)
        self.agoraKit?.delegate = self
        self.agoraKit?.setChannelProfile(.communication)
        self.agoraKit?.setClientRole(self.role)
        self.agoraKit?.enableDualStreamMode(false)
        self.agoraKit?.enableVideo()
        self.agoraKit?.startPreview()
        self.agoraKit?.setEnableSpeakerphone(true)
        self.agoraKit?.setParameters("""
            {
                "rtc.video.enable_multitask": true
            }
            """)

            self.agoraKit?.setParameters("""
            {
                "che.video.enableBackgroundVideo": true
            }
            """)
        agoraKit?.setVideoFrameDelegate(self)
        self.updateVideoMirrorMode()
        self.agoraKit?.joinChannel(byToken: token, channelId: room, info: nil, uid: uid ,joinSuccess: { _, _, _ in
            print("success")
        })
        
    }
    
    private func updateVideoMirrorMode() {
        let videoConfig = AgoraVideoEncoderConfiguration(
            size: self.dimension,
            frameRate: self.framerate,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative,
            mirrorMode: self.isUsingFrontCamera ? .enabled : .disabled
        )
        self.agoraKit?.setVideoEncoderConfiguration(videoConfig)
    }
    
//    func addLocalAudio() {
//        self.agoraKit?.enableAudio() // Enable audio
//    }
    
//    func leaveChannel(){
//        print("@@@@@@@@@@@@@@@@@@@@@@@@@@ Leave Channnel @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
// 
//        self.agoraKit?.leaveChannel { (stats) in
//            print("Left channel with stats: \(stats)")
//        }
//        AgoraRtcEngineKit.destroy()
//        self.agoraKit = nil
//    }
    
//    func setIdleTimerActive(_ active: Bool) {
//        UIApplication.shared.isIdleTimerDisabled = !active
//    }
    
}

// MARK: - AgoraRtcEngineDelegate
//extension VideoCallViewC: AgoraRtcEngineDelegate {
    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
//        print(size)
//    }
    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
//        print("didOfflineOfUid")
//                stopTimer()
//                self.pipStatus = false
//                self.setUpPipVw()
//                self.leaveChannel()
//                CallManager.shared.endCall()
//                DIConfigurator.sharedInst().getRootViewC(.Main, identifer: HomeViewC.className)
//                disconnectCallAndDismiss()
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
//        print("Video Send/Recv: \(stats.txVideoKBitrate)kbps/\(stats.rxVideoKBitrate)kbps")
//        if stats.rxVideoKBitrate == 0 {
//            self.videoDefaultVw.isHidden = false
//            self.patientNameLbl.textColor = UIColor.black
//            self.clockImage.tintColor = UIColor.black
//            self.timerLbl.textColor = UIColor.black
//        }else{
//            self.videoDefaultVw.isHidden = true
//            self.patientNameLbl.textColor = UIColor.white
//            self.clockImage.tintColor = UIColor.white
//            self.timerLbl.textColor = UIColor.white
//        }
//    }
    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
//        print("didJoinChannel")
//    }
    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
//        print("didJoinedOfUid")
//        self.startTimer()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.createPiP()
//        }
//    }
    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didjoin channel: String, withUid uid: UInt, elapsed: Int) {
//        print("didjoin channel")
//    }
//}
// MARK: - AgoraRtcEngineDelegate
extension VideoCallViewC: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        print(size)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("didOfflineOfUid reason=\(reason.rawValue)")
        guard self.userConnect else { return }
        // Let the connection manager decide: .quit ends the call immediately, .dropped /
        // .becomeAudience / unknown reasons keep the call alive and start a reconnect window.
        connectionManager.handleUserOffline(uid: uid, reason: reason)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionState, reason: AgoraConnectionChangedReason) {
        print("connectionChangedTo state=\(state.rawValue) reason=\(reason.rawValue)")
        connectionManager.handleConnectionStateChanged(state: state, reason: reason)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, networkQuality uid: UInt, txQuality: AgoraNetworkQuality, rxQuality: AgoraNetworkQuality) {
        // uid == 0 identifies the local user in this callback; any other uid is a remote user
        // (matched against the joined remote uid inside the manager).
        if uid == 0 {
            connectionManager.handleLocalNetworkQuality(txQuality: txQuality, rxQuality: rxQuality)
        } else {
            connectionManager.handleRemoteNetworkQuality(uid: uid, txQuality: txQuality, rxQuality: rxQuality)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
        connectionManager.handleRemoteAudioStats(uid: stats.uid, audioLossRate: UInt(stats.audioLossRate))
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        connectionManager.handleRemoteVideoStats(uid: stats.uid, packetLossRate: UInt(stats.packetLossRate))
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        // print("Video Send/Recv: \(stats.txVideoKBitrate)kbps/\(stats.rxVideoKBitrate)kbps")
        
        // Hide the default placeholder view since we are handling remote video and blur now
        self.videoDefaultVw.isHidden = true
        
        // Ensure overlay labels remain visible against the dark video/blur background
        self.timerImage.tintColor = UIColor.white
        self.timerLbl.textColor = UIColor.white
        self.titleNameLbl.tintColor = UIColor.white
        
        connectionManager.handleRemoteVideoBitrate(rxVideoKBitrate: Int(stats.rxVideoKBitrate))
        
        if stats.rxVideoKBitrate == 0 {
            // No incoming remote video bitrate even though the call itself is connected —
            // the remote camera is off, or the stream is frozen/stuck. Blur the last frame.
            self.setRemoteVideoStreamStuckBlur(true)
        }else{
            self.setRemoteVideoStreamStuckBlur(false)
        }
    }
    
//    func rtcEngine(_ engine: AgoraRtwhatcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
//        print("=====================\(uid)==============================")
//        print(size)
//        self.remoteCanvas = AgoraRtcVideoCanvas()
//        self.remoteCanvas.uid = uid
//        self.remoteCanvas.view = self.videoVw
//        self.agoraKit?.setupRemoteVideo(self.remoteCanvas)
//        if #available(iOS 15.0, *) {
////            self.setupPictureInPicture()
//            self.createPiP()
//        }
//    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("didJoinChannel")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("didJoinedOfUid")
        self.userConnect = true
        
        // Start 10-second grace period for weak connection indicator only after both parties are connected
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            guard let self = self else { return }
            self.isWeakConnectionInitialDelayPassed = true
            self.updateWeakConnectionIndicatorVisibility()
        }
        
        self.updateWeakConnectionIndicatorVisibility()
        self.connectionManager.markUserJoined(uid: uid)
        self.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.createPiP()
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didjoin channel: String, withUid uid: UInt, elapsed: Int) {
        print("didjoin channel")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState, reason: AgoraVideoRemoteReason, elapsed: Int) {
        DispatchQueue.main.async {
            if reason == .remoteMuted {
                self.remoteVideoView.setPaused(true)
            } else if reason == .remoteUnmuted {
                self.remoteVideoView.setPaused(false)
            }
        }
    }
}

// MARK: - Agora Video Frame Delegate

extension VideoCallViewC:
AgoraVideoFrameDelegate {

    // REQUIRED

    func getVideoFormatPreference()
    -> AgoraVideoFormat {

        .cvPixelNV12
    }

    // MARK: Local Frames

    func onCapture(
        _ videoFrame: AgoraOutputVideoFrame,
        sourceType: AgoraVideoSourceType
    ) -> Bool {

//        print("LOCAL FRAME")

        guard let pixelBuffer =
                videoFrame.pixelBuffer else {
            return true
        }
        
        var finalBuffer = pixelBuffer
        
        if self.isUsingFrontCamera {
            if let mirroredBuffer = rotatePixelBuffer(
                pixelBuffer,
                rotation: 0,
                mirror: true
            ) {
                finalBuffer = mirroredBuffer
            }
        }

        guard let sampleBuffer =
                makeSampleBuffer(
                    pixelBuffer: finalBuffer
                ) else {
            return true
        }

        DispatchQueue.main.async {
                    self.localVideoView.enqueue(sampleBuffer)
        }

        return true
    }

    // MARK: Remote Frames
    func onRenderVideoFrame(_ videoFrame: AgoraOutputVideoFrame, uid: UInt, channelId: String) -> Bool {
        guard let pixelBuffer =
                videoFrame.pixelBuffer else {
            return true
        }
        // APPLY ROTATION
           guard let rotatedBuffer = rotatePixelBuffer(
               pixelBuffer,
               rotation: videoFrame.rotation
           ) else {
               return true
           }

        guard let sampleBuffer =
                makeSampleBuffer(
                    pixelBuffer: rotatedBuffer
                ) else {
            return true
        }
        DispatchQueue.main.async {
                self.remoteVideoView.enqueue(sampleBuffer)
        }

        return true
    }
}

// MARK: - PiP Delegate

//extension VideoCallViewC:
//AVPictureInPictureControllerDelegate {
//
//    func pictureInPictureControllerDidStartPictureInPicture(
//        _ pictureInPictureController:
//        AVPictureInPictureController
//    ) {
//        print("PiP Started")
//        if isStartButtonPressed{
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
//                let viewC = (UIApplication.shared.delegate as! AppDelegate).drawerController
//                self.navigationController?.pushViewController(viewC, animated: true)
//            }
//        }
//        
//    }
//
//    func pictureInPictureControllerDidStopPictureInPicture(
//        _ pictureInPictureController:
//        AVPictureInPictureController
//    ) {
//        print("PiP Stopped")
//        guard !isLoggingOut else {
//              return
//          }
//        if isStartButtonPressed{
//            isStartButtonPressed = false
//        }
//        DispatchQueue.main.async {
//            
//            self.pipVideoCallVC?.view.removeFromSuperview()
//            self.pipVideoCallVC = nil
//            self.pipController = nil
//            self.videoVw.embed(self.remoteVideoView)
//            self.draggableView.embed(self.localVideoView)
//            
//            // FORCE SWIFTUI TO REBUILD VIEWS
////            self.refreshID = UUID()
//            self.restoreToVideoCallScreen()
//        }
//    }
//
//    func pictureInPictureController(
//        _ pictureInPictureController:
//        AVPictureInPictureController,
//        failedToStartPictureInPictureWithError error: Error
//    ) {
//        isStartButtonPressed = false
//        print(error.localizedDescription)
//    }
//    
//    
//    func restoreToVideoCallScreen() {
//
//        DispatchQueue.main.async {
//            // 2. Dismiss any presented controllers
//            self.view.window?.rootViewController?.dismiss(animated: false)
//
//            // 3. Pop to VideoCallViewC in navigation stack
//            if let nav = self.navigationController {
//                for vc in nav.viewControllers {
//                    if vc is VideoCallViewC {
//                        nav.popToViewController(vc, animated: false)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//                            self.createPiP()
//                        }
//                        return
//                    }
//                }
//                // fallback: if not found, reset stack
//                nav.popToRootViewController(animated: false)
//            }
//
//            // 4. Ensure VideoCallViewC is visible
//            self.view.isHidden = false
//            self.view.alpha = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//                self.createPiP()
//            }
//        }
//        
//    }
//}

extension VideoCallViewC:
AVPictureInPictureControllerDelegate {

    func pictureInPictureControllerDidStartPictureInPicture(
        _ pictureInPictureController:
        AVPictureInPictureController
    ) {
        print("PiP Started")
        
        // Keep the call alive in memory while it is dismissed
        VideoCallViewC.pipKeepAlive = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            // Dismiss the modal so the user can interact with the app underneath,
            // but only if PiP is still active (prevents race condition if user restores immediately)
            if self.pipController?.isPictureInPictureActive == true {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    func pictureInPictureControllerDidStopPictureInPicture(
        _ pictureInPictureController:
        AVPictureInPictureController
    ) {
        print("PiP Stopped")
        
        // Release the strong reference
        VideoCallViewC.pipKeepAlive = nil
        
        guard !isLoggingOut else {
              return
          }
        if isStartButtonPressed{
            isStartButtonPressed = false
        }
        
        // If the user closed the PiP window directly (tapped X) instead of restoring
        if self.view.window == nil {
            self.disconnectCallAndDismiss(myself: true)
            self.cutCallApi()
            return
        }
        
        DispatchQueue.main.async {
            
            self.pipVideoCallVC?.view.removeFromSuperview()
            self.pipVideoCallVC = nil
            self.pipController = nil
            self.videoVw.embed(self.remoteVideoView)
            self.draggableView.embed(self.localVideoView)
            
            // Re-create PiP so it is ready for the next time the app is backgrounded
            self.createPiP()
        }
    }

    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
    ) {
        DispatchQueue.main.async {
            if let topVC = UIApplication.topViewController(), topVC != self, topVC != self.navigationController {
                if let nav = self.navigationController {
                    topVC.present(nav, animated: true) {
                        completionHandler(true)
                    }
                } else {
                    let nav = UINavigationController(rootViewController: self)
                    nav.modalPresentationStyle = .fullScreen
                    nav.isNavigationBarHidden = true
                    topVC.present(nav, animated: true) {
                        completionHandler(true)
                    }
                }
            } else {
                completionHandler(true)
            }
        }
    }

    func pictureInPictureController(
        _ pictureInPictureController:
        AVPictureInPictureController,
        failedToStartPictureInPictureWithError error: Error
    ) {
        isStartButtonPressed = false
        print(error.localizedDescription)
    }
    
    
    func restoreToVideoCallScreen() {
        // Obsolete: navigation is now handled automatically via standard PiP delegate methods
    }
}

// MARK: - PiP Playback Delegate

//extension VideoCallViewC:
//AVPictureInPictureSampleBufferPlaybackDelegate {
//
//    func pictureInPictureController(
//        _ pictureInPictureController:
//        AVPictureInPictureController,
//        setPlaying playing: Bool
//    ) {
//    }
//
//    func pictureInPictureControllerTimeRangeForPlayback(
//        _ pictureInPictureController:
//        AVPictureInPictureController
//    ) -> CMTimeRange {
//
//        CMTimeRange(
//            start: .negativeInfinity,
//            duration: .positiveInfinity
//        )
//    }
//
//    func pictureInPictureControllerIsPlaybackPaused(
//        _ pictureInPictureController:
//        AVPictureInPictureController
//    ) -> Bool {
//
//        false
//    }
//
//    func pictureInPictureController(
//        _ pictureInPictureController:
//        AVPictureInPictureController,
//        skipByInterval skipInterval: CMTime,
//        completion completionHandler:
//        @escaping () -> Void
//    ) {
//
//        completionHandler()
//    }
//
//    func pictureInPictureController(
//        _ pictureInPictureController:
//        AVPictureInPictureController,
//        didTransitionToRenderSize newRenderSize:
//        CMVideoDimensions
//    ) {
//    }
//}

// MARK: - Sample Buffer

extension VideoCallViewC {
    func rotatePixelBuffer(
        _ pixelBuffer: CVPixelBuffer,
        rotation: Int32,
        mirror: Bool = false
    ) -> CVPixelBuffer? {

        if rotation == 0 && !mirror {
            return pixelBuffer
        }

        let sourceImage = CIImage(cvPixelBuffer: pixelBuffer)

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        var transform = CGAffineTransform.identity

        switch rotation {

        case 90:
            transform = CGAffineTransform(
                translationX: CGFloat(height),
                y: 0
            ).rotated(by: .pi / 2)

        case 180:
            transform = CGAffineTransform(
                translationX: CGFloat(width),
                y: CGFloat(height)
            ).rotated(by: .pi)

        case 270:

            transform =
            CGAffineTransform(
                translationX: 0,
                y: CGFloat(width)
            )
            .rotated(by: -.pi / 2)
            .scaledBy(x: -1, y: 1)
            .translatedBy(x: -CGFloat(height), y: 0)

        default:
            break
        }

        let rotatedImage =
        sourceImage.transformed(by: transform)

        let outputWidth =
        (rotation == 90 || rotation == 270)
        ? height
        : width

        let outputHeight =
        (rotation == 90 || rotation == 270)
        ? width
        : height
        
        // if mirror {
        //     let mirrorTransform = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: CGFloat(outputWidth), ty: 0)
        //     transform = transform.concatenating(mirrorTransform)
        // }

        var outputBuffer: CVPixelBuffer?

        let attrs: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferIOSurfacePropertiesKey: [:]
        ]

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            outputWidth,
            outputHeight,
            kCVPixelFormatType_32BGRA,
            attrs as CFDictionary,
            &outputBuffer
        )

        guard let outputBuffer else {
            return nil
        }
        
        var normalizedImage =
        rotatedImage.transformed(
            by: CGAffineTransform(
                translationX: -rotatedImage.extent.origin.x,
                y: -rotatedImage.extent.origin.y
            )
        )

         if mirror {
            normalizedImage = normalizedImage.transformed(
                by: CGAffineTransform(translationX: normalizedImage.extent.width, y: 0)
                    .scaledBy(x: -1, y: 1)
            )
        }

        ciContext.render(
            normalizedImage,
            to: outputBuffer
        )

        return outputBuffer
    }

    func makeSampleBuffer(
        pixelBuffer: CVPixelBuffer
    ) -> CMSampleBuffer? {

        var timing = CMSampleTimingInfo(
            duration: CMTime(
                value: 1,
                timescale: 30
            ),
            presentationTimeStamp:
                CMClockGetTime(
                    CMClockGetHostTimeClock()
                ),
            decodeTimeStamp: .invalid
        )

        var formatDescription:
        CMVideoFormatDescription?

        CMVideoFormatDescriptionCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            formatDescriptionOut:
                &formatDescription
        )

        guard let formatDescription else {
            return nil
        }

        var sampleBuffer: CMSampleBuffer?

        CMSampleBufferCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            dataReady: true,
            makeDataReadyCallback: nil,
            refcon: nil,
            formatDescription: formatDescription,
            sampleTiming: &timing,
            sampleBufferOut: &sampleBuffer
        )

        return sampleBuffer
    }
}

import UIKit
import CoreMedia
import AVFoundation

final class PiPVideoView: UIView {

    let displayLayer = AVSampleBufferDisplayLayer()
    let pausedLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black

        displayLayer.frame = bounds
        displayLayer.videoGravity = .resizeAspectFill

        layer.addSublayer(displayLayer)
        
        pausedLabel.text = "Video paused"
        pausedLabel.textColor = .white
        pausedLabel.textAlignment = .center
        pausedLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        pausedLabel.isHidden = true
        addSubview(pausedLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        displayLayer.frame = bounds
        pausedLabel.frame = bounds
    }

    func enqueue(_ sampleBuffer: CMSampleBuffer) {
        guard displayLayer.isReadyForMoreMediaData else {
            return
        }
        displayLayer.enqueue(sampleBuffer)
    }

    func flush() {
        displayLayer.flushAndRemoveImage()
    }
    
    func setPaused(_ isPaused: Bool) {
        pausedLabel.isHidden = !isPaused
        displayLayer.isHidden = isPaused
    }
}


import UIKit
import AVKit

final class PiPVideoCallViewController:
AVPictureInPictureVideoCallViewController {

    let localView: PiPVideoView
    let remoteView: PiPVideoView

    // MARK: - Constraints

    private var localWidthConstraint: NSLayoutConstraint!
    private var localHeightConstraint: NSLayoutConstraint!

    private var localTrailingCons: NSLayoutConstraint!
    private var localBottomCons: NSLayoutConstraint!

    // MARK: - Init

    init(
        localView: PiPVideoView,
        remoteView: PiPVideoView
    ) {

        self.localView = localView
        self.remoteView = remoteView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupLayout()
    }

    // MARK: - Layout

    private func setupLayout() {

        localView.translatesAutoresizingMaskIntoConstraints = false
        remoteView.translatesAutoresizingMaskIntoConstraints = false

        // Fullscreen view
        view.addSubview(remoteView)

        // Overlay view
        view.addSubview(localView)

        // Size constraints
        localWidthConstraint =
        localView.widthAnchor.constraint(equalToConstant: 80)

        localHeightConstraint =
        localView.heightAnchor.constraint(equalToConstant: 120)

        // Position constraints
        localTrailingCons =
        localView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -16
        )

        localBottomCons =
        localView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -16
        )

        NSLayoutConstraint.activate([

            // MARK: Remote Fullscreen

            remoteView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            remoteView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            remoteView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),

            remoteView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            // MARK: Local Overlay

            localWidthConstraint,
            localHeightConstraint,

            localTrailingCons,
            localBottomCons
        ])

        localView.layer.cornerRadius = 12
        localView.clipsToBounds = true
    }

    // MARK: - Resize Detection

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        print("PiP Size:", view.bounds.size)

        updateOverlaySize()
    }

    // MARK: - Dynamic Resize

    private func updateOverlaySize() {

        let width = view.bounds.width
        let height = view.bounds.height
        print("PiP width:", width)
        print("PiP height:", height)
        
        //PiP Size: (110.0, 195.5)
       // PiP Size: (191.5, 340.0)

        // Small PiP
        if width < 150 {
            localWidthConstraint.constant = 30
            localHeightConstraint.constant = 50

            localTrailingCons.constant = -8
            localBottomCons.constant = -8
            localView.layer.cornerRadius = 6
            localView.clipsToBounds = true
         } else{
            localWidthConstraint.constant = 50
            localHeightConstraint.constant = 70

            localTrailingCons.constant = -8
            localBottomCons.constant = -8
             localView.layer.cornerRadius = 6
             localView.clipsToBounds = true
        }
        view.layoutIfNeeded()
    }
}




import UIKit

//final class PiPWindowManager {
//
//    static let shared = PiPWindowManager()
//
//    private var pipWindow: UIWindow?
//    var pipViewController: PiPVideoCallViewController?
//    private init() {}
//
//    // MARK: Show PiP Scene
//
//    func showPiPWindow(
//        localView: PiPVideoView,
//        remoteView: PiPVideoView
//    ) {
//
//        guard pipWindow == nil else { return }
//
//        guard let scene =
//            UIApplication.shared.connectedScenes.first
//                as? UIWindowScene else {
//            return
//        }
//
//        let vc = PiPVideoCallViewController(
//            localView: localView,
//            remoteView: remoteView
//        )
//        self.pipViewController = vc
//
//        let window = UIWindow(windowScene: scene)
//
//        window.rootViewController = vc
//
//        // ABOVE MAIN UI
//        window.windowLevel = .alert + 1
//
//        window.backgroundColor = .clear
//
//        window.makeKeyAndVisible()
//
//        pipWindow = window
//    }
//
//    // MARK: Hide
//
//    func hidePiPWindow() {
//
//        pipWindow?.isHidden = true
//    }
//
//    // MARK: Destroy
//
//    func destroyPiPWindow() {
//        pipViewController = nil
//        pipWindow?.isHidden = true
//        pipWindow?.rootViewController = nil
//        pipWindow = nil
//    }
//}

extension UIImage {
    static func generatedFlipIcon(selected: Bool) -> UIImage? {
        let size = CGSize(width: 60, height: 60)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        
        let ellipseRect = CGRect(origin: .zero, size: size)
        if selected {
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fillEllipse(in: ellipseRect)
        } else {
            ctx.setFillColor(UIColor(white: 0.25, alpha: 0.6).cgColor)
            ctx.fillEllipse(in: ellipseRect)
            
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(0.5)
            ctx.strokeEllipse(in: ellipseRect.insetBy(dx: 0.25, dy: 0.25))
        }
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        if let symbol = UIImage(systemName: "camera.rotate", withConfiguration: config) {
            let iconColor = selected ? UIColor.black : UIColor.white
            let tintedSymbol = symbol.withTintColor(iconColor, renderingMode: .alwaysOriginal)
            let rect = CGRect(x: (size.width - symbol.size.width)/2, 
                              y: (size.height - symbol.size.height)/2, 
                              width: symbol.size.width, 
                              height: symbol.size.height)
            tintedSymbol.draw(in: rect)
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img?.withRenderingMode(.alwaysOriginal)
    }
}
