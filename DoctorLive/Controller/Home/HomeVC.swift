//
//  HomeVC.swift
//  DoctorLive
//
//  Created by User on 17/08/21.
//

import UIKit
import KYDrawerController
import PromiseKit
import Mobilisten
import SideMenu
import AgoraRtcKit

class HomeVC: UIViewController {
    
//    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var btnMenu, btnNotification, askFreeBtn, articleBtn: UIButton!
//    @IBOutlet weak var followUpTopConst: NSLayoutConstraint!     // 10, 0
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
//    @IBOutlet weak var stackVw, previousStackVw: UIStackView!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var bookingTblVw: UITableView!{
        didSet{
            self.bookingTblVw.delegate = self
            self.bookingTblVw.dataSource = self
        }
    }
    
    var menu: SideMenuNavigationController?
    var bookingStatus: BookingSegment = .PENDING
    var followUpPreviousStatus: PreviousSegment = .PREVIOUS
    var pendingAcceptedStatus: PendingSegment = .PENDING
    var pendingBookingData = PendingBookingData()
    var upcomingBookingData = [UpcomingBooking]()
    var previousBookingData = PreviousBookingData()
    var allBookingData = [PastCall]()
    
    var currentPage = 1
    var isLoadingList = false
    var isLastPage = false
    var isDataFetched = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var bottomLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.frame = CGRect(x: 0, y: 0, width: self.bookingTblVw.bounds.width, height: 44)
        return loader
    }()
    
    lazy var noInternetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "BackGround") ?? .white
        view.isHidden = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Internet Connection!".localized()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ButtonBlueColor") ?? .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(retryBtnTapped), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return view
    }()
    
    var sinchToken: String?
    var rtcAgoroToken: String?
    var userId: String?
    var patientName: String?
    var bookingId: String?
    var doctorId: String?
    var notifyId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerXib()
        self.setUpViews()
        self.setUpTable()
        // self.performPendingBooking()
        self.performAllBooking(isRefresh: true)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name("RefreshScreen"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshData() {
        self.performAllBooking(isRefresh: false)
        self.performNotificationUnread()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.performNotificationUnread()
        ZohoSalesIQ.showLauncher(false)
        self.navigationController?.isNavigationBarHidden = true
        let dictionary = [".": "_", " ": "_"]
        if let mobile = UserDefaults.standard.value(forKey: Constants.userName.replace(dictionary)) as? String {
            mobile != "" ? (NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId" : mobile.replace(dictionary)])): (print("Enter User name"))
        }
        let name = USER_DEFAULTS.string(forKey: Constants.userName) ?? EMPTY
        let countryCode = USER_DEFAULTS.string(forKey: Constants.countryCode) ?? "+880"
        let contact = USER_DEFAULTS.string(forKey: Constants.mobileNo) ?? EMPTY
        ZohoSalesIQ.Tracking.setPageTitle("Home (Doctor:- \(countryCode) \(contact), \(name))")
    }
    
    private func setUpViews(){
//        self.previousStackVw.isHidden = true
//        self.stackVw.isHidden = true
//        self.stackHeight.constant = 100
//        self.followUpTopConst.constant = 0
//        
//        // Force fully collapse stack views to remove empty space
//        self.stackVw.constraints.forEach { if $0.firstAttribute == .height { $0.isActive = false } }
//        let sHeight = self.stackVw.heightAnchor.constraint(equalToConstant: 0)
//        sHeight.priority = .defaultHigh
//        sHeight.isActive = true
//        
//        self.previousStackVw.constraints.forEach { if $0.firstAttribute == .height { $0.isActive = false } }
//        let psHeight = self.previousStackVw.heightAnchor.constraint(equalToConstant: 0)
//        psHeight.priority = .defaultHigh
//        psHeight.isActive = true
    
        self.navigationController?.isNavigationBarHidden = true
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.btnMenu, self.btnNotification, self.searchVw], cornerRadius: 12, borderColor: UIColor.gray.cgColor, borderWidth: 1) // Removed stackVw and previousStackVw
        // GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.btnMenu, self.btnNotification, self.stackVw, self.searchVw, self.previousStackVw], cornerRadius: 12, borderColor: UIColor.gray.cgColor, borderWidth: 1)
        GlobalMethods.shared.provideCornerRadius(view: self.articleBtn, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.askFreeBtn, cornerRadius: 12, borderColor: UIColor(named: "ButtonBlueColor")!.cgColor, borderWidth: 1)
//        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.followUpBtn], cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        self.switchButton?.isOn = UserDefaults.standard.bool(forKey: "switchState")
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
//        self.previousBookingBtn.setTitle("Accepted Booking", for: .normal)
//        self.followUpBtn.setTitle("Pending Booking", for: .normal)
//        self.setUpSegment(selectedBtn: self.followUpBtn, unSelectedBtn: [])
        if USER_DEFAULTS.bool(forKey: "version") == false{
            self.checkAppVersion(controller: self)
        }
        self.typeOn(string: "Search by patient name...")
        self.searchTxt.delegate = self
        self.searchTxt.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        self.searchTxt.returnKeyType = .search
        
        let name = USER_DEFAULTS.string(forKey: Constants.userName) ?? EMPTY
        ZohoSalesIQ.Visitor.setName("Doctor:- \(name)")
        
        self.view.addSubview(noInternetView)
        NSLayoutConstraint.activate([
            noInternetView.topAnchor.constraint(equalTo: self.bookingTblVw.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: self.bookingTblVw.bottomAnchor),
            noInternetView.leadingAnchor.constraint(equalTo: self.bookingTblVw.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: self.bookingTblVw.trailingAnchor)
        ])
    }
    
    private func registerXib(){
        self.bookingTblVw.register(UINib(nibName: PendingHomeCell.className, bundle: nil), forCellReuseIdentifier: PendingHomeCell.className)
        self.bookingTblVw.register(UINib(nibName: UpcomingHomeCell.className, bundle: nil), forCellReuseIdentifier: UpcomingHomeCell.className)
        self.bookingTblVw.register(UINib(nibName: PreviousHomeCell.className, bundle: nil), forCellReuseIdentifier: PreviousHomeCell.className)
        self.bookingTblVw.register(UINib(nibName: BookingTitleCell.className, bundle: nil), forHeaderFooterViewReuseIdentifier: BookingTitleCell.className)
    }
    
    func setUpTable() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes1, for: .normal)
        if #available(iOS 10.0, *) {
            self.bookingTblVw.refreshControl = refreshControl
        } else {
            self.bookingTblVw.addSubview(refreshControl)
        }
    }
    
    func getAgeFromDOF(date: String) -> (Int,Int,Int) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let dateOfBirth = dateFormater.date(from: date)
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.year, .month, .day], from:
                                                        dateOfBirth ?? Date(), to: Date())
        return (dateComponent.year!, dateComponent.month!, dateComponent.day!)
    }
    
    private func setUpSegment(selectedBtn: UIButton, unSelectedBtn: [UIButton]){
        selectedBtn.setTitleColor(UIColor.white, for: .normal)
        selectedBtn.backgroundColor = UIColor(named: "ButtonBlueColor")
        for button in unSelectedBtn {
            button.setTitleColor(UIColor.gray, for: .normal)
            button.backgroundColor = UIColor(named: "BackGround")
        }
    }
    
    func setUpGender(gender: String) -> String{
        if gender == "m"{
            return "Male"
        }else if gender == "f"{
            return "Female"
        }else{
            return "Other"
        }
    }
    
    @IBAction func btnMenuPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
        show(secondVC, sender: self)
    }
    
    @IBAction func btnNotificationPressed(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    /*
    @IBAction func pendingBtn_Action(_ sender: UIButton){
        self.bookingStatus = .PENDING
        self.previousStackVw.isHidden = false
        self.stackHeight.constant = 44
        self.followUpTopConst.constant = 10
        self.pendingAcceptedStatus = .PENDING
        self.previousBookingBtn.setTitle("Accepted Booking", for: .normal)
        self.followUpBtn.setTitle("Pending Booking", for: .normal)
        self.setUpSegment(selectedBtn: self.followUpBtn, unSelectedBtn: [self.previousBookingBtn])
        self.performPendingBooking()
        self.setUpSegment(selectedBtn: self.pendingBtn, unSelectedBtn: [self.upcomingBtn, self.previousBtn])
    }
    
    @IBAction func upcomingBtn_Action(_ sender: UIButton){
        self.bookingStatus = .UPCOMING
        self.previousStackVw.isHidden = true
        self.stackHeight.constant = 0
        self.followUpTopConst.constant = 0
        self.performUpcomingBooking()
        self.setUpSegment(selectedBtn: self.upcomingBtn, unSelectedBtn: [self.pendingBtn, self.previousBtn])
    }
    
    @IBAction func previousBtn_Action(_ sender: UIButton){
        self.bookingStatus = .PREVIOUS
        self.previousStackVw.isHidden = false
        self.stackHeight.constant = 44
        self.followUpTopConst.constant = 10
        self.followUpPreviousStatus = .PREVIOUS
        self.previousBookingBtn.setTitle("Follow Up", for: .normal)
        self.followUpBtn.setTitle("Previous Booking", for: .normal)
        self.performPastBooking()
        self.setUpSegment(selectedBtn: self.followUpBtn, unSelectedBtn: [self.previousBookingBtn])
        self.setUpSegment(selectedBtn: self.previousBtn, unSelectedBtn: [self.pendingBtn, self.upcomingBtn])
    }
    
    @IBAction func followUpBtn_Action(_ sender: Any) {
        if self.bookingStatus == .PREVIOUS {
            self.followUpPreviousStatus = .PREVIOUS
        }else {
            self.pendingAcceptedStatus = .PENDING
        }
        self.bookingTblVw.reloadData()
        self.setUpSegment(selectedBtn: self.followUpBtn, unSelectedBtn: [self.previousBookingBtn])
    }
    
    @IBAction func previousBookingBtn_Action(_ sender: Any) {
        if self.bookingStatus == .PREVIOUS {
            self.followUpPreviousStatus = .FOLLOW_UP
        }else{
            self.pendingAcceptedStatus = .ACCEPTED
        }
        self.bookingTblVw.reloadData()
        self.setUpSegment(selectedBtn: self.previousBookingBtn, unSelectedBtn: [self.followUpBtn])
    }
    */
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        if (sender.isOn) {
            self.performDoctorAvilability(avilability: "on")
        } else {
            self.performDoctorAvilability(avilability: "off")
        }
    }
    
    @IBAction func articleBtn_Action(_ sender: Any) {
        let viewC = DIConfigurator.sharedInst().getMyArticleViewC()
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func askFreeBtn_Action(_ sender: Any) {
        let viewC = DIConfigurator.sharedInst().getQuestionListViewC()
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @objc func retryBtnTapped() {
        self.noInternetView.isHidden = true
        self.performAllBooking(isRefresh: true)
    }
    
    @objc func acceptBtnTap(_ sender: UIButton){
        self.performConfirmBooking(bookingId: self.allBookingData[sender.tag].id ?? EMPTY)
    }
    
    @objc func swapBtnTap(_ sender: UIButton){
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "RejectPopVC") as! RejectPopVC
        vc.rejectCallBack = {
            self.performAllBooking(isRefresh: true)
        }
        vc.bookingId = self.allBookingData[sender.tag].id ?? EMPTY
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func reasonForCallBtnTap(_ sender: UIButton){
        let action = ReasonForVisitPopUp()
        action.message = self.allBookingData[sender.tag].reasonVisit ?? EMPTY
        action.modalTransitionStyle = .crossDissolve
        action.modalPresentationStyle = .overCurrentContext
        self.present(action, animated: true)
    }
    
    @objc func videoCallBtnTap(_ sender: UIButton){
        if let _ = self.findVideoCallController() {
            AppToast.showMessage(message: "Video call is already in progress")
        }else{
            self.sinchToken = self.allBookingData[sender.tag].devicetoken ?? EMPTY
            self.userId = self.allBookingData[sender.tag].userId ?? EMPTY
            self.patientName = self.allBookingData[sender.tag].memberName ?? EMPTY
            self.bookingId = self.allBookingData[sender.tag].id ?? EMPTY
            self.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
            self.getToken()
        }
    }
    
    @objc func chatBtnTap(_ sender: UIButton){
        let booking = self.allBookingData[sender.tag]
        let viewC = DIConfigurator.sharedInst().getChatViewC()
        viewC.senderId = USER_DEFAULTS.string(forKey: Constants.userId)
        viewC.recieverId = booking.userId ?? EMPTY
        viewC.roomId = booking.id ?? EMPTY
        viewC.profilePic = EMPTY
        viewC.patientName = booking.memberName ?? EMPTY
        viewC.sinchToken = booking.devicetoken ?? EMPTY
        viewC.userId = booking.userId ?? EMPTY
        viewC.bookingId = booking.id ?? EMPTY
        viewC.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @objc func chatBtnPreviousTap(_ sender: UIButton){
        self.chatBtnTap(sender)
    }
    
    @objc func prescriptionBtnTap(_ sender: UIButton){
        if self.allBookingData[sender.tag].filePdf ?? EMPTY == EMPTY {
            let viewC = PrescriptionViewController()
            viewC.bookingId = self.allBookingData[sender.tag].id ?? EMPTY
            self.navigationController?.pushViewController(viewC, animated: true)
        }else{
            let vc = PrescriptionViewVC()
            vc.urlString = self.allBookingData[sender.tag].filePdf ?? EMPTY
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC{
    fileprivate func checkAppVersion(controller: UIViewController){
        let appVersion = ForceUpdateAppVersion.shared.appUpdateAvailable()
        if appVersion.0 {
            alertController(controller: controller, title: "Dr. Live New Update", message: "New version \(appVersion.1 ?? "") is available")
        }
    }
    
    private func alertController(controller:UIViewController,title: String,message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { alert in
            USER_DEFAULTS.set(true, forKey: "version")
        }))
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { alert in
            guard let url = URL(string: "https://apps.apple.com/us/app/dr-live-for-doctors/id1592690667") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        DispatchQueue.main.async {
            controller.present(alertController, animated: true)
        }
    }
}

extension HomeVC{
    func typeOn(string: String) {
        var characterArray = [Character]()
        string.forEach { Char in
            characterArray.append(Char)
        }
        var text = [Character]()
        var characterIndex = 0
        var charrr = ""
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (timer) in
            while characterArray[characterIndex] == " " {
                text.append(" ")
                charrr += String(text.last!)
                self.searchTxt.placeholder = charrr
                characterIndex += 1
                if characterIndex == characterArray.count {
                    timer.invalidate()
                    self.typeOn(string: "Search by patient name...")
                    return
                }
            }
            text.append(characterArray[characterIndex])
            charrr += String(text.last!)
            self.searchTxt.placeholder = charrr
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
                self.typeOn(string: "Search by patient name...")
            }
        }
    }
}

extension HomeVC: VideoCallData{
    func videoCallData(patientName: String, bookingId: String, callDuration: String) {
        self.performEndCall(bookingId: bookingId, reason: EMPTY)
    }
}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.performAllBooking(isRefresh: true)
        return true
    }
    @objc func searchTextChanged(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(triggerSearch), object: nil)
        self.perform(#selector(triggerSearch), with: nil, afterDelay: 0.5)
    }
    
    @objc func triggerSearch() {
        let text = self.searchTxt.text ?? ""
        if text.isEmpty || text.count >= 3 {
            self.performAllBooking(isRefresh: true)
        }
    }
}

extension HomeVC {
    func updateNotificationBadge(count: Int) {
        btnNotification.subviews.filter({$0.tag == 999}).forEach({$0.removeFromSuperview()})
        if count > 0 {
            let dot = UIView(frame: CGRect(x: btnNotification.bounds.width - 20, y: 10, width: 8, height: 8))
            dot.backgroundColor = .red
            dot.layer.cornerRadius = 5
            dot.tag = 999
            btnNotification.addSubview(dot)
        }
    }
    
    func notificationUnreadCount(param: [String: String]){
        firstly {
            service!.notificationUnRead(parameters: param, header: "DeviceToken")
        }.done { (model: NotificationUnreadModel) in
            if model.status == "SUCCESS" {
                self.updateNotificationBadge(count: model.notificationunread ?? 0)
            }
        }.catch { (error) in
            print(error)
        }
    }
    
    func performNotificationUnread() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        notificationUnreadCount(param: parameter)
    }
}
