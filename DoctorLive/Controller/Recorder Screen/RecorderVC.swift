//
//  RecorderVC.swift
//  Dr.Live
//
//  Created by Kv on 08/01/25.
//

import UIKit
import Lottie

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
    
    var newTimerLbl: UILabel!
    var waveLottieView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        
        // Auto start recording for new UI
        self.recorder.record()
        self.setTimer()
        self.waveLottieView.play()
    }
    
    private func setUpViews(){
        /*
        GlobalMethods.shared.provideThreeCornerRadius(view: self.bottomVw, cornerRadius: 20, cornerArray: [.layerMaxXMinYCorner,.layerMinXMinYCorner])
        */
        self.bottomVw.isHidden = true
        self.recordVw.isHidden = true
        
        setupNewRecorderUI()
    }
    
    private func setupNewRecorderUI() {
        let capsuleView = UIView()
        capsuleView.backgroundColor = UIColor(red: 27/255, green: 115/255, blue: 186/255, alpha: 1) // Match image blue approx
        capsuleView.layer.cornerRadius = 25
        capsuleView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(capsuleView)
        
        NSLayoutConstraint.activate([
            capsuleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            capsuleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            capsuleView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            capsuleView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let newDeleteBtn = UIButton(type: .system)
        newDeleteBtn.setImage(UIImage(systemName: "trash"), for: .normal)
        newDeleteBtn.tintColor = .white
        newDeleteBtn.translatesAutoresizingMaskIntoConstraints = false
        newDeleteBtn.addTarget(self, action: #selector(newDeleteAction), for: .touchUpInside)
        capsuleView.addSubview(newDeleteBtn)
        
        let newSendBtn = UIButton(type: .system)
        newSendBtn.setImage(UIImage(systemName: "arrow.up.square"), for: .normal)
        newSendBtn.tintColor = .white
        newSendBtn.translatesAutoresizingMaskIntoConstraints = false
        newSendBtn.addTarget(self, action: #selector(newSendAction), for: .touchUpInside)
        capsuleView.addSubview(newSendBtn)
        
        newTimerLbl = UILabel()
        newTimerLbl.text = "00:00"
        newTimerLbl.textColor = .white
        newTimerLbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        newTimerLbl.translatesAutoresizingMaskIntoConstraints = false
        capsuleView.addSubview(newTimerLbl)
        
        waveLottieView = LottieAnimationView(name: "audiofreq")
        waveLottieView.loopMode = .loop
        waveLottieView.contentMode = .scaleAspectFill
        waveLottieView.translatesAutoresizingMaskIntoConstraints = false
        capsuleView.addSubview(waveLottieView)
        
        NSLayoutConstraint.activate([
            newDeleteBtn.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 15),
            newDeleteBtn.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            newDeleteBtn.widthAnchor.constraint(equalToConstant: 30),
            newDeleteBtn.heightAnchor.constraint(equalToConstant: 30),
            
            newSendBtn.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -15),
            newSendBtn.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            newSendBtn.widthAnchor.constraint(equalToConstant: 30),
            newSendBtn.heightAnchor.constraint(equalToConstant: 30),
            
            newTimerLbl.trailingAnchor.constraint(equalTo: newSendBtn.leadingAnchor, constant: -10),
            newTimerLbl.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            
            // waveLottieView.leadingAnchor.constraint(equalTo: newDeleteBtn.trailingAnchor, constant: 20),
            // waveLottieView.trailingAnchor.constraint(equalTo: newTimerLbl.leadingAnchor, constant: -20),
            // waveLottieView.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            // waveLottieView.heightAnchor.constraint(equalToConstant: 50)
               waveLottieView.leadingAnchor.constraint(equalTo: newDeleteBtn.trailingAnchor, constant: 15),
            waveLottieView.trailingAnchor.constraint(equalTo: newTimerLbl.leadingAnchor, constant: -15),
            waveLottieView.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            waveLottieView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc func newDeleteAction() {
        self.recorder.myRecordings.removeAll()
        self.recorder.stopRecording()
        self.dismiss(animated: true)
    }
    
    @objc func newSendAction() {
        self.recorder.stopRecording()
        let reordingFile = recorder.getRecordings
        if reordingFile.count > 0 {
            let audioFilename = recorder.getDocumentsDirectory().appendingPathComponent(reordingFile[0].appending(".m4a"))
            callBackRecordedFile?(audioFilename.path)
            self.dismiss(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.recorder.myRecordings.removeAll()
    }
    
//    var recorder = AKAudioRecorder.shared
//    var displayLink = CADisplayLink()
//    var duration : CGFloat = 0.0
//    var timer : Timer!
//    var recordedAudioFile = String()
//    var callBackRecordedFile : ((String) -> ())?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setUpViews()
//    }
//    
//    private func setUpViews(){
//        GlobalMethods.shared.provideThreeCornerRadius(view: self.bottomVw, cornerRadius: 20, cornerArray: [.layerMaxXMinYCorner,.layerMinXMinYCorner])
//        self.recordVw.layer.cornerRadius = 36
//        self.recordVw.layer.borderWidth = 2
//        self.recordVw.layer.borderColor = UIColor(named: "black-white")?.cgColor ?? UIColor.gray.cgColor
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.recorder.myRecordings.removeAll()
//    }
    
    
    @IBAction func backBtn_Actioj(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func crossBtn_Action(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func holdBtn_Action(_ sender: Any) {
//        let recordings = recorder.getRecordings
//        
//        if self.recorder.isPlaying {
//            self.recorder.stopPlaying()
//            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
//        } else if self.recorder.isRecording {
//            self.animate(isRecording: true)
//            self.recorder.stopRecording()
//            self.deleteBtn.isHidden = false
//            self.sendBtn.isHidden = false
//            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
//            self.timerLbl.text = self.recorder.duration.timeStringFormatter
//        } else if !recordings.isEmpty {
//            self.recorder.play(name: recordings[0])
//            self.holdBtn.setImage(UIImage(named: "Path 60_Video_2"), for: .normal)
//            self.timerLbl.text = self.recorder.duration.timeStringFormatter
//        } else {
//            self.animate(isRecording: false)
//            self.recorder.record()
//            self.deleteBtn.isHidden = true
//            self.sendBtn.isHidden = true
//            self.setTimer()
//        }
//        
//        self.recorder.stopRecordingCallBack = { time in
//            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
//            self.timerLbl.text = time
//        }
//        self.recorder.startPlayingCallBack = {
//            self.holdBtn.setImage(UIImage(named: "Path 60_Video_2"), for: .normal)
//        }
//        self.recorder.stopPlayingCallBack = {
//            self.holdBtn.setImage(UIImage(named: "Path 60-2"), for: .normal)
//            self.timerLbl.text = "\(self.recorder.updatedRecordedTime)"
//        }
    }
    
    @IBAction func deleteBtn_Action(_ sender: Any) {
//        self.recorder.myRecordings.removeAll()
//        self.timerLbl.text = ""
//        self.holdBtn.backgroundColor = .red
//        self.sendBtn.isHidden = true
//        self.deleteBtn.isHidden = true
    }
    
    @IBAction func sendBtn_Action(_ sender: Any) {
//        let reordingFile = recorder.getRecordings
//        if reordingFile.count > 0 {
//            let audioFilename = recorder.getDocumentsDirectory().appendingPathComponent(reordingFile[0].appending(".m4a"))
//            callBackRecordedFile?(audioFilename.path)
//            self.dismiss(animated: true)
//        }
    }
}
