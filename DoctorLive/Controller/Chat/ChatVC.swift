////
////  ChatVC.swift
////  DoctorLive
////
////  Created by call soft on 21/09/21.
////
//
//import UIKit
//import RealmSwift
//
//class ChatVC: UIViewController, UITextViewDelegate {
//
//    //MARK:-IBOutlet
//    @IBOutlet var tableView: UITableView!
//    @IBOutlet var txtView_Message: UITextView!
//    @IBOutlet weak var bottomChatView: UIView!
//    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var btn_Send: UIButton!
//    @IBOutlet weak var viewChat: UIView!
//    
//    //MARK:-Variable
//    let obj = CommonClass.sharedInstance
//    var items: Doctorchathistory?
//    var chatType: String?
//    let socketModel = SocketIOManager()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.txtViewDelegate()
//        //self.txtView_Message.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        //Internet Checking Functionality
//        defaultConfiguration()
//        //self.delegateWarningMessageView = self
//        setNavi()
//        //Socket Calling
//        initialSetup()
//    }
//    
//    func setNavi(){
//        hideNavigationBar(false)
//        setupNavigationBarTitle("\(chatType ?? "")", leftBarButtonsType: [.back], rightBarButtonsType: [])
//       }
//    
//    
//    @IBAction func btn_SendMessage(_ sender: UIButton) {
//        
//        let strMessage = txtView_Message.text ?? ""
//        
//        if strMessage != "Type here..." && strMessage != ""{
//            
//            sendMessage()
//            
//        }
//    }
//}
//
////MARK:- TableView Delegate and DataSource
//
//extension ChatVC:UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return socketModel.chatDataModel[0].data?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        //   if indexPath.row == 1 {
//     if self.getInfoById().id == socketModel.chatDataModel[0].data?[indexPath.row].senderId{
//            
//            self.tableView.register(UINib.init(nibName: "SenderCell" , bundle: nil), forCellReuseIdentifier: "SenderCell" )
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
//            cell.item = socketModel.chatDataModel[0].data?[indexPath.row]
//            return cell
//            
//        }else{
//            
//            self.tableView.register(UINib.init(nibName: "ReceiverCell" , bundle: nil), forCellReuseIdentifier: "ReceiverCell" )
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
//            cell.item = socketModel.chatDataModel[0].data?[indexPath.row]
//            return cell
//            
//        }
//        
//    }
//    
//    func setscrollPosition(){
//        let numberOfSections = self.tableView.numberOfSections
//        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
//        let indexPath = NSIndexPath(row: numberOfRows-1, section: numberOfSections-1)
//        self.tableView.scrollToRow(at: indexPath as IndexPath,at: UITableView.ScrollPosition.bottom, animated: true)
//    }
//    
//    func configureTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorColor = UIColor.clear
//        tableView.reloadData()
//        self.txtView_Message.text = "Type here..."
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if self.socketModel.chatDataModel[0].data?.count ?? 0 > 0 {
//                self.tableView.scrollsToTop = true
//                self.setscrollPosition()
//            }
//        }
//    }
//}
////MARK:- UITextView Methods
////MARK:-
//extension ChatVC{
//    func adjustUITextViewHeight(arg : UITextView)
//    {
//        arg.translatesAutoresizingMaskIntoConstraints = true
//  
//        self.txtView_Message.frame = CGRect(x: self.viewChat.bounds.origin.x + 5, y: self.bottomChatView.bounds.origin.y + 15, width: self.viewChat.bounds.width, height: self.bottomChatView.bounds.height)
//        arg.sizeToFit()
//        arg.isScrollEnabled = false
//    }
//    
//    
//    //MARK:- TxtView Custom Method..
//    fileprivate func txtViewDelegate(){
//        txtView_Message.textColor = UIColor.darkGray
//        txtView_Message.text = "Type here..."
//        txtView_Message.delegate = self
//    }
//    
//    //MARK:- TextView Delegate
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if (txtView_Message.text == "Type here...") {
//            txtView_Message.text = nil
//            txtView_Message.textColor = UIColor.darkGray
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//      if txtView_Message.text.isEmpty {
//            txtView_Message.text = "Type here..."
//            txtView_Message.textColor = UIColor.darkGray
//      }
//        txtView_Message.resignFirstResponder()
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        
//      //  adjustUITextViewHeight(arg: self.txtView_Message)
//    }
//}
//
////MARK:- SocketIOManager Class Calling
////MARK:-
//
//extension ChatVC: TryAgainDeleagte{
////    func loadWarinigView() {
////        let ref = self.showWarningMessageView(self.view, "Sorry,ERx requires an Internet Connection!")
////        ref.delegate = self
////    }
//    
//    func tryAgain() {
//        initialSetup()
//    }
//    
//    func initialSetup()  {
//        self.chatType == "Chat with Delivery Boy" ? socketModel.socketHandling(id: items?.deliveryRoomId ?? "") : socketModel.socketHandling(id: items?.providerRoomId ?? "")
//        getChatHistoryData()
//    }
//    
//    func sendMessage() {
//          // When chat with Provider
//            let messageDict = ["roomId" : items?.providerRoomId ?? "",
//                               "message" : self.txtView_Message.text ?? "",
//                               "messageType" : "Text",
//                               "senderId":self.getInfoById().id ?? "",
//                               "receiverId":items?.providerId?.Id ?? "",
//                               "receiverToken":items?.providerId?.deviceToken ?? ""] as [String : Any]
//            socketModel.socket.emit("message", messageDict)
//            socketModel.getChatHistoryService(roomId: items?.providerRoomId ?? "")
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            
//            self.clouserSetup()
//        }
//    }
//    
//    func clouserSetup(){
//        
//        socketModel.reloadList = {[weak self] () in
//            
//            self?.configureTableView()
//            if self?.socketModel.chatDataModel[0].data?.count ?? 0 == 0{
//                let ref = self?.showWarningMessageView(self!.view, "No \(self?.chatType ?? "Chat") Data Found!")
//                ref?.delegate = self
//            }else{
//              let ref = self?.showWarningMessageView()
//                ref?.removeFromSuperview()
//            }
//            
//        }
//    }
//    
//    func getChatHistoryData(){
//        showActivityIndicator(view: view)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.socketModel.getChatHistoryService(roomId: self.chatType == "Chat with Delivery Boy" ? self.items?.deliveryRoomId ?? "": self.items?.providerRoomId ?? "")
//            self.clouserSetup()
//        }
//        
//    }
//}
