//
//  ChatViewController.swift
//  DoctorLive
//
//  Created by call soft on 17/09/21.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import AVKit
import MobileCoreServices
import PromiseKit
import SDWebImage
import Mobilisten

class ChatViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PrescriptionPdfData, VideoCallFlowDelagate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtView: IQTextView!
    var hideCam: Bool?
    var chatDateDict = [String: [Doctorchathistory]]()
    var array = [Doctorchathistory]()
    var dateArr = [String]()
    var paramDict = [String: String]()
    var oncallPatientId: String?
    var onclinicPatentId: String?
    var chatEnd: Bool?
    var chatSessionExpired: Bool?
    var chatContinue: Bool?
    var returnFromPrescription: Bool = false
    var hiddenPrescriptionButton: Bool = false
    var senderId = UserDefaults.standard.string(forKey: Constants.userId)
    let kappDelegate = UIApplication.shared.delegate as! AppDelegate
    var imagePicker = UIImagePickerController()
    var patientCutCallwithoutPick = false
    var imageArr: [UIImage] = []
    var imageDataArr: [NSData] = []
    var imageParam: [String] = []
    var fileNameArr: [String] = []
    var groupUserList: [String]?
    var isGroup: Bool?
    var groupName: String?
    var name: String?
    var number: String?
    var image: String?
    var data = [String: String]()
    var bookingId = String()
    var deviceToken = String()
    var selectedIndexCallBack: (() -> ())?
    
    var index = Int()
    var endPicture: Bool = false
    var hideprescrip:Bool =  false
    var investigationState = Bool()
    var followUpState = Bool()
    var genralExamState = Bool()
    var medicineState = Bool()
    
    
    var sinchToken: String?
    var rtcAgoroToken: String?
    var userId: String?
    var patientName: String?
    var doctorId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performChatHistory()
        if chatEnd == true || chatContinue == true {
            performChatHistory()
            title = name
        }
        //:- Hide keyborad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = name
        SocketHelper.shared.connectSocket()
        setupRoom()
        setupTable()
        setNavigationBar()
        ZohoSalesIQ.Tracking.setPageTitle("Chat Screen")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
        (navigationController?.navigationBar.frame.height ?? 0.0)
        print(navBarHeight)
        self.navigationController?.isNavigationBarHidden = false
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + navBarHeight)
    }
    
    func setNavigationBar() {
        //:- MARK left bar button
        let logoImage = UIImage.init(named: "ChatHeader")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let editImage  = UIImage(named: "back1")
        let editButton = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        navigationItem.leftBarButtonItems = [editButton, imageItem]
        
        //:- MARK Right bar button
        let prescriptionImage = UIImage(named: "prescription")!
        let videoImage  = UIImage(named: "video")
        let prescriptionButton = UIBarButtonItem(image: prescriptionImage,  style: .plain, target: self, action: #selector(genratePrescriptionButtonTapped(sender:)))
        let videoButton = UIBarButtonItem(image: videoImage,  style: .plain, target: self, action: #selector(videoCallTap))
        videoButton.tintColor = .systemBlue
        if hiddenPrescriptionButton == false {
            prescriptionButton.isEnabled  = false
            prescriptionButton.tintColor  = UIColor.clear
        } else {
            prescriptionButton.isEnabled  = true
            videoButton.isEnabled = false
            videoButton.tintColor = UIColor.clear
            let editImage  = UIImage(named: "back1")
            let editButton = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
            navigationItem.leftBarButtonItems = [editButton, imageItem]
        }
        if hideCam == true {
            videoButton.isEnabled  = false
            videoButton.tintColor  = UIColor.clear
        }
        navigationItem.rightBarButtonItems = [videoButton, prescriptionButton]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let frame = self.navigationController?.navigationBar.frame
        let height: CGFloat = 80
        let bounds = self.navigationController?.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: (frame?.origin.x)!, y: (frame?.origin.y)!, width: bounds?.width ?? 0.0, height: bounds?.height ?? 0.0 + height)
    }
    
    @objc func genratePrescriptionButtonTapped(sender: Any) {
        print("image\(image ?? "nohh")")
        if image == nil || image == "" {
            let vc = PrescriptionViewController()
            UserDefaults.standard.set(bookingId, forKey: "bookingIdComeFromChat")
            vc.comeFrom = "videoCallViaChat"
            vc.videoCallflowdelegate = self
            vc.data = data
            vc.bookingId = bookingId
            vc.followUpState = followUpState
            vc.investigationToggleState = investigationState
            vc.genralSwitchButtonState = genralExamState
            vc.medicineSwitch = medicineState
            self.navigationController?.pushViewController(vc, animated: true)
         } else {
            let vc = PrescriptionViewVC()
            vc.comeFromChat = true
            vc.delegate = self
            vc.urlString = image ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func prescriptionBackFunc(_ returnToVideo: Bool, _ medicineState: Bool, _ investigationState: Bool, _ genralExamState: Bool, _ followUpState: Bool) {
        self.returnFromPrescription = returnToVideo
        self.medicineState = medicineState
        self.investigationState = investigationState
        self.followUpState = followUpState
        self.genralExamState = genralExamState
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func prescriptionPdf(_ prescriptionPdf: String){
        self.image = prescriptionPdf
    }
    
    @objc func videoCallTap(sender: AnyObject) {
        if let _ = self.findVideoCallController() {
            AppToast.showMessage(message: "Video call is already in progress")
        }else{
            self.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
            self.getToken()
        }
    }
    
    func checkCameraAuthorise() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            print("dasdadad")
            
            alertWithHandler(message: "Please allow access to the camera in the device's Settings -> Privacy -> Camera") {
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
        }else{
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            if status == .restricted || status == .denied {
                print("dasdadad")
                alertWithHandler(message: "Please allow access to the Microphone in the device's Settings -> Privacy -> Microphone") {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }else{
                return true
            }
        }
        return false
    }
    
    func alertWithHandler(message : String , block:  @escaping ()->Void ){
        
        let  alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action : UIAlertAction) in
            
            block()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAttachmentPressed(_ sender:UIButton) {
        openActionSheet()
    }
    
    @IBAction func btnSendMessagePressed(_ sender:UIButton) {
        if chatSessionExpired == true {
            let alert = UIAlertController(title: "Session Expired", message: "Your session is over please make another booking for continue consultation", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let name = UserDefaults.standard.string(forKey: Constants.userName)
            if txtView.text == "" {
                return
            } else {
                paramDict["room_id"] = bookingId
                paramDict["sender_id"] = senderId
                paramDict["reciver_id"] = self.userId ?? EMPTY
                paramDict["message"] = txtView.text
                paramDict["type"] = "text"
                paramDict["userName"] = name
                paramDict["senderType"] = "doctor"
                if dateArr.count == 0 {
                    performChatHistory()
                }
                SocketHelper.shared.emit(with: EventListnerKeys.message, self.paramDict) { (json) in
                    print("json. from emit function.........\(json)")
                    
                }
                if hiddenPrescriptionButton == true {
                    performChatHistory()
                }
                txtView.text = ""
            }
        }
    }
    
    func setupRoom() {
        let roomID = bookingId
        paramDict["room_id"] = roomID
        paramDict["reciver_id"] = oncallPatientId
        paramDict["sender_id"] = senderId
        SocketHelper.shared.emit(with: .roomJoin, paramDict)
    }
    
    func setupRoomLeave() {
        //let roomID = "\( senderId ?? "")\(oncallPatientId ?? "")"
        let roomID = bookingId
        paramDict["room_id"] = roomID
        paramDict["reciver_id"] = oncallPatientId
        paramDict["sender_id"] = senderId
        SocketHelper.shared.emit(with: .roomLeave, paramDict)
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    @objc func btnPlayPressed(_ sender: UIButton) {
        let index = sender.tag
        let dateKey = dateArr[index]
        let model = chatDateDict[dateKey]
        let videoURL = URL(string: model?[index].message ?? "")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.allowsPictureInPicturePlayback = false

           if #available(iOS 14.2, *) {
               playerViewController.canStartPictureInPictureAutomaticallyFromInline = false
           }
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func changeFormat(str:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // input format
        let date = dateFormatter.date(from: str)!
        dateFormatter.dateFormat = "hh:mm a" // output format
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func getDate(createAt : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //"yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: createAt) // replace Date String
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                print("Unhide")
            }, completion: nil)
        }
    }
}

//MARK:- TableView Delegate & DataSource

extension ChatViewController: UITableViewDelegate,UITableViewDataSource {
    func setupTable() {
        let roomID = bookingId
        //let roomID = "\(oncallPatientId ?? "")\(senderId ?? "")"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChatMessageRightCell", bundle: nil), forCellReuseIdentifier: "ChatMessageRightCell")
        tableView.register(UINib(nibName: "ChatMessageLeftCell", bundle: nil), forCellReuseIdentifier: "ChatMessageLeftCell")
        tableView.register(UINib(nibName: "ChatMessageImagesLeftCell", bundle: nil), forCellReuseIdentifier: "ChatMessageImagesLeftCell")
        tableView.register(UINib(nibName: "ChatMessageImageRightCell", bundle: nil), forCellReuseIdentifier: "ChatMessageImageRightCell")
        // tableView.backgroundView = UIImageView(image: UIImage(named: "Group 4360"))
        paramDict["room_id"] = roomID
        paramDict["reciver_id"] = oncallPatientId
        paramDict["sender_id"] = senderId
        SocketHelper.shared.emit(with: .roomJoin, paramDict)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let dateKey = self.dateArr.first
            if let date =  dateKey{
                let model1 = self.chatDateDict[date]
                if model1?.count ?? 0 > 0 {
                    self.tableView.scrollsToTop = true
                    self.tableView.reloadData()
                    self.setscrollPosition()
                }else{
                    debugPrint("No message")
                }
            }
        }
        
//        SocketHelper.shared.on(with: .message) { (data) in
//            let currentDate = Date().stringDateFor(format: "dd-MM-yyyy")
//            guard let dict = data.first as? [String: String] else { return }
//            let myData = try? Doctorchathistory(from: dict)
//            let message = dict["message"]
//            let newDict = self.chatDateDict[currentDate]
//            let iamge = newDict?.last
//            let dataImage = iamge?.message
//            if dataImage == message as? String {
//                print("match")
//            } else {
//                if let data = myData {
//                    print(self.chatDateDict)
//                    self.chatDateDict[currentDate]?.append()
//                    if self.chatDateDict[currentDate]?.count ?? 0 > 0{
//                        self.setscrollPosition()
//                    }else{
//                        debugPrint("No messsage")
//                    }
//                    
//                }
//            }
//            
//            self.tableView.reloadData()
//        }
        SocketHelper.shared.on(with: .message) { (data) in
            let currentDate = Date().stringDateFor(format: "dd-MM-yyyy")
            
            // Ensure data is in the expected format
            guard let dict = data.first as? [String: Any],
                  let myData = try? Doctorchathistory(from: dict) else {
                print("Invalid data format or parsing failed")
                return
            }
            
            let message = dict["message"] as? String
            let newDict = self.chatDateDict[currentDate]
            let lastMessage = newDict?.last?.message
            
            if lastMessage == message {
                print("Match: Message already exists")
            } else {
                if var chatArray = self.chatDateDict[currentDate] {
                    chatArray.append(myData) // Add new message to existing date
                    self.chatDateDict[currentDate] = chatArray
                } else {
                    self.chatDateDict[currentDate] = [myData] // Initialize array if nil
                    self.dateArr.append(currentDate)
                }
                
                if let chatCount = self.chatDateDict[currentDate]?.count, chatCount > 0 {
                    self.tableView.reloadData()

                } else {
                    debugPrint("No message found")
                }
            }
            
            self.tableView.reloadData()
        }

        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = dateArr[section]
        return chatDateDict[dateKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateKey = dateArr[indexPath.section]
        let model = chatDateDict[dateKey]
        let sender = model?[indexPath.row].senderId ?? ""
        let userId = UserDefaults.standard.string(forKey: Constants.userId)
        if userId == sender {
            if model?[indexPath.row].type == "text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageRightCell", for: indexPath) as! ChatMessageRightCell
                cell.backgroundColor = .clear
                cell.lblMessage.text = model?[indexPath.row].message
                cell.lblTime.text = self.timeDateConversion(formateDate: String(model?[indexPath.row].createdAt ?? ""))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageImageRightCell", for: indexPath) as! ChatMessageImageRightCell
                cell.backgroundColor = .clear
                if let imageUrl = model?[indexPath.row].message {
                    let components = imageUrl.split(separator: "/")
                    let urlType = components.last?.split(separator: ".")
                    if urlType?.first == ".mp4" {
                        //  cell.imgMessage.image = self.getThumbnailImageFromVideoUrl(forUrl: URL(string:imageUrl)!)
                        self.getThumbnailImageFromVideoUrl(url: URL(string:imageUrl)!) { (thumbImage) in
                            cell.imgMessage.image = thumbImage
                        }
                        cell.btnPlay.isHidden = false
                        cell.lblTime.text = self.timeDateConversion(formateDate: String(model?[indexPath.row].createdAt ?? ""))
                    } else {
                        cell.imgMessage.sd_setImage(with: URL(string:imageUrl))
                        cell.btnPlay.isHidden = true
                        cell.lblTime.text = self.timeDateConversion(formateDate: String(model?[indexPath.row].createdAt ?? ""))
                    }
                    return cell
                }
            }
        }else {
            if model?[indexPath.row].type == "text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageLeftCell", for: indexPath) as! ChatMessageLeftCell
                
                cell.backgroundColor = .clear
                // cell.lblUserName.text = "name"
                cell.lblMessage.text = model?[indexPath.row].message
                cell.lblTime.text = self.timeDateConversion(formateDate: String(model?[indexPath.row].createdAt ?? ""))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageImagesLeftCell", for: indexPath) as! ChatMessageImagesLeftCell
                cell.backgroundColor = .clear
                if let imageUrl = model?[indexPath.row].message {
                    let components = imageUrl.split(separator: "/")
                    let urlType = components.last?.split(separator: ".")
                    if urlType?.last == "mp4" {
                        // cell.imgMessage.image = getThumbnailImage(forUrl: URL(string:imageUrl)!)
                        self.getThumbnailImageFromVideoUrl(url: URL(string:imageUrl)!) { (thumbImage) in
                            cell.imgMessage.image = thumbImage
                        }
                        cell.btnPlay.isHidden = false
                        cell.btnPlay.tag = indexPath.row
                        cell.btnPlay.addTarget(self, action: #selector(btnPlayPressed), for: .touchUpInside)
                        cell.lblTime.text = self.timeDateConversion(formateDate: String(model?[indexPath.row].createdAt ?? ""))
                    } else {
                        cell.imgMessage.sd_setImage(with: URL(string:imageUrl))
                        cell.btnPlay.isHidden = true
                        cell.lblTime.text = self.timeDateConversion(formateDate: String(model?[indexPath.row].createdAt ?? ""))
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateKey = dateArr[indexPath.section]
        let model = chatDateDict[dateKey]
        if model?[indexPath.row].type == "video" {
            if let vedioUrl = model?[indexPath.row].message {
                let videoURL = URL(string: vedioUrl)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                playerViewController.allowsPictureInPicturePlayback = false
                   if #available(iOS 14.2, *) {
                       playerViewController.canStartPictureInPictureAutomaticallyFromInline = false
                   }
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        } else {
            if let url = URL(string: model?[indexPath.row].message ?? "") {
                if let data = try? Data(contentsOf: url) {
                    let imageInfo = GSImageInfo(image: UIImage(data: data) ?? UIImage(), imageMode: .aspectFit)
                    let transitionInfo = GSTransitionInfo(fromView: view)
                    let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                    imageViewer.dismissCompletion = {
                        print("dismiss called")
                    }
                    present(imageViewer, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = DateHeaderLabel()
        label.backgroundColor = .clear
        let currentDate = Date().stringDateFor(format: "dd-MM-yyyy")
        let date = dateArr[section]
        if date == currentDate {
            label.text = "Today"
        } else {
            label.text = dateArr[section]
        }
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                label.textColor = .white
            } else {
                label.textColor = .black
            }
        }
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        let containerView = UIView()
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //   func reloadDataTable(){
    //        self.tableView.reloadData()
    //        DispatchQueue.main.async {
    //            let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
    //            self.tableView.setContentOffset(scrollPoint, animated: true)
    //        }
    //
    //    }
    
    
    func setscrollPosition() {
        DispatchQueue.main.async {
            let numberOfSections = self.tableView.numberOfSections > 0 ? self.tableView.numberOfSections - 1 : 0
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections)
            let indexPath = NSIndexPath(row: numberOfRows-1, section: numberOfSections)
            self.tableView.scrollToRow(at: indexPath as IndexPath,at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}

//MARK:- Extension for ActionSheet Camera, Gallery
extension ChatViewController {
    func openActionSheet() {
        let alert:UIAlertController=UIAlertController(title: "Choose Option" , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title:  "Send Photo", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openPhoto()
        }
        let vedioAction = UIAlertAction(title: "Send Video", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openVedio()
        }
        
        //        let fileAction = UIAlertAction(title: "Send Doc", style: UIAlertAction.Style.default)
        //        {
        //            UIAlertAction in
        //            AppToast.showMessage(message: "Under Development")
        //        }
        
        let cancelAction = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(vedioAction)
        // alert.addAction(fileAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openPhoto(){
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image" , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title:  "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let GalleryAction = UIAlertAction(title:  "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openPhotoGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(GalleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openVedio() {
        let alert:UIAlertController=UIAlertController(title: "Choose Vedio" , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Recorder", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.recordVideo()
        }
        let GalleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openVideoGalllery()
        }
        let cancelAction = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(GalleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "camera", message:"You don't have camera", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK" , style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openVideoGalllery(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func recordVideo() {
        let imag = UIImagePickerController()
        imag.delegate = self
        imag.sourceType = UIImagePickerController.SourceType.camera;
        imag.cameraDevice = UIImagePickerController.CameraDevice.rear //or Front
        imag.mediaTypes = [kUTTypeMovie as String]
        self.present(imag, animated: true, completion: nil)
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: 100 , height: 100)
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let name = UserDefaults.standard.string(forKey: Constants.userName)
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            Indicator.shared.showProgressView(view)
            AWSS3Manager.shared.uploadImage(image: image, progress: nil) { (sucess, error) in
                Indicator.shared.hideProgressView()
                self.paramDict["message"] = sucess
                self.paramDict["type"] = "image"
                self.paramDict["userName"] = name
                self.paramDict["senderType"] = "doctor"
                self.paramDict["reciver_id"] = self.userId ?? EMPTY
                if self.dateArr.count == 0 {
                    self.performChatHistory()
                }
                SocketHelper.shared.emit(with: EventListnerKeys.message, self.paramDict) { (json) in
                    print("json. from emit function.........\(json)")
                    
                }
            }
        } else {
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                _ = createVideoThumbnail(from: mediaURL)
                Indicator.shared.showProgressView(view)
                AWSS3Manager.shared.uploadVideo(tagValue: nil, videoUrl: mediaURL, progress: nil) { (sucess, error) in
                    Indicator.shared.hideProgressView()
                    self.paramDict["message"] = sucess
                    self.paramDict["type"] = "video"
                    self.paramDict["userName"] = name
                    self.paramDict["senderType"] = "doctor"
                    self.paramDict["reciver_id"] = self.userId ?? EMPTY
                    if self.dateArr.count == 0 {
                        self.performChatHistory()
                    }
                    SocketHelper.shared.emit(with: EventListnerKeys.message, self.paramDict) { (json) in
                        print("json. from emit function.........\(json)")
                        
                    }
                }
            }
        }
        
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if (chosenImage.jpegData(compressionQuality: 0.5) as NSData?) != nil {
                //                attachmentData = imageData
                //self.imgData = newImg.jpegData(compressionQuality: 0.5)!
                //            profileUpdateService(imageData: imageData as Data,image: chosenImage)
            }else{
                print("imageData not found")
            }
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChatViewController{
    func timeDateConversion(formateDate:String) -> String {
        let dateFormatter = DateFormatter()
        let data = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local as TimeZone?
        let date = dateFormatter.date(from: formateDate)
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date ?? data)
        return timeStamp
    }
    
    func dateConversion(formateDate:String) -> String{
        let dateFormatter = DateFormatter()
        let data = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = .current//NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: formateDate)// create   date from string
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = .current
        let timeStamp = dateFormatter.string(from: date ?? data)
        
        return timeStamp
    }
}

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}

extension ChatViewController {
    func fullProfile(param: [String: String]) {
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.chatHistory(parameters: param, header: "DeviceToken")
        }.done { (model: ChatDataModel) in
            self.handleResponse(model: model)
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
    
    func performChatHistory() {
        let roomID = bookingId
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "room_id": roomID]
        fullProfile(param: parameter)
    }
    
    func handleResponse(model: ChatDataModel) {
        if model.status == "SUCCESS" {
            print(model)
            //self.model = model.doctorchathistory ?? [Doctorchathistory]()
            let chatMessageArr = model.doctorchathistory ?? [Doctorchathistory]()
            for chatData in chatMessageArr{
                let date = self.dateConversion(formateDate: chatData.createdAt ?? "")
                
                if self.chatDateDict.keys.contains(date) {
                    self.chatDateDict[date]?.append(chatData)
                } else {
                    self.chatDateDict[date] = [chatData]
                    self.dateArr.append(date)
                }
            }
            self.tableView.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            //AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension Decodable {
    init(from any: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: any)
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

extension Date {
    func stringDateFor(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

class DateHeaderLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let heigth = originalContentSize.height //+ 12
        layer.cornerRadius = heigth / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 20 , height: originalContentSize.height + 10)
    }
}
