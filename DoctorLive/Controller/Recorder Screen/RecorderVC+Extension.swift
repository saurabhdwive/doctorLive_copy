//
//  RecorderVC+Extension.swift
//  Dr.Live
//
//  Created by Kv on 08/01/25.
//

import Foundation
import UIKit

extension RecorderVC{
    func animate(isRecording : Bool){
        if isRecording{
            self.holdBtn.layer.cornerRadius = 4
            UIView.animate(withDuration: 0.1) {
                self.holdBtn.transform = CGAffineTransform(scaleX: 2, y: 2)
                self.holdBtn.layer.cornerRadius = 15
            }
        }else{
            UIView.animate(withDuration: 0.1) {
                self.holdBtn.transform = .identity
                self.holdBtn.layer.cornerRadius = 4
            }
        }
    }
    
    func setCircle(){
        self.holdBtn.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.holdBtn.layer.cornerRadius = 15
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDuration), userInfo: nil, repeats: true)
    }
    
    @objc func updateDuration() {
        if recorder.isRecording && !recorder.isPlaying{
            duration += 1
            self.timerLbl.alpha = 1
            self.timerLbl.text = duration.timeStringFormatter
        }else{
            timer.invalidate()
            duration = 0
            self.timerLbl.text = duration.timeStringFormatter
            
        }
    }
}
