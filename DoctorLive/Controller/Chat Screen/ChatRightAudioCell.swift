 

import UIKit
//import Lottie
import AVFoundation

class ChatRightAudioCell: UITableViewCell {

    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
//    @IBOutlet weak var lottieVw: LottieAnimationView!
    var audioBtnTapped: (()->())?
    
    var audioSlider: UISlider!
    var audioPlayer: AVPlayer?
    var timeObserverToken: Any?
    var audioURL: URL?
    
    var customPlayBtn: UIButton!
    var customTimeLbl: UILabel!
    
    var playerContainer: UIView!
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var timeBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Hide old XIB elements
        self.bottomVw.isHidden = true
        
        // Container
        playerContainer = UIView()
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.backgroundColor = UIColor(red: 218/255.0, green: 216/255.0, blue: 224/255.0, alpha: 1.0)
        playerContainer.layer.cornerRadius = 35 // creates the pill shape
        self.contentView.addSubview(playerContainer)
        
        leftConstraint = playerContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12)
        rightConstraint = playerContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -22) // padding for notch
        
        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            playerContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            playerContainer.widthAnchor.constraint(equalToConstant: 270),
            playerContainer.heightAnchor.constraint(equalToConstant: 70)
        ])
        rightConstraint.isActive = true // default right aligned
        
        // Custom Play Button
        customPlayBtn = UIButton(type: .custom)
        customPlayBtn.translatesAutoresizingMaskIntoConstraints = false
        customPlayBtn.backgroundColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
        customPlayBtn.layer.cornerRadius = 25
        customPlayBtn.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        customPlayBtn.tintColor = .white
        customPlayBtn.addTarget(self, action: #selector(playBtnAction), for: .touchUpInside)
        playerContainer.addSubview(customPlayBtn)
        
        // Audio Slider
        audioSlider = UISlider()
        audioSlider.translatesAutoresizingMaskIntoConstraints = false
        audioSlider.minimumTrackTintColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
        audioSlider.maximumTrackTintColor = UIColor(red: 190/255.0, green: 190/255.0, blue: 195/255.0, alpha: 1.0)
        let thumbConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .black, scale: .medium)
        audioSlider.setThumbImage(UIImage(systemName: "circle.fill", withConfiguration: thumbConfig)?.withTintColor(UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0), renderingMode: .alwaysOriginal), for: .normal)
        audioSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        playerContainer.addSubview(audioSlider)
        
        // Time Label Container (White Pill)
        timeBgView = UIView()
        timeBgView.translatesAutoresizingMaskIntoConstraints = false
        timeBgView.backgroundColor = .white
        timeBgView.layer.cornerRadius = 10
        playerContainer.addSubview(timeBgView)
        
        customTimeLbl = UILabel()
        customTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        customTimeLbl.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        customTimeLbl.textColor = .black
        customTimeLbl.text = "00:00:00/00:00:00"
        customTimeLbl.textAlignment = .center
        timeBgView.addSubview(customTimeLbl)
        
        // Move Original timeLbl (Timestamp)
        if let timeLabel = self.timeLbl {
            timeLabel.removeFromSuperview()
            playerContainer.addSubview(timeLabel)
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            timeLabel.textColor = .darkGray
            
            NSLayoutConstraint.activate([
                timeLabel.trailingAnchor.constraint(equalTo: timeBgView.trailingAnchor),
                timeLabel.topAnchor.constraint(equalTo: audioSlider.bottomAnchor, constant: -2)
            ])
        }
        
        NSLayoutConstraint.activate([
            // Play Button Constraints
            customPlayBtn.leadingAnchor.constraint(equalTo: playerContainer.leadingAnchor, constant: 10),
            customPlayBtn.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor),
            customPlayBtn.widthAnchor.constraint(equalToConstant: 50),
            customPlayBtn.heightAnchor.constraint(equalToConstant: 50),
            
            // Slider Constraints
            audioSlider.leadingAnchor.constraint(equalTo: customPlayBtn.trailingAnchor, constant: 15),
            audioSlider.trailingAnchor.constraint(equalTo: playerContainer.trailingAnchor, constant: -20),
            audioSlider.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor, constant: 10), // positioned lower for time label
            
            // Time Pill Constraints
            timeBgView.trailingAnchor.constraint(equalTo: audioSlider.trailingAnchor),
            timeBgView.bottomAnchor.constraint(equalTo: audioSlider.topAnchor, constant: -2),
            timeBgView.heightAnchor.constraint(equalToConstant: 20),
            
            customTimeLbl.leadingAnchor.constraint(equalTo: timeBgView.leadingAnchor, constant: 8),
            customTimeLbl.trailingAnchor.constraint(equalTo: timeBgView.trailingAnchor, constant: -8),
            customTimeLbl.centerYAnchor.constraint(equalTo: timeBgView.centerYAnchor)
        ])
    }
    
    func configureAlignment(isSender: Bool) {
        if isSender {
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            
            playerContainer.backgroundColor = UIColor(red: 218/255.0, green: 216/255.0, blue: 224/255.0, alpha: 1.0)
            customPlayBtn.backgroundColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
            customPlayBtn.tintColor = .white
            
            audioSlider.minimumTrackTintColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
            audioSlider.maximumTrackTintColor = UIColor(red: 190/255.0, green: 190/255.0, blue: 195/255.0, alpha: 1.0)
            
            timeBgView.backgroundColor = .white
            customTimeLbl.textColor = .black
            self.timeLbl.textColor = .darkGray
            
            let thumbConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .black, scale: .medium)
            audioSlider.setThumbImage(UIImage(systemName: "circle.fill", withConfiguration: thumbConfig)?.withTintColor(UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0), renderingMode: .alwaysOriginal), for: .normal)
        } else {
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            
            playerContainer.backgroundColor = UIColor(red: 227/255.0, green: 240/255.0, blue: 254/255.0, alpha: 1.0)
            customPlayBtn.backgroundColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
            customPlayBtn.tintColor = .white
            
            audioSlider.minimumTrackTintColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
            audioSlider.maximumTrackTintColor = .lightGray
            
            timeBgView.backgroundColor = .white
            customTimeLbl.textColor = .black
            self.timeLbl.textColor = .darkGray
            
            let thumbConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .black, scale: .medium)
            audioSlider.setThumbImage(UIImage(systemName: "circle.fill", withConfiguration: thumbConfig)?.withTintColor(UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0), renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeTimeObserver()
        audioPlayer?.pause()
        audioPlayer = nil
        NotificationCenter.default.removeObserver(self)
        self.customPlayBtn.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        self.audioSlider.value = 0
        self.customTimeLbl.text = "00:00:00/00:00:00"
    }
    
    func configureAudio(url: URL) {
        self.audioURL = url
        audioSlider.value = 0
        self.customTimeLbl.text = "00:00/00:00"
        
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let localURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        
        if fileManager.fileExists(atPath: localURL.path) {
            setupPlayer(with: localURL)
        } else {
            // Download the file locally to bypass streaming restrictions for 3gp/3ga files
            URLSession.shared.downloadTask(with: url) { [weak self] (tempURL, response, error) in
                guard let tempURL = tempURL, error == nil else {
                    print("Audio download failed: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                do {
                    if fileManager.fileExists(atPath: localURL.path) {
                        try fileManager.removeItem(at: localURL)
                    }
                    try fileManager.moveItem(at: tempURL, to: localURL)
                    DispatchQueue.main.async {
                        if self?.audioURL == url {
                            self?.setupPlayer(with: localURL)
                        }
                    }
                } catch {
                    print("Audio file move failed: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
    
    func setupPlayer(with localURL: URL) {
        let asset = AVURLAsset(url: localURL)
        let playerItem = AVPlayerItem(asset: asset)
        audioPlayer = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Asynchronously load the duration
        asset.loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                var error: NSError? = nil
                let status = asset.statusOfValue(forKey: "duration", error: &error)
                if status == .loaded {
                    let duration = asset.duration
                    let totalSeconds = CMTimeGetSeconds(duration)
                    if !totalSeconds.isNaN && totalSeconds > 0 {
                        self.audioSlider.maximumValue = Float(totalSeconds)
                        let totalString = self.formatTime(TimeInterval(totalSeconds))
                        self.customTimeLbl.text = "00:00/\(totalString)"
                    }
                }
            }
        }
        
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateTimeLabel()
        }
    }
    
    func removeTimeObserver() {
        if let token = timeObserverToken {
            audioPlayer?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    @objc func updateTimeLabel() {
        guard let player = audioPlayer, let currentItem = player.currentItem else { return }
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(currentItem.duration)
        
        if !duration.isNaN && duration > 0 {
            self.audioSlider.maximumValue = Float(duration)
        }
        
        let safeCurrent = currentTime.isNaN ? 0 : currentTime
        self.audioSlider.value = Float(safeCurrent)
        
        let currentString = formatTime(TimeInterval(safeCurrent))
        
        if !duration.isNaN && duration > 0 {
            let totalString = formatTime(TimeInterval(duration))
            self.customTimeLbl.text = "\(currentString)/\(totalString)"
        } else {
            // fallback if duration is not ready yet
            self.customTimeLbl.text = "\(currentString)/00:00"
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let targetTime = CMTime(seconds: Double(sender.value), preferredTimescale: 600)
        audioPlayer?.seek(to: targetTime)
        updateTimeLabel()
    }
    
    @objc func playBtnAction() {
        guard let player = audioPlayer else {
            self.audioBtnTapped?()
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
        
        let pauseIcon = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        let playIcon = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        
        if player.timeControlStatus == .playing || player.timeControlStatus == .waitingToPlayAtSpecifiedRate {
            player.pause()
            self.customPlayBtn.setImage(playIcon, for: .normal)
        } else {
            player.play()
            self.customPlayBtn.setImage(pauseIcon, for: .normal)
        }
    }
    
    @objc func audioPlayerDidFinishPlaying(notification: Notification) {
        let playIcon = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        self.customPlayBtn.setImage(playIcon, for: .normal)
        self.audioSlider.value = 0
        audioPlayer?.seek(to: CMTime.zero)
        updateTimeLabel()
    }
}
