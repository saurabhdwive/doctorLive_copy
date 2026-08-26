//
//  RecorderVC.swift
//  Dr.Live
//
//  Created by Kv on 08/01/25.
//

import UIKit

class RecorderVC: UIViewController {

    @IBOutlet weak var deleteBtn, holdBtn, sendBtn: UIButton!
    @IBOutlet weak var startRecordLbl, timerLbl: UILabel!
    @IBOutlet weak var bottomVw, recordVw: UIView!
    
    var recorder = AKAudioRecorder.shared
    var displayLink = CADisplayLink()
    var duration : CGFloat = 0.0
    var timer : Timer!
    var recordedAudioFile = String()
    var callBackRecordedFile : ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
    }
    
    private func setUpViews(){
        GlobalMethods.shared.provideThreeCornerRadius(view: self.bottomVw, cornerRadius: 20, cornerArray: [.layerMaxXMinYCorner,.layerMinXMinYCorner])
        self.recordVw.layer.cornerRadius = 36
        self.recordVw.layer.borderWidth = 2
        self.recordVw.layer.borderColor = UIColor(named: "black-white")?.cgColor ?? UIColor.gray.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.recorder.myRecordings.removeAll()
    }
    
    @IBAction func backBtn_Actioj(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func crossBtn_Action(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func holdBtn_Action(_ sender: Any) {
        let recordings = recorder.getRecordings
        
        if self.recorder.isPlaying {
            self.recorder.stopPlaying()
            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
        } else if self.recorder.isRecording {
            self.animate(isRecording: true)
            self.recorder.stopRecording()
            self.deleteBtn.isHidden = false
            self.sendBtn.isHidden = false
            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
            self.timerLbl.text = self.recorder.duration.timeStringFormatter
        } else if !recordings.isEmpty {
            self.recorder.play(name: recordings[0])
            self.holdBtn.setImage(UIImage(named: "Path 60_Video_2"), for: .normal)
            self.timerLbl.text = self.recorder.duration.timeStringFormatter
        } else {
            self.animate(isRecording: false)
            self.recorder.record()
            self.deleteBtn.isHidden = true
            self.sendBtn.isHidden = true
            self.setTimer()
        }
        
        self.recorder.stopRecordingCallBack = { time in
            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
            self.timerLbl.text = time
        }
        self.recorder.startPlayingCallBack = {
            self.holdBtn.setImage(UIImage(named: "Path 60_Video_2"), for: .normal)
        }
        self.recorder.stopPlayingCallBack = {
            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
            self.timerLbl.text = "\(self.recorder.updatedRecordedTime)"
        }
    }
    
    @IBAction func deleteBtn_Action(_ sender: Any) {
        self.recorder.myRecordings.removeAll()
        self.timerLbl.text = ""
        self.holdBtn.backgroundColor = .red
        self.sendBtn.isHidden = true
        self.deleteBtn.isHidden = true
    }
    
    @IBAction func sendBtn_Action(_ sender: Any) {
        let reordingFile = recorder.getRecordings
        if reordingFile.count > 0 {
            let audioFilename = recorder.getDocumentsDirectory().appendingPathComponent(reordingFile[0].appending(".m4a"))
            callBackRecordedFile?(audioFilename.path)
            self.dismiss(animated: true)
        }
    }
}
