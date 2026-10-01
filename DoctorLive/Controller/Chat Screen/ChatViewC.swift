//
//  ChatViewC.swift
//  Dr.Live
//
//  Created by Kv on 23/12/24.
//

import UIKit
import PromiseKit
import SwiftyJSON
import PIPKit

class ChatViewC: UIViewController {
    
    @IBOutlet weak private var videoCallButton: UIButton!
    @IBOutlet weak var msgBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var statusVw: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextView!
    @IBOutlet weak var messageVw: UIView!
    @IBOutlet weak var chatTblVw: UITableView!{
        didSet{
            self.chatTblVw.delegate = self
            self.chatTblVw.dataSource = self
        }
    }
    @IBOutlet weak var audioBtn: UIButton!
    
    var viewmodel = ViewModel()
    var senderId: String?
    var recieverId: String?
    var roomId: String?
    var profilePic: String?
    var patientName: String?
    var chatData = [ChatData]()
    var groupByCategoryChat: [String : [ChatData]]?
    var keys = [String]()
    var isFromPagination: Bool = false
    
    var topStatusBarContainer = UIView()
    var topStatusBarLabel = UILabel()
    var topStatusBarHeightConstraint: NSLayoutConstraint!
    
    var countdownTimer: Timer?
    var targetDate: Date?
    
    var comeFromPush = false
    var isOnline = false

    var sinchToken: String?
    var rtcAgoroToken: String?
    var userId: String?
    var bookingId: String?
    var doctorId: String?
    var isPaymentCompleted = false
    var isFirstLoadScroll = true
    
    // Pagination
    var currentPage = 1
    var hasMoreData = true
    var isLoading = false
    
    lazy var paginationSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BookingTimerManager.shared.fetchTimers()
        setUpviewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        USER_DEFAULTS.set(true, forKey: PUSHUD.chatNotification)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setUpOnline(isOnline: false)
        USER_DEFAULTS.set(false, forKey: PUSHUD.chatNotification)
    }
}

extension ChatViewC {
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            UIPasteboard.general.string = self.chatData[gesture.view?.tag ?? INTZERO].message ?? EMPTY
            self.showToast(message: "Copy message")
        }
    }
}

 extension ChatViewC {
    func setUpviewController() {
        setUpPushChatData()
        registerXib()
        setUpChat()
        SocketHelper.shared.connectSocket {
            print("Socket Connected")
            self.setUpRoom()
        }
        setUpViews()
        getChatHistry()
        setUpKeyBoard()
    }

     func setUpViews(){
         self.view.backgroundColor = .white
         chatTblVw.backgroundColor = UIColor.init(red: 246/255, green: 250/255, blue: 253/255, alpha: 1)
         self.chatTblVw.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
         self.dotLbl.isHidden = true
         self.statusLbl.text = "offline"
         self.messageTxt.delegate = self
         self.messageTxt.textColor = .lightGray
         self.navigationController?.isNavigationBarHidden = true
         GlobalMethods.shared.provideCornerRadius(view: self.messageVw, cornerRadius: self.messageVw.bounds.height / 2, borderColor: UIColor.clear.cgColor, borderWidth: 0)
         GlobalMethods.shared.provideCornerRadius(view: self.doctorImage, cornerRadius: self.doctorImage.bounds.height / 2, borderColor: UIColor.clear.cgColor, borderWidth: 0)
         GlobalMethods.shared.provideCornerRadius(view: self.statusVw, cornerRadius: self.statusVw.bounds.height / 2, borderColor: UIColor.clear.cgColor, borderWidth: 0)
         GlobalMethods.shared.provideCornerRadius(view: self.sendBtn, cornerRadius: self.sendBtn.bounds.height / 2, borderColor: UIColor.clear.cgColor, borderWidth: 0)
         self.typeOn(string: ". . .")
         setupStickyStatusBar()
     }
    
    func setupStickyStatusBar() {
        topStatusBarContainer.backgroundColor = UIColor(red: 254/255, green: 246/255, blue: 231/255, alpha: 1)
        topStatusBarContainer.isHidden = true
        
        topStatusBarLabel.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        topStatusBarLabel.textColor = UIColor(red: 176/255, green: 125/255, blue: 24/255, alpha: 1)
        topStatusBarLabel.textAlignment = .center
        
        topStatusBarContainer.addSubview(topStatusBarLabel)
        self.view.addSubview(topStatusBarContainer)
        
        topStatusBarContainer.translatesAutoresizingMaskIntoConstraints = false
        topStatusBarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topStatusBarHeightConstraint = topStatusBarContainer.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            topStatusBarContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topStatusBarContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topStatusBarContainer.topAnchor.constraint(equalTo: self.chatTblVw.topAnchor),
            topStatusBarHeightConstraint,
            
            topStatusBarLabel.centerXAnchor.constraint(equalTo: topStatusBarContainer.centerXAnchor),
            topStatusBarLabel.centerYAnchor.constraint(equalTo: topStatusBarContainer.centerYAnchor)
        ])
    }
    
    func updateStickyStatusBar() {
        if let index = chatData.lastIndex(where: { $0.historyType == "booking_status" }) {
            let lastPaymentCompleted = chatData[index].msgType ?? ""
            if lastPaymentCompleted == "PAYMENT_COMPLETED" || lastPaymentCompleted == "WAITING_FOR_CALL" || lastPaymentCompleted == "CALL_STARTED" || lastPaymentCompleted == "CALL_ENDED" || lastPaymentCompleted == "CONSULTATION_COMPLETED" || lastPaymentCompleted == "CALL_UNANSWERED" || lastPaymentCompleted == "PRESCRIPTION_SENT"{
                self.isPaymentCompleted = true
            }else{
                self.isPaymentCompleted = false
            }
        }else{
            self.isPaymentCompleted = false
        }
        let statusMessages = chatData.filter { $0.historyType == "booking_status" }
        var targetStatusMsg = statusMessages.last
//        let isFollowUp = (targetStatusMsg?.is_follow_up ?? false)
        let isFollowUp = (targetStatusMsg?.is_follow_up == "1" || targetStatusMsg?.is_follow_up?.lowercased() == "true")
        if isFollowUp {
            if let prescriptionSentMsg = statusMessages.last(where: { $0.msgType == "PRESCRIPTION_SENT" }) {
                targetStatusMsg = prescriptionSentMsg
            }
        }
        guard let lastStatusMsg = targetStatusMsg else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            hideStickyStatusBar()
            return
        }
        print(lastStatusMsg.createdOn ?? "")
        
        switch lastStatusMsg.msgType {
        case "REQUESTED", "PAYMENT_PENDING", "PAYMENT_COMPLETED", "SUGGESTED_TIME_ACCEPTED":
            let dateToUse = lastStatusMsg.createdOn ?? ""
            let parsedDate = Booking.parseDate(dateStr: nil, createdOn: dateToUse)
            let timerInterval = BookingTimerManager.shared.getTimer(for: lastStatusMsg.msgType ?? "", defaultMinutes: 10)
            let target = parsedDate.addingTimeInterval(timerInterval)
            
            if Date() < target {
                self.targetDate = target
                updateTimerLabel()
                startCountdownTimerIfNeeded()
            } else {
                stopTimerAndHide()
            }
            
        case "CALL_STARTED":
            let parsedDate = Booking.parseDate(dateStr: nil, createdOn: lastStatusMsg.createdOn ?? "")
            // For CALL_STARTED, targetDate will act as the START date
            self.targetDate = parsedDate
            updateTimerLabel()
            startCountdownTimerIfNeeded()
            
        case "CALL_ENDED", "CONSULTATION_COMPLETED":
            countdownTimer?.invalidate()
            countdownTimer = nil
            topStatusBarContainer.backgroundColor = UIColor(red: 236/255, green: 253/255, blue: 243/255, alpha: 1)
            topStatusBarLabel.textColor = UIColor(red: 2/255, green: 122/255, blue: 72/255, alpha: 1)
            showStickyStatusBar(text: "✅ Call ended — awaiting summary")
            
        case "CALL_UNANSWERED":
            countdownTimer?.invalidate()
            countdownTimer = nil
            topStatusBarContainer.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
            topStatusBarLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
            showStickyStatusBar(text: "📞 Call Unanswered")
            
        case "CLOSED":
            countdownTimer?.invalidate()
            countdownTimer = nil
            topStatusBarContainer.backgroundColor = .systemGray5
            topStatusBarLabel.textColor = .gray
            showStickyStatusBar(text: "🔒 Chat Closed")
            
        case "REJECTED":
            countdownTimer?.invalidate()
            countdownTimer = nil
            topStatusBarContainer.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
            topStatusBarLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
            showStickyStatusBar(text: "❌ Booking rejected")
            
        case "PAYMENT_EXPIRED":
            countdownTimer?.invalidate()
            countdownTimer = nil
            topStatusBarContainer.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
            topStatusBarLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
            showStickyStatusBar(text: "⏱ Payment window expired")
            
        case "PRESCRIPTION_SENT":
            let parsedDate = Booking.parseDate(dateStr: nil, createdOn: lastStatusMsg.createdOn ?? "")
            let timerInterval = BookingTimerManager.shared.getTimer(for: "PRESCRIPTION_SENT", defaultMinutes: 120)
            let target = parsedDate.addingTimeInterval(timerInterval)
            
            if Date() < target {
                self.targetDate = target
                updateTimerLabel()
                startCountdownTimerIfNeeded()
            } else {
                stopTimerAndHide()
            }
            
        case "SUGGESTED_TIME_PENDING":
            countdownTimer?.invalidate()
            countdownTimer = nil
            topStatusBarContainer.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
            topStatusBarLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
            showStickyStatusBar(text: "🕐 Time proposed — awaiting confirmation")
         case "REMINDER":
            break
        case "WAITING_FOR_CALL":
            break
//        case "CALL_UNANSWERED":
//            break
        default:
            stopTimerAndHide()
        }
    }
    
    private func startCountdownTimerIfNeeded() {
        if countdownTimer == nil {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(countdownTimer!, forMode: .common)
        }
    }
    
    private func stopTimerAndHide() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        hideStickyStatusBar()
    }

    @objc private func updateTimerLabel() {
        guard let target = targetDate else { return }
        
        let statusMessages = chatData.filter { $0.historyType == "booking_status" }
        let lastStatusMsg = statusMessages.last
        
        if lastStatusMsg?.msgType == "CALL_STARTED" {
            let elapsed = Date().timeIntervalSince(target)
            if elapsed >= 0 {
                let mins = Int(elapsed) / 60
                let secs = Int(elapsed) % 60
                topStatusBarContainer.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1)
                topStatusBarLabel.textColor = UIColor(red: 30/255, green: 64/255, blue: 175/255, alpha: 1)
                showStickyStatusBar(text: String(format: "🎥 In Call · %02d:%02d", mins, secs))
            }
        } else {
            let remaining = target.timeIntervalSince(Date())
            if remaining > 0 {
                let totalMins = Int(remaining) / 60
                let secs = Int(remaining) % 60
                let hours = totalMins / 60
                let mins = totalMins % 60
                
                if lastStatusMsg?.msgType == "REQUESTED" {
                    topStatusBarContainer.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
                    topStatusBarLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
                    showStickyStatusBar(text: String(format: "⏱ Waiting for Doctor · %02d:%02d", totalMins, secs))
                } else if lastStatusMsg?.msgType == "PAYMENT_PENDING" || lastStatusMsg?.msgType == "SUGGESTED_TIME_ACCEPTED" {
                    topStatusBarContainer.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
                    topStatusBarLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
                    showStickyStatusBar(text: String(format: "💳 Pay Now · %02d:%02d", totalMins, secs))
                } else if lastStatusMsg?.msgType == "PAYMENT_COMPLETED" {
                    topStatusBarContainer.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
                    topStatusBarLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
                    showStickyStatusBar(text: String(format: "📞 Waiting for Call · %02d:%02d", totalMins, secs))
                } else if lastStatusMsg?.msgType == "PRESCRIPTION_SENT" {
                    topStatusBarContainer.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
                    topStatusBarLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
                    if hours > 0 {
                        showStickyStatusBar(text: String(format: "⏱ Follow-up · %02d:%02d:%02d", hours, mins, secs))
                    } else {
                        showStickyStatusBar(text: String(format: "⏱ Follow-up · %02d:%02d", mins, secs))
                    }
                }
            } else {
                stopTimerAndHide()
            }
        }
    }
    
    private func showStickyStatusBar(text: String) {
        topStatusBarContainer.isHidden = false
        topStatusBarLabel.text = text
        topStatusBarHeightConstraint.constant = 36
        chatTblVw.contentInset = UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
    }
    
    private func hideStickyStatusBar() {
        topStatusBarContainer.isHidden = true
        topStatusBarHeightConstraint.constant = 0
        self.chatTblVw.contentInset = .zero
    }
    
    func setUpPushChatData(){
        if USER_DEFAULTS.bool(forKey: PUSHUD.comeFromPush) {
            USER_DEFAULTS.set(false, forKey: PUSHUD.comeFromPush)
            self.comeFromPush = true
            self.recieverId = USER_DEFAULTS.string(forKey: PUSHUD.reciever)
            self.senderId = USER_DEFAULTS.string(forKey: Constants.userId)
            self.roomId = USER_DEFAULTS.string(forKey: PUSHUD.roomId)
            self.doctorNameLbl.text = USER_DEFAULTS.string(forKey: PUSHUD.reciverProfileName)
            let mystring = USER_DEFAULTS.string(forKey: PUSHUD.reciverProfilePic) ?? EMPTY
            let urlNew:String = mystring.replacingOccurrences(of: " ", with: "%20")
            self.doctorImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal))
        }else{
            self.doctorNameLbl.text = self.patientName ?? EMPTY
            let mystring = self.profilePic ?? EMPTY
            let urlNew:String = mystring.replacingOccurrences(of: " ", with: "%20")
            self.doctorImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal))
        }
    }
    
    func registerXib(){
        self.chatTblVw.register(UINib(nibName: ChatLeftTextCell.className, bundle: nil), forCellReuseIdentifier: ChatLeftTextCell.className)
        self.chatTblVw.register(UINib(nibName: ChatRightTextCell.className, bundle: nil), forCellReuseIdentifier: ChatRightTextCell.className)
        self.chatTblVw.register(UINib(nibName: ChatLeftImageCell.className, bundle: nil), forCellReuseIdentifier: ChatLeftImageCell.className)
        self.chatTblVw.register(UINib(nibName: ChatRightImageCell.className, bundle: nil), forCellReuseIdentifier: ChatRightImageCell.className)
        self.chatTblVw.register(UINib(nibName: ChatHeaderCell.className, bundle: nil), forHeaderFooterViewReuseIdentifier: ChatHeaderCell.className)
        self.chatTblVw.register(UINib(nibName: ChatRightAudioCell.className, bundle: nil), forCellReuseIdentifier: ChatRightAudioCell.className)
        self.chatTblVw.register(ChatRightPdfCell.self, forCellReuseIdentifier: "ChatRightPdfCell")
        self.chatTblVw.register(ChatLeftPdfCell.self, forCellReuseIdentifier: "ChatLeftPdfCell")
        self.chatTblVw.register(ChatRightPdfCell.self, forCellReuseIdentifier: "ChatRightPdfCell")
        self.chatTblVw.register(ChatLeftPdfCell.self, forCellReuseIdentifier: "ChatLeftPdfCell")
        self.chatTblVw.register(ChatBookingDividerCell.self, forCellReuseIdentifier: "ChatBookingDividerCell")
        self.chatTblVw.register(ChatStageChipCell.self, forCellReuseIdentifier: "ChatStageChipCell")
        self.chatTblVw.register(ChatStageChipCell2.self, forCellReuseIdentifier: "ChatStageChipCell2")
        self.chatTblVw.register(ChatActionCardCell.self, forCellReuseIdentifier: "ChatActionCardCell")
        self.chatTblVw.register(ChatPayCardCell.self, forCellReuseIdentifier: "ChatPayCardCell")
        self.chatTblVw.register(ChatBookingSummaryCardCell.self, forCellReuseIdentifier: "ChatBookingSummaryCardCell")
        self.chatTblVw.register(ChatRatingCardCell.self, forCellReuseIdentifier: "ChatRatingCardCell")
        self.chatTblVw.register(ChatMediaMsgCell.self, forCellReuseIdentifier: "ChatMediaMsgCell")
        self.chatTblVw.register(ChatVideoCallBadgeCell.self, forCellReuseIdentifier: "ChatVideoCallBadgeCell")
        self.chatTblVw.register(ChatNewBookingRequestCell.self, forCellReuseIdentifier: "ChatNewBookingRequestCell")
        self.chatTblVw.register(ChatDynamicStackCell.self, forCellReuseIdentifier: "ChatDynamicStackCell")
    }
    
    @IBAction func audioBtn_Action(_ sender: Any) {
        let viewC = DIConfigurator.sharedInst().getRecorderViewC()
        viewC.modalTransitionStyle = .crossDissolve
        viewC.modalPresentationStyle = .overCurrentContext
        viewC.callBackRecordedFile = { record in
            Indicator.shared.showProgressView(self.view)
            let audioUrl = URL(fileURLWithPath: record)
            guard let fileData = try? Data(contentsOf: audioUrl) else {
                Indicator.shared.hideProgressView()
                self.showToast(message: "uploading error")
                return
            }
            let fileName = "chat_audio_\(Int(Date().timeIntervalSince1970)).m4a"
            self.uploadViaPresignedUrl(fileName: fileName, filetype: "audio/m4a", fileData: fileData, contentType: "audio/m4a") { result in
                self.handleMediaUploadResult(result: result, msgType: "audio", successMessage: "Audio upload successfully")
//                switch result {
//                case .success(let publicUrl):
////                    self.emitChatMediaMessage(url: publicUrl, type: "audio")
//                    self.chatData.append(ChatData(message: publicUrl, time: Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date()), msgType: "audio", recieverType: "sender", date: Date.getDateStringWithDatee(DateFormat.dateMonthyear1, date: Date())))
//                    self.showToast(message: "Audio upload successfully")
//                    self.setscrollPosition()
//                    self.setUpChatData()
//                case .failure:
//                    self.showToast(message: "uploading error")
//                }
            }
        }
        self.navigationController?.present(viewC, animated: true)
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        if self.comeFromPush {
            DIConfigurator.sharedInst().getRootViewC(.Auth, identifer: HomeVC.className)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func sendBtn_Action(_ sender: Any) {
        guard self.messageTxt.text == "Message..." || self.messageTxt.text == EMPTY else {
            var param = [String: String]()
            param["message"] = self.messageTxt.text!
            param["type"] = "text"
            param["senderType"] = "doctor"
            param["sender_id"] = self.senderId ?? EMPTY
            param["reciver_id"] = self.recieverId ?? EMPTY
            param["room_id"] = self.roomId ?? EMPTY
            param["userName"] = self.patientName ?? EMPTY
            SocketHelper.shared.emit(with: .message, param) { (json) in
                print("json. from emit function.........\(json)")
            }
            self.chatData.append(ChatData(message: self.messageTxt.text, time: Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date()), msgType: "text", recieverType: "sender", date: Date.getDateStringWithDatee(DateFormat.apiDate, date: Date())))
            self.messageTxt.text = EMPTY
            self.setscrollPosition()
            self.setUpChatData()
            return
        }
    }

    @IBAction func cameraBtn_Action(_ sender: Any) {
        VideoPickerManagerSwift().pickImage(self) { [weak self] image, url in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            if image.size.height == 0.0 {
                
                let isAccessing = url.startAccessingSecurityScopedResource()
                defer {
                    if isAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                if url.pathExtension.lowercased() == "pdf" {
                    // PDF Document
                    Indicator.shared.showProgressView(self.view)
                    guard let fileData = try? Data(contentsOf: url) else {
                        Indicator.shared.hideProgressView()
                        self.showToast(message: "uploading error")
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                    let fileName = "chat_doc_\(Int(Date().timeIntervalSince1970)).pdf"
                    self.uploadViaPresignedUrl(fileName: fileName, filetype: "application/pdf", fileData: fileData, contentType: "pdf") { result in
                        self.handleMediaUploadResult(result: result, msgType: "pdf", successMessage: "pdf upload successfully")
                    }
                } else {
                    // Video
                    let videoURL = self.createTemporaryURLforVideoFile(url: url as NSURL) as URL
                    guard let fileData = try? Data(contentsOf: videoURL), !fileData.isEmpty else {
                        self.showToast(message: "uploading error")
                        return
                    }
                    let fileName = "chat_video_\(Int(Date().timeIntervalSince1970)).mp4"
                    self.uploadViaPresignedUrl(fileName: fileName, filetype: "video/mp4", fileData: fileData, contentType: "video/mp4") { result in
                        self.handleMediaUploadResult(result: result, msgType: "video", successMessage: "Video upload successfully")
                    }
                }
            } else {
                // Image
                guard let fileData = image.jpegData(compressionQuality: 0.75), !fileData.isEmpty else {
                    self.showToast(message: "uploading error")
                    return
                }
                let fileName = "chat_img_\(Int(Date().timeIntervalSince1970)).jpg"
                self.uploadViaPresignedUrl(fileName: fileName, filetype: "image/jpeg", fileData: fileData, contentType: "image/jpeg") { result in
                    self.handleMediaUploadResult(result: result, msgType: "image", successMessage: "Image upload successfully")
                }
            }
        }
    }

    @IBAction func videoCallButtonTapped(_ sender: Any) {
        guard isPaymentCompleted else {
            AppToast.showMessage(message: "Payment pending from patient side")
            return
        }
        if let _ = self.findVideoCallController() {
            AppToast.showMessage(message: "Video call is already in progress")
        }else{
            self.emitBookingStatusData(bookingStatus: "CALL_STARTED")
            getToken()
        }
        
    }

    func handleMediaUploadResult(result: Swift.Result<String, Error>, msgType: String, successMessage: String) {
        DispatchQueue.main.async {
            Indicator.shared.hideProgressView()
            switch result {
            case .success(let publicUrl):
                var param = [String: String]()
                param["message"] = publicUrl
                param["type"] = msgType
                param["senderType"] = "doctor"
                param["sender_id"] = self.senderId ?? EMPTY
                param["reciver_id"] = self.recieverId ?? EMPTY
                param["room_id"] = self.roomId ?? EMPTY
                param["userName"] = self.patientName ?? EMPTY
                SocketHelper.shared.emit(with: .message, param) { (json) in
                    print("json. from emit function.........\(json)")
                }
                self.chatData.append(ChatData(message: publicUrl, time: Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date()), msgType: msgType, recieverType: "sender", date: Date.getDateStringWithDatee(DateFormat.apiDate, date: Date())))
                self.showToast(message: successMessage)
                self.setscrollPosition()
                self.setUpChatData()
            case .failure:
                self.showToast(message: "uploading error")
            }
        }
    }

    func uploadViaPresignedUrl(fileName: String, filetype: String, fileData: Data, contentType: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        Indicator.shared.showProgressView(self.view)
        let passDict: [String: Any] = ["filename": fileName, "filetype": filetype]
        let apiHandle = ApiHandler()
        let url = Domain.baseUrl().appending(APIEndpoint.signedUrl)
        let header = ApiManager.instance.getHeadeWithJwtToken()
        apiHandle.fetchApiHeaderService(method: .post, url: url, passDict: passDict, header: header) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                let status = data["status"].bool ?? false
                let signedUrlString = data["data"]["signedUrl"].string
                let publicUrl = data["data"]["publicUrl"].string ?? ""
                guard status,
                      let signedUrlString = signedUrlString,
                      let uploadURL = URL(string: signedUrlString) else {
                    DispatchQueue.main.async { Indicator.shared.hideProgressView() }
                    completion(.failure(NSError(domain: "ChatViewC", code: -1, userInfo: [NSLocalizedDescriptionKey: data["message"].string ?? "Invalid signed URL"])))
                    return
                }
                self?.uploadFileToPresignedUrl(fileData: fileData, uploadUrl: uploadURL, contentType: contentType) { uploadResult in
                    switch uploadResult {
                    case .success:
                        completion(.success(publicUrl))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { Indicator.shared.hideProgressView() }
                completion(.failure(error))
            }
        }
    }

    func uploadFileToPresignedUrl(fileData: Data, uploadUrl: URL, contentType: String, result: @escaping (Swift.Result<Void, Error>) -> Void) {
        var request = URLRequest(url: uploadUrl)
        request.httpMethod = "PUT"
        request.httpBody = fileData
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("\(fileData.count)", forHTTPHeaderField: "Content-Length")
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(NSError(domain: "Upload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                result(.success(()))
            } else {
                result(.failure(NSError(domain: "Upload", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Upload failed with status code: \(httpResponse.statusCode)"])))
            }
        }
        task.resume()
    }

    func createTemporaryURLforVideoFile(url: NSURL) -> NSURL {
        /// Create the temporary directory.
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        /// create a temporary file for us to copy the video to.
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(url.lastPathComponent ?? "")
        /// Attempt the copy.
        do {
            try FileManager().copyItem(at: url.absoluteURL!, to: temporaryFileURL)
        } catch {
            print("There was an error copying the video file to the temporary location.")
        }

        return temporaryFileURL as NSURL
    }
}

 extension ChatViewC {
    func getTokenApi(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.getToken(parameters: param, header: "DeviceToken")
        }.done { (model: TokenRoot) in
            self.getTokenModel(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    
    func getToken() {
        let passDic = ["isPublisher": "true",
                       "channel": sinchToken ?? ""]
        print(passDic)
        self.getTokenApi(param: passDic)
    }
    
    func getTokenModel(model: TokenRoot){
        if model.status == "SUCCESS" {
            self.rtcAgoroToken = model.token ?? ""
            self.generateAndSendPush()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }

    func generateAndSendPushApi(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.generateAndSendPush(parameters: param, header: "DeviceToken")
        }.done { (model: PushNotificationRoot) in
            self.generateAndSendPushModel(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    
    func generateAndSendPush() {
        let passDic = ["user_id": self.userId ?? EMPTY,
                       "channel": self.sinchToken ?? EMPTY,
                       "token": self.rtcAgoroToken ?? EMPTY,
                       "doctor_id": self.doctorId ?? EMPTY,
                       "type":"ios"]
        
        print(passDic)
        self.generateAndSendPushApi(param: passDic)
    }
    
    func generateAndSendPushModel(model: PushNotificationRoot){
        if model.status == "SUCCESS" {
            if let _ = self.findVideoCallController() {
                AppToast.showMessage(message: "Video call is already in progress")
            }else{
                let viewC = DIConfigurator.sharedInst().getVideoCallViewC()
                viewC.channelId = self.sinchToken ?? EMPTY
                viewC.rtcAgoroToken = self.rtcAgoroToken ?? EMPTY
                viewC.patientName = self.patientName ?? EMPTY
                viewC.userId = self.userId ?? EMPTY
                viewC.doctorId = self.doctorId ?? EMPTY
                viewC.bookingId = self.bookingId ?? EMPTY
                viewC.delegate = self
                DIConfigurator.sharedInst().setVideoCallAsRoot(viewC: viewC)
//                 PIPKit.show(with: viewC)
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }

    func endVisitBooking(param: [String: String]) {
        firstly {
            service!.bookingStatus(parameters: param, header: "DeviceToken")
        }.done { (model: BookingStatusModel) in
            self.endBooking(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
         }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
                Indicator.shared.hideProgressView()
            }
        }
    }
    
     func performEndCall(bookingId: String, reason: String,status:String) {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "booking_id": bookingId,
                     "status": status,
                     "reason": reason]
        endVisitBooking(param: parameter)
    }
    
    func endBooking(model: BookingStatusModel){
        if model.status == "SUCCESS" {
//            self.performUpcomingBooking()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension ChatViewC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.messageTxt.text == "Message..."{
            self.messageTxt.text = EMPTY
            self.messageTxt.textColor = .black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.messageTxt.text == EMPTY{
            self.messageTxt.text = "Message..."
            self.messageTxt.textColor = .lightGray
        }
        return true
    }
}

extension ChatViewC: VideoCallData{
    func videoCallData(patientName: String, bookingId: String, callDuration: String) {
        self.performEndCall(bookingId: bookingId, reason: EMPTY, status: "6")
//        self.emitBookingStatusData(bookingStatus: "CALL_ENDED")
    }
}
