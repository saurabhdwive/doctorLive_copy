//
//  VideoCallViewC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 05/11/24.
//

import Foundation
import AgoraRtcKit
import PIPKit
import UIKit

extension VideoCallViewC{
    func setUpDragableVw(){
        let frame = CGRect(x: self.view.frame.width - 20 - 124, y:  self.view.frame.height / 2, width: 124, height: 174)
        self.draggableView = DraggableView(frame: frame)
        self.draggableView.backgroundColor = UIColor.white
        self.draggableView.layer.cornerRadius = 8
        self.draggableView.clipsToBounds = true
        self.view.addSubview(self.draggableView)
        let localDefaultImage = UIImageView(frame: self.draggableView.bounds)
        localDefaultImage.image = UIImage(named: "patienVideoCall")
        localDefaultImage.contentMode = .scaleAspectFill
        localDefaultImage.clipsToBounds = true
        self.draggableView.addSubview(localDefaultImage)
        videoVw.embed(remoteVideoView)
        draggableView.embed(localVideoView)
    }
    
    func setUpAgora(){
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "22aaa70bf7d74229b5bfa9a9d75ba9e0", delegate: nil)
//        self.remoteCanvas.view = self.videoVw
//        self.localCanvas.view = self.draggableView
//        self.loadAgoraLiveStreamingKit(uid: UInt(0), channelId: self.channelId ?? EMPTY, token: self.rtcAgoroToken ?? EMPTY)
        self.loadAgoraLiveStreamingKit(room: self.channelId ?? EMPTY, token: self.rtcAgoroToken ?? EMPTY, uid: UInt(0))
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func startCallCutTimer(){
        self.callCutTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCallCutTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func stopCallCutTimer() {
        self.callCutTimer?.invalidate()
        self.callCutTimer = nil
    }
    
    @objc func updateTimer() {
        self.elapsedTime += 1
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        self.timerLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @objc func updateCallCutTimer(){
        self.callCutElapsedTime -= 1
        if self.userConnect == true {
            self.stopCallCutTimer()
        }else{
            if self.callCutElapsedTime == 0 {
//                self.leaveChannel()
//                PIPKit.dismiss(animated: true)
                self.disconnectCallAndDismiss(myself: true)
                self.cutCallApi()
            }
        }
    }
    
    func setUpPipVw(){
        self.fotterVw.isHidden = self.pipStatus
        self.pipBtn.isHidden = self.pipStatus
        self.titleNameLbl.isHidden = self.pipStatus
        self.timerVw.isHidden = self.pipStatus
        self.draggableView.isHidden = self.pipStatus
        self.pipBtn.isHidden = !self.pipStatus
        self.videoDefaultVw.isHidden = self.pipStatus
        self.navigationController?.isNavigationBarHidden = self.pipStatus
        guard self.pipStatus else {
            UIView.animate(withDuration: 0.5) {
                self.stopPIPMode()
            }
            return
        }
        UIView.animate(withDuration: 0.5) {
            self.startPIPMode()
        }
    }
    
    func didChangedState(_ state: PIPState) {
        if state == .pip{
            setNeedsUpdatePIPFrame()
        }
    }
}

