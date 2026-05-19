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
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingBtn, previousBtn, pendingBtn, btnMenu, btnNotification, askFreeBtn, articleBtn, followUpBtn, previousBookingBtn: UIButton!
    @IBOutlet weak var followUpTopConst: NSLayoutConstraint!     // 10, 0
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var stackVw, previousStackVw: UIStackView!
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
    
    var sinchToken: String?
    var rtcAgoroToken: String?
    var userId: String?
    var patientName: String?
    var bookingId: String?
    var doctorId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerXib()
        self.setUpViews()
        self.setUpTable()
        self.performPendingBooking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.previousStackVw.isHidden = false
        self.stackHeight.constant = 44
        self.followUpTopConst.constant = 10
        self.navigationController?.isNavigationBarHidden = true
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.btnMenu, self.btnNotification, self.stackVw, self.searchVw, self.previousStackVw], cornerRadius: 12, borderColor: UIColor.gray.cgColor, borderWidth: 1)
        GlobalMethods.shared.provideCornerRadius(view: self.articleBtn, cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.askFreeBtn, cornerRadius: 12, borderColor: UIColor(named: "ButtonBlueColor")!.cgColor, borderWidth: 1)
        GlobalMethods.shared.provideCornerRadiusMultipleView(vw: [self.pendingBtn, self.upcomingBtn, self.previousBtn, self.followUpBtn, self.previousBookingBtn], cornerRadius: 12, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        self.switchButton?.isOn = UserDefaults.standard.bool(forKey: "switchState")
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        self.previousBookingBtn.setTitle("Accepted Booking", for: .normal)
        self.followUpBtn.setTitle("Pending Booking", for: .normal)
        self.setUpSegment(selectedBtn: self.followUpBtn, unSelectedBtn: [self.previousBookingBtn])
        if USER_DEFAULTS.bool(forKey: "version") == false{
            self.checkAppVersion(controller: self)
        }
        self.typeOn(string: "Search by patient name...")
        let name = USER_DEFAULTS.string(forKey: Constants.userName) ?? EMPTY
        ZohoSalesIQ.Visitor.setName("Doctor:- \(name)")
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
    
    @objc func acceptBtnTap(_ sender: UIButton){
        self.performConfirmBooking(bookingId: self.pendingBookingData.Pending?[sender.tag].bookingId ?? EMPTY)
    }
    
    @objc func swapBtnTap(_ sender: UIButton){
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "RejectPopVC") as! RejectPopVC
        vc.rejectCallBack = {
            self.performPendingBooking()
        }
        vc.bookingId = self.pendingBookingData.Pending?[sender.tag].bookingId ?? EMPTY
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func reasonForCallBtnTap(_ sender: UIButton){
        let action = ReasonForVisitPopUp()
        switch self.bookingStatus{
        case .PENDING:
            if self.pendingAcceptedStatus == .PENDING {
                action.message = self.pendingBookingData.Pending?[sender.tag].reasonForCall ?? EMPTY
            }else{
                action.message = self.pendingBookingData.Accepted?[sender.tag].reasonForCall ?? EMPTY
            }
        case .UPCOMING:
            action.message = self.upcomingBookingData[sender.tag].reasonForCall ?? EMPTY
        case .PREVIOUS:
            if self.followUpPreviousStatus == .FOLLOW_UP{
                action.message = self.previousBookingData.FollowUp?[sender.tag].reasonForCall ?? EMPTY
            }else{
                action.message = self.previousBookingData.Previous?[sender.tag].reasonForCall ?? EMPTY
            }
        }
        action.modalTransitionStyle = .crossDissolve
        action.modalPresentationStyle = .overCurrentContext
        self.present(action, animated: true)
    }
    
    @objc func videoCallBtnTap(_ sender: UIButton){
        if let _ = self.findVideoCallController() {
            AppToast.showMessage(message: "Video call is already in progress")
        }else{
            self.sinchToken = self.upcomingBookingData[sender.tag].sinchId ?? EMPTY
            self.userId = self.upcomingBookingData[sender.tag].userId ?? EMPTY
            self.patientName = self.upcomingBookingData[sender.tag].patientName ?? EMPTY
            self.bookingId = self.upcomingBookingData[sender.tag].bookingId ?? EMPTY
            self.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
            self.getToken()
        }
    }
    
    @objc func chatBtnTap(_ sender: UIButton){
        let upcoming = self.upcomingBookingData[sender.tag]
        let viewC = DIConfigurator.sharedInst().getChatViewC()
        viewC.senderId = USER_DEFAULTS.string(forKey: Constants.userId)
        viewC.recieverId = upcoming.userId ?? EMPTY
        viewC.roomId = upcoming.bookingId ?? EMPTY
        viewC.profilePic = EMPTY
        viewC.patientName = upcoming.patientName ?? EMPTY
        viewC.sinchToken = upcoming.sinchId ?? EMPTY
        viewC.userId = upcoming.userId ?? EMPTY
        viewC.bookingId = upcoming.bookingId ?? EMPTY
        viewC.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @objc func chatBtnPreviousTap(_ sender: UIButton){
        if self.followUpPreviousStatus == .FOLLOW_UP{
            let followUp = self.previousBookingData.FollowUp?[sender.tag]
            let viewC = DIConfigurator.sharedInst().getChatViewC()
            viewC.senderId = USER_DEFAULTS.string(forKey: Constants.userId)
            viewC.recieverId = followUp?.userId ?? EMPTY
            viewC.roomId = followUp?.bookingId ?? EMPTY
            viewC.profilePic = EMPTY
            viewC.patientName = followUp?.patientName ?? EMPTY
            viewC.sinchToken = followUp?.sinchKey ?? EMPTY
            viewC.userId = followUp?.userId ?? EMPTY
            viewC.bookingId = followUp?.bookingId ?? EMPTY
            viewC.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
            self.navigationController?.pushViewController(viewC, animated: true)
        }else{
            let followUp = self.previousBookingData.Previous?[sender.tag]
            let viewC = DIConfigurator.sharedInst().getChatViewC()
            viewC.senderId = USER_DEFAULTS.string(forKey: Constants.userId)
            viewC.recieverId = followUp?.userId ?? EMPTY
            viewC.roomId = followUp?.bookingId ?? EMPTY
            viewC.profilePic = EMPTY
            viewC.patientName = followUp?.patientName ?? EMPTY
            viewC.sinchToken = followUp?.sinchKey ?? EMPTY
            viewC.userId = followUp?.userId ?? EMPTY
            viewC.bookingId = followUp?.bookingId ?? EMPTY
            viewC.doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
            self.navigationController?.pushViewController(viewC, animated: true)
        }
    }
    
    @objc func prescriptionBtnTap(_ sender: UIButton){
        if self.followUpPreviousStatus == .FOLLOW_UP{
            if self.previousBookingData.FollowUp?[sender.tag].prescription ?? EMPTY == EMPTY {
                let viewC = PrescriptionViewController()
                viewC.bookingId = self.previousBookingData.FollowUp?[sender.tag].bookingId ?? EMPTY
                self.navigationController?.pushViewController(viewC, animated: true)
            }else{
                let vc = PrescriptionViewVC()
                vc.urlString = self.previousBookingData.FollowUp?[sender.tag].prescription ?? EMPTY
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if self.previousBookingData.Previous?[sender.tag].prescription ?? EMPTY == EMPTY {
                let viewC = PrescriptionViewController()
                viewC.bookingId = self.previousBookingData.Previous?[sender.tag].bookingId ?? EMPTY
                self.navigationController?.pushViewController(viewC, animated: true)
            }else{
                let vc = PrescriptionViewVC()
                vc.urlString = self.previousBookingData.Previous?[sender.tag].prescription ?? EMPTY
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
