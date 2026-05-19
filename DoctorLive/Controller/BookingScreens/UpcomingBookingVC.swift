//
//  UpcomingBookingVC.swift
//  DoctorLive
//
//  Created by call soft on 15/09/21.
//

import UIKit
import PromiseKit
import SideMenu

class UpcomingBookingVC: UIViewController {
    
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var onCallButton: UIButton!
    @IBOutlet weak var onCallLable: UILabel!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var clinicLable: UILabel!
    @IBOutlet weak var clinicButton: UIButton!
    @IBOutlet weak var pastBookingTableView: UITableView!
    @IBOutlet weak var myBookingLbl: UILabel!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var notificationCountTxt: UILabel!
    var menu: SideMenuNavigationController?
    var bookingOnCallArray:[Call] = []
    var isComingFromNot = false
    var bookingOnVisit:[Visit] = []
    var upcomingOnCall: [UpComingCall] = []
    var upcomingVisit: [UpComingVisit] = []
    var pastOnCall:[PastCall] = []
    var pastVisit:[PastVisit] = []
    var oncall: Bool = true
    var visit: Bool = false
    var bookingId = String()
    var pastonCall: Bool = true
    var pastclinicVisit:Bool = false
    var upcomingonCall: Bool = true
    var upcomingClincVisit: Bool = false
    var allBooking: Bool = true
    var allpastBooking: Bool = false
    var allpreviousBooking: Bool = false
    var table1: Bool = true
    var table2: Bool = false
    var table3: Bool = false
    var onCallpatientId: String?
    var onClinicPatientId: String?
    var profilePic: String?
    var name: String?
    var age: String?
    var gender: String?
    var time: String?
    var date: String?
    var reasonForReject: String?
    var userData = [String: String]()
    var isCameScreen = String()
    var endCallId = String()
    var forceCallEnd = Bool()
    var comeFromPip = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.validations()
        
        pastBookingTableView.isHidden = true
        upcomingTableView.isHidden = true
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.register(UINib(nibName: "OnCallHomeCell", bundle: nil), forCellReuseIdentifier: "OnCallHomeCell")
        tableView1.reloadData()
        pastBookingTableView.delegate = self
        pastBookingTableView.dataSource = self
        pastBookingTableView.register(UINib(nibName: "PastTableViewCell", bundle: nil), forCellReuseIdentifier: "PastTableViewCell")
        pastBookingTableView.reloadData()
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        upcomingTableView.register(UINib(nibName: "VisitTableViewCell", bundle: nil), forCellReuseIdentifier: "VisitTableViewCell")
        upcomingTableView.reloadData()
        setUpTable()
        clinicLable.isHidden = true
        clinicLable.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1C75BC")
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    
    func setUpTable() {
        myBookingLbl.text = "My Bookings".localized()
        if isCameScreen == "ChatScreen" {
            seg.selectedSegmentIndex = 2
            self.performPastBooking()
            if forceCallEnd == true {
                performEndCall()
            }
            table3 = true
            table2 = false
            table1 = false
            allBooking = false
            allpreviousBooking = false
            allpastBooking = true
            oncall = false
            visit = false
            pastonCall = true
            pastclinicVisit = true
            upcomingonCall = false
            upcomingClincVisit = false
            tableView1.isHidden = true
            pastBookingTableView.isHidden = false
            upcomingTableView.isHidden = true
        } else if isCameScreen == "Payment" {
            seg.selectedSegmentIndex = 1
            self.performUpcomingBooking()
            table2 = true
            table1 = false
            table3 = false
            allBooking = false
            allpreviousBooking = true
            allpastBooking = false
            oncall = false
            visit = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = true
            upcomingClincVisit = true
            tableView1.isHidden = true
            pastBookingTableView.isHidden = true
            upcomingTableView.isHidden = false
        } else {
            seg.selectedSegmentIndex = 0
        }
        seg.setTitle("Pending".localized(), forSegmentAt: 0)
        seg.setTitle("Upcoming".localized(), forSegmentAt: 1)
        seg.setTitle("Previous".localized(), forSegmentAt: 2)
        onCallButton.setTitle( "ON CALL".localized(), for: .normal)
        clinicButton.setTitle( "CLINIC VISIT".localized(), for: .normal)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        clinicButton.setTitleColor(.black, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clinicButton.setTitleColor(UIColor(named: "TextColour"), for: .normal)
        performNotificationUnread()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if isCameScreen == "ChatScreen" {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
            show(secondVC, sender: self)
        } else if isCameScreen == "Payment" && comeFromPip == true {
            comeFromPip = false
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
            show(secondVC, sender: self)
        } else if isCameScreen == "Booking" {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
            show(secondVC, sender: self)
        } else {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
            show(secondVC, sender: self)
        }
    }
    
    @IBAction func onCallTapped(_ sender: Any) {
        onCallButton.setTitleColor(Utils.shared.hexStringToUIColor(hex: "#1C75BC"), for: .normal)
        clinicButton.setTitleColor(UIColor(named: "TextColour"), for: .normal)
        onCallLable.isHidden = false
        clinicLable.isHidden = true
        if allBooking == true {
            oncall = true
            visit = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = false
            upcomingClincVisit = false
            self.tableView1.reloadData()
        } else if allpreviousBooking == true {
            oncall = false
            visit = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = true
            upcomingClincVisit = false
            self.upcomingTableView.reloadData()
        } else if allpastBooking == true {
            oncall = false
            visit = false
            pastonCall = true
            pastclinicVisit = false
            upcomingonCall = false
            upcomingClincVisit = false
            self.pastBookingTableView.reloadData()
        } else {
            oncall = true
            visit = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = false
            upcomingClincVisit = false
            self.tableView1.reloadData()
        }
    }
    
    @IBAction func clinicTapped(_ sender: Any) {
        onCallButton.setTitleColor(UIColor(named: "TextColour"), for: .normal)
        clinicButton.setTitleColor(Utils.shared.hexStringToUIColor(hex: "#1C75BC"), for: .normal)
        onCallLable.isHidden = true
        clinicLable.isHidden = false
        if allBooking == true {
            visit = true
            oncall = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = false
            upcomingClincVisit = false
            self.tableView1.reloadData()
        } else if allpreviousBooking == true {
            oncall = false
            visit = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = false
            upcomingClincVisit = true
            self.upcomingTableView.reloadData()
        } else if allpastBooking == true {
            oncall = false
            visit = false
            pastonCall = false
            pastclinicVisit = true
            upcomingonCall = false
            upcomingClincVisit = false
            self.pastBookingTableView.reloadData()
        } else {
            visit = true
            oncall = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = false
            upcomingClincVisit = false
            self.tableView1.reloadData()
        }
    }
    
    @IBAction func notificationTapped(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func indexChange(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            self.validations()
            table1 = true
            table2 = false
            table3 = false
            allBooking = true
            allpreviousBooking = false
            allpastBooking = false
            oncall = true
            visit = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = false
            upcomingClincVisit = false
            tableView1.isHidden = false
            pastBookingTableView.isHidden = true
            upcomingTableView.isHidden = true
            
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
            self.performUpcomingBooking()
            table2 = true
            table1 = false
            table3 = false
            allBooking = false
            allpreviousBooking = true
            allpastBooking = false
            oncall = false
            visit = false
            pastonCall = false
            pastclinicVisit = false
            upcomingonCall = true
            upcomingClincVisit = true
            tableView1.isHidden = true
            pastBookingTableView.isHidden = true
            upcomingTableView.isHidden = false
            
        } else if (sender as AnyObject).selectedSegmentIndex == 2 {
            self.performPastBooking()
            table3 = true
            table2 = false
            table1 = false
            allBooking = false
            allpreviousBooking = false
            allpastBooking = true
            oncall = false
            visit = false
            pastonCall = true
            pastclinicVisit = true
            upcomingonCall = false
            upcomingClincVisit = false
            tableView1.isHidden = true
            pastBookingTableView.isHidden = false
            upcomingTableView.isHidden = true
            
        }
    }
}

extension UpcomingBookingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if table1 == true {
            if oncall == true {
                return bookingOnCallArray.count
            } else if visit == true {
                return bookingOnVisit.count
            } else {
                return bookingOnCallArray.count
            }
        } else if table2 == true {
            if upcomingonCall == true {
                return upcomingOnCall.count
            } else if upcomingClincVisit == true {
                return upcomingVisit.count
            } else{
                return upcomingOnCall.count
            }
        } else if table3 == true {
            if pastonCall == true {
                return pastOnCall.count
            } else if pastclinicVisit == true {
                return pastVisit.count
            } else {
                return pastOnCall.count
            }
        }
        return bookingOnCallArray.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("oncall..........\(oncall)")
        if table1 == true {
            if oncall == true {
                guard let cell = tableView1.dequeueReusableCell(withIdentifier: "OnCallHomeCell", for: indexPath) as? OnCallHomeCell else { return UITableViewCell()}
                cell.reasonOfVisit.isHidden = true
                cell.reasonForCall.isHidden = false
                if bookingOnCallArray[indexPath.row].bookingStatusName == "Pending" {
                    cell.confirmButton.isHidden = false
                    cell.rejectButton.isHidden = false
                } else {
                    cell.confirmButton.isHidden = true
                    cell.rejectButton.isHidden = true
                }
               // let age  = getAgeFromDOF(date: bookingOnCallArray[indexPath.row].memberDob ?? "")
                let gender = bookingOnCallArray[indexPath.row].memberGender
                if gender == "m" {
                    cell.gender.text = "Male".localized()
                } else if  gender == "f" {
                    cell.gender.text = "Female".localized()
                } else {
                    cell.gender.text = "Others".localized()
                }
                cell.ageLable.text = "\(bookingOnCallArray[indexPath.row].memberDob ?? "") Yrs,"
                if bookingOnCallArray[indexPath.row].memberName == "Me" {
                    cell.nameLable.text = bookingOnCallArray[indexPath.row].name
                } else{
                    cell.nameLable.text = bookingOnCallArray[indexPath.row].memberName
                }
                
                cell.dateLable.text = "\(bookingOnCallArray[indexPath.row].scheduleDate ?? ""),"
                cell.timeLable.text = bookingOnCallArray[indexPath.row].scheduleTime
                self.name = bookingOnCallArray[indexPath.row].name
                self.profilePic = bookingOnCallArray[indexPath.row].fileImg
                cell.confirmButton.tag = indexPath.row
                cell.rejectButton.tag = indexPath.row
                cell.reasonForCall.tag = indexPath.row
                cell.confirmButton.addTarget(self, action: #selector(self.confirmBookingTapped), for: .touchUpInside)
                cell.rejectButton.addTarget(self, action: #selector(self.rejectBooking), for: .touchUpInside)
                cell.reasonForCall.addTarget(self, action: #selector(self.reasonButton), for: .touchUpInside)
                self.onCallpatientId = bookingOnCallArray[indexPath.row].userId
                
                return cell
            } else if visit == true {
                guard let cell1 = tableView1.dequeueReusableCell(withIdentifier: "OnCallHomeCell", for: indexPath) as? OnCallHomeCell else { return UITableViewCell()}
               
                cell1.reasonOfVisit.isHidden = false
                cell1.reasonForCall.isHidden = true
                if bookingOnVisit[indexPath.row].bookingStatusName == "Pending" {
                    cell1.confirmButton.isHidden = false
                    cell1.rejectButton.isHidden = false
                } else {
                    cell1.confirmButton.isHidden = true
                    cell1.rejectButton.isHidden = true
                }
                //let age  = getAgeFromDOF(date: bookingOnVisit[indexPath.row].memberDob!)
                let gender = bookingOnVisit[indexPath.row].memberGender
                if gender == "m" {
                    cell1.gender.text = "Male".localized()
                } else if  gender == "f" {
                    cell1.gender.text = "Female".localized()
                } else {
                    cell1.gender.text = "Others".localized()
                }
                cell1.ageLable.text = "\(bookingOnVisit[indexPath.row].memberDob ?? "") Yrs,"
                if bookingOnVisit[indexPath.row].memberName == "Me" {
                    cell1.nameLable.text = bookingOnVisit[indexPath.row].name
                } else{
                    cell1.nameLable.text = bookingOnVisit[indexPath.row].memberName
                }
                cell1.dateLable.text = "\(bookingOnVisit[indexPath.row].scheduleDate ?? ""),"
                cell1.timeLable.text = bookingOnVisit[indexPath.row].scheduleTime
                cell1.confirmButton.tag = indexPath.row
                //cell1.reasonForCall.setTitle("Reason Of Visit".localized(), for: .normal)
                cell1.rejectButton.tag = indexPath.row
                cell1.reasonOfVisit.tag = indexPath.row
                cell1.confirmButton.addTarget(self, action: #selector(self.confirmBookingTapped), for: .touchUpInside)
                cell1.rejectButton.addTarget(self, action: #selector(self.rejectBooking), for: .touchUpInside)
                cell1.reasonOfVisit.addTarget(self, action: #selector(self.reasonButton), for: .touchUpInside)
                return cell1
            }
        } else if table2 == true {
            if upcomingonCall == true {
                guard let cell = upcomingTableView.dequeueReusableCell(withIdentifier: "VisitTableViewCell", for: indexPath) as? VisitTableViewCell else { return UITableViewCell() }
                //let age  = getAgeFromDOF(date: upcomingOnCall[indexPath.row].memberDob ?? "")
                let gender = upcomingOnCall[indexPath.row].memberGender
                if gender == "m" {
                    cell.gender.text = "Male".localized()
                } else if  gender == "f" {
                    cell.gender.text = "Female".localized()
                } else {
                    cell.gender.text = "Others".localized()
                }
                cell.ageLable.text = "\(upcomingOnCall[indexPath.row].memberDob ?? "") Yrs,"
                if upcomingOnCall[indexPath.row].memberName == "Me" {
                    cell.nameLable.text = upcomingOnCall[indexPath.row].name
                } else{
                    cell.nameLable.text = upcomingOnCall[indexPath.row].memberName
                }
                cell.confirmButton.setTitle("Chat".localized(), for: .normal)
                cell.reasonForReject.setTitle("Reason for Call".localized(), for: .normal)
                cell.confirmButton.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1C75BC")
                cell.prescription.isHidden = true
                cell.reportButton.isHidden = true
                cell.confirmButton.isHidden = false
                cell.heightConstant.constant = 170
                cell.dateLable.text = upcomingOnCall[indexPath.row].scheduleDate
                cell.reasonForReject.addTarget(self, action: #selector(self.reasonForUpcominTapped), for: .touchUpInside)
                cell.timeLable.text = upcomingOnCall[indexPath.row].scheduleTime
                cell.confirmButton.addTarget(self, action: #selector(self.chatButtonTapped), for: .touchUpInside)
                cell.reasonForReject.isHidden = false
                cell.resonOfVisit.isHidden = true
                cell.confirmButton.tag = indexPath.row
                cell.reasonForReject.tag = indexPath.row
                return cell
            } else if upcomingClincVisit == true {
               guard let cell1 = upcomingTableView.dequeueReusableCell(withIdentifier: "VisitTableViewCell", for: indexPath) as? VisitTableViewCell else { return UITableViewCell()}
                //let age = getAgeFromDOF(date: upcomingVisit[indexPath.row].memberDob!)
                let gender = upcomingVisit[indexPath.row].memberGender
                if gender == "m" {
                    cell1.gender.text = "Male".localized()
                } else if  gender == "f" {
                    cell1.gender.text = "Female".localized()
                } else {
                    cell1.gender.text = "Others".localized()
                }
                cell1.ageLable.text = "\(upcomingVisit[indexPath.row].memberDob ?? "") Yrs,"
                cell1.reasonForReject.setTitle("Reason for Visit".localized(), for: .normal)
                cell1.reasonForReject.addTarget(self, action: #selector(self.reasonButton), for: .touchUpInside)
                cell1.confirmButton.setTitle("End Visit".localized(), for: .normal)
                cell1.confirmButton.backgroundColor = .red
                cell1.prescription.isHidden = true
                cell1.reportButton.isHidden = true
                cell1.confirmButton.isHidden = false
                cell1.heightConstant.constant = 170
                cell1.confirmButton.tag = indexPath.row
                cell1.resonOfVisit.tag = indexPath.row
                cell1.reasonForReject.isHidden = true
                cell1.resonOfVisit.isHidden = false
                if upcomingVisit[indexPath.row].memberName == "Me" {
                    cell1.nameLable.text = upcomingVisit[indexPath.row].name
                } else{
                    cell1.nameLable.text = upcomingVisit[indexPath.row].memberName
                }
                cell1.dateLable.text = upcomingVisit[indexPath.row].scheduleDate
                cell1.timeLable.text = upcomingVisit[indexPath.row].scheduleTime
                cell1.resonOfVisit.addTarget(self, action: #selector(self.reasonForUpcominTapped), for: .touchUpInside)
                cell1.confirmButton.addTarget(self, action: #selector(self.endClincVisit), for: .touchUpInside)
                
                return cell1
            }
        } else if table3 == true {
            if pastonCall == true {
                guard let cell = pastBookingTableView.dequeueReusableCell(withIdentifier: "PastTableViewCell", for: indexPath) as? PastTableViewCell else { return UITableViewCell()}
                
                if pastOnCall[indexPath.row].bookingStatusName == "Cancel"{
                    cell.rejectLable.text = "cancelled".localized()
                    cell.rejectLable.isHidden = false
                    cell.chatButton.isHidden = true
                    cell.prescription.isHidden = true
                } else if pastOnCall[indexPath.row].bookingStatusName == "Reject"{
                    cell.rejectLable.text = "Rejected".localized()
                    cell.rejectLable.isHidden = false
                    cell.chatButton.isHidden = true
                    cell.prescription.isHidden = true
                    cell.reasonOfVisit.setTitle("Reason for Reject".localized(), for: .normal)
                } else {
                    cell.rejectLable.isHidden = true
                    cell.chatButton.isHidden = false
                    cell.prescription.isHidden = false
                    cell.reasonForReject.setTitle("Reason for Call".localized(), for: .normal)
                }
                //let age = getAgeFromDOF(date: pastOnCall[indexPath.row].memberDob ?? "")
                let gender = pastOnCall[indexPath.row].memberGender
                if gender == "m" {
                    cell.gender.text = "Male".localized()
                } else if  gender == "f" {
                    cell.gender.text = "Female".localized()
                } else {
                    cell.gender.text = "Others".localized()
                }
                cell.reasonForReject.isHidden = false
                cell.reasonOfVisit.isHidden = true
                cell.ageLable.text = "\(pastOnCall[indexPath.row].memberDob ?? "") Yrs,"
                if pastOnCall[indexPath.row].memberName == "Me" {
                    cell.nameLable.text = pastOnCall[indexPath.row].name
                } else{
                    cell.nameLable.text = pastOnCall[indexPath.row].memberName
                }
                cell.dateLable.text = pastOnCall[indexPath.row].scheduleDate
                cell.timeLable.text = pastOnCall[indexPath.row].scheduleTime
                cell.prescription.tag = indexPath.row
                cell.chatButton.tag = indexPath.row
                cell.reasonForReject.tag = indexPath.row
                let prescription = pastOnCall[indexPath.row].filePdf
                if prescription?.isEmpty ?? false {
                    cell.prescription.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#B0B0B1")
                } else {
                    cell.prescription.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1389CA")
                }
                cell.reasonForReject.addTarget(self, action: #selector(self.reasonForRejectTapped), for: .touchUpInside)
                cell.prescription.addTarget(self, action: #selector(self.prescriptionTapped), for: .touchUpInside)
                cell.chatButton.addTarget(self, action: #selector(self.chatButtonTapped), for: .touchUpInside)
                cell.parent1 = self
                return cell
            } else if pastclinicVisit == true {
                guard let cell1 = pastBookingTableView.dequeueReusableCell(withIdentifier: "PastTableViewCell", for: indexPath) as? PastTableViewCell else { return UITableViewCell()}
                if pastVisit[indexPath.row].bookingStatusName == "Cancel"{
                    cell1.rejectLable.text = "cancelled".localized()
                    cell1.rejectLable.isHidden = false
                    cell1.chatButton.isHidden = true
                    cell1.prescription.isHidden = true
                } else if pastVisit[indexPath.row].bookingStatusName == "Reject"{
                    cell1.rejectLable.text = "Rejected".localized()
                    cell1.rejectLable.isHidden = false
                    cell1.chatButton.isHidden = true
                    cell1.prescription.isHidden = true
                    cell1.reasonOfVisit.setTitle("Reason for Reject".localized(), for: .normal)
                } else {
                    cell1.rejectLable.isHidden = true
                    cell1.chatButton.isHidden = false
                    cell1.prescription.isHidden = false
                    cell1.reasonForReject.setTitle("Reason for Call".localized(), for: .normal)
                }
               // let age = getAgeFromDOF(date: pastVisit[indexPath.row].memberDob ?? "")
                let gender = pastVisit[indexPath.row].memberGender
                if gender == "m" {
                    cell1.gender.text = "Male".localized()
                } else if  gender == "f" {
                    cell1.gender.text = "Female".localized()
                } else {
                    cell1.gender.text = "Others".localized()
                }
                cell1.reasonForReject.isHidden = true
                cell1.reasonOfVisit.isHidden = false
                let prescription = pastVisit[indexPath.row].filePdf
                if prescription?.isEmpty ?? false {
                    cell1.prescription.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#B0B0B1")
                } else {
                    cell1.prescription.backgroundColor = Utils.shared.hexStringToUIColor(hex: "#1389CA")
                }
                cell1.ageLable.text = "\(pastVisit[indexPath.row].memberDob ?? "") Yrs,"
                if pastVisit[indexPath.row].memberName == "Me" {
                    cell1.nameLable.text = pastVisit[indexPath.row].name
                } else{
                    cell1.nameLable.text = pastVisit[indexPath.row].memberName
                }
                cell1.prescription.tag = indexPath.row
                cell1.chatButton.tag = indexPath.row
                cell1.reasonOfVisit.setTitle("Reason for Visit".localized(), for: .normal)
                cell1.reasonOfVisit.addTarget(self, action: #selector(self.reasonForRejectTapped), for: .touchUpInside)
                cell1.dateLable.text = pastVisit[indexPath.row].scheduleDate
                cell1.prescription.addTarget(self, action: #selector(self.prescriptionTapped), for: .touchUpInside)
                cell1.chatButton.addTarget(self, action: #selector(self.chatButtonTapped), for: .touchUpInside)
                cell1.timeLable.text = pastVisit[indexPath.row].scheduleTime
                return cell1
            }
        }
        return UITableViewCell()
    }
    
    @objc func endClincVisit(sender: UIButton) {
        let index = sender.tag
        self.endCallId = upcomingVisit[index].id ?? ""
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
        vc.isCameScreen = "ChatScreen"
        performEndCall()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func reasonForUpcominTapped(sender: UIButton) {
        let index = sender.tag
        let action = ReasonForVisitPopUp()
        if upcomingonCall == true {
            action.message = upcomingOnCall[index].reasonVisit
        } else {
            action.message = upcomingVisit[index].reasonVisit
        }
        action.modalTransitionStyle = .crossDissolve
        action.modalPresentationStyle = .overCurrentContext
        self.present(action, animated: true)
    }
    
    @objc func reasonForRejectTapped(sender: UIButton) {
        let index = sender.tag
        let action = ReasonForVisitPopUp()
        if pastonCall == true {
            action.message = pastOnCall[index].reasonVisit
        } else {
            action.message = pastVisit[index].reasonVisit
        }
        action.modalTransitionStyle = .crossDissolve
        action.modalPresentationStyle = .overCurrentContext
        self.present(action, animated: true)
    }
    
    @objc func reasonButton(sender: UIButton) {
        let index = sender.tag
        let action = ReasonForVisitPopUp()
        if oncall == true {
            action.message = bookingOnCallArray[index].reasonVisit
        } else {
            action.message = bookingOnVisit[index].reasonVisit
        }
        action.modalTransitionStyle = .crossDissolve
        action.modalPresentationStyle = .overCurrentContext
        self.present(action, animated: true)
    }
    
    @objc func confirmBookingTapped(sender: UIButton) {
        let index = sender.tag
        if oncall == true{
            self.bookingId = bookingOnCallArray[index].id ?? ""
        } else {
            self.bookingId = bookingOnVisit[index].id ?? ""
        }
        let indexPath1 = IndexPath(row: index, section: 0)
        let action = ConfirmBooking()
        action.addBookingCallBack = {
            let cell = self.tableView1.cellForRow(at: indexPath1) as! OnCallHomeCell
            cell.confirmButton.isHidden = true
            cell.rejectButton.isHidden = true
            cell.reasonForCall.setTitle("Reason for Call".localized(), for: .normal)
            self.tableView1.reloadData()
            self.performConfirmBooking()
        }
        action.modalTransitionStyle = .crossDissolve
        action.modalPresentationStyle = .overCurrentContext
        self.present(action, animated: true)
    }
    
    @objc func rejectBooking(sender: UIButton){
        let index = sender.tag
        let indexPath1 = IndexPath(row: index, section: 0)
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "RejectPopVC") as! RejectPopVC
        vc.rejectCallBack = {
            _ = self.tableView1.cellForRow(at: indexPath1) as! OnCallHomeCell
            self.validations()
        }
        if oncall == true{
            vc.bookingId = bookingOnCallArray[index].id
        } else {
            vc.bookingId = bookingOnVisit[index].id
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func chatButtonTapped(sender: UIButton) {
        let index = sender.tag
        if upcomingonCall == true {
            let vc = ChatViewController()
            vc.index = 1
            vc.bookingId = upcomingOnCall[index].id ?? ""
            vc.deviceToken = upcomingOnCall[index].devicetoken ?? ""
            //let age = getAgeFromDOF(date: upcomingOnCall[index].memberDob!)
            if upcomingOnCall[index].memberName == "Me" {
                userData = ["name": upcomingOnCall[index].name ?? "",
                            "gender": upcomingOnCall[index].memberGender ?? "",
                            "time": upcomingOnCall[index].createdDate ?? "",
                            "reason": upcomingOnCall[index].reasonVisit ?? "",
                            "date": "\(upcomingOnCall[index].memberDob ?? "") Yrs,",
                            "id": upcomingOnCall[index].id ?? ""]
            } else{
                userData = ["name": upcomingOnCall[index].memberName ?? "",
                            "gender": upcomingOnCall[index].memberGender ?? "",
                            "time": upcomingOnCall[index].createdDate ?? "",
                            "reason": upcomingOnCall[index].reasonVisit ?? "",
                            "date": "\(upcomingOnCall[index].memberDob ?? "") Yrs,",
                            "id": upcomingOnCall[index].id ?? ""]
            }
            vc.data = userData
            vc.oncallPatientId = upcomingOnCall[index].userId
            if upcomingOnCall[index].memberName == "Me" {
                vc.name = upcomingOnCall[index].name
            } else{
                vc.name = upcomingOnCall[index].memberName
            }
            //vc.name = upcomingOnCall[index].name
            vc.number = upcomingOnCall[index].mobile
           
            //vc.image = upcomingOnCall[index].filePdf
            self.navigationController?.pushViewController(vc, animated: true)
        } else if pastonCall == true {
            let vc = ChatViewController()
            vc.index = 2
            vc.oncallPatientId = pastOnCall[index].userId
            vc.deviceToken = pastOnCall[index].devicetoken ?? ""
            if pastOnCall[index].memberName == "Me" {
                vc.name = pastOnCall[index].name
            } else{
                vc.name = pastOnCall[index].memberName
            }
            
            //let age = getAgeFromDOF(date: pastOnCall[index].memberDob!)
            if pastOnCall[index].memberName == "Me" {
                userData = ["name": pastOnCall[index].name ?? "",
                            "gender": pastOnCall[index].memberGender ?? "",
                            "time": pastOnCall[index].createdDate ?? "",
                            "reason": pastOnCall[index].reasonVisit ?? "",
                            "date": "\(pastOnCall[index].memberDob ?? "") Yrs,",
                            "id": pastOnCall[index].id ?? ""]
            } else{
                userData = ["name": pastOnCall[index].memberName ?? "",
                            "gender": pastOnCall[index].memberGender ?? "",
                            "time": pastOnCall[index].createdDate ?? "",
                            "reason": pastOnCall[index].reasonVisit ?? "",
                            "date": "\(pastOnCall[index].memberDob ?? "") Yrs,",
                            "id": pastOnCall[index].id ?? ""]
            }
            
            vc.data = userData
            if pastOnCall[index].chatMode == "off" {
                vc.chatSessionExpired = true
            }
            vc.bookingId = pastOnCall[index].id ?? ""
            //vc.image = pastOnCall[index].filePdf
            self.navigationController?.pushViewController(vc, animated: true)
        } else if pastclinicVisit == true {
            let vc = ChatViewController()
            vc.index = 2
            vc.oncallPatientId = pastVisit[index].userId
            if pastVisit[index].memberName == "Me" {
                vc.name = pastVisit[index].name
            } else{
                vc.name = pastVisit[index].memberName
            }
            
            vc.hideCam = true
            if pastVisit[index].chatMode == "off" {
                vc.chatEnd = true
            }
            vc.bookingId = pastVisit[index].id ?? ""
            // vc.image = pastVisit[index].filePdf
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.bookingId = upcomingVisit[index].id ?? ""
            performEndCall()
        }
        
    }
    
    @objc func prescriptionTapped(sender: UIButton) {
        let index = sender.tag
        if pastonCall == true {
            let prescriptionOnCall = pastOnCall[index].filePdf
            if prescriptionOnCall?.isEmpty == true  {
                let vc = PrescriptionViewController()
                vc.bookingId = pastOnCall[index].id
                //let age = getAgeFromDOF(date: pastOnCall[index].memberDob!)
                if pastOnCall[index].memberName == "Me" {
                    userData = ["name": pastOnCall[index].name ?? "",
                                "gender": pastOnCall[index].memberGender ?? "",
                                "time": pastOnCall[index].createdDate ?? "",
                                "reason": pastOnCall[index].reasonVisit ?? "",
                                "date": "\(pastOnCall[index].memberDob ?? "") Yrs,",
                                "id": pastOnCall[index].id ?? ""]
                } else{
                    userData = ["name": pastOnCall[index].memberName ?? "",
                                "gender": pastOnCall[index].memberGender ?? "",
                                "time": pastOnCall[index].createdDate ?? "",
                                "reason": pastOnCall[index].reasonVisit ?? "",
                                "date": "\(pastOnCall[index].memberDob ?? "")Yrs,",
                                "id": pastOnCall[index].id ?? ""]
                }
                vc.data = userData
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                let vc = PrescriptionViewVC()
                vc.urlString = pastOnCall[index].fileImg
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let prescriptionOnVisit = pastVisit[index].filePdf
            if prescriptionOnVisit?.isEmpty == true {
                let vc = PrescriptionViewController()
                vc.bookingId = pastVisit[index].id
                //let age = getAgeFromDOF(date: pastVisit[index].memberDob!)
                
                if pastVisit[index].memberName == "Me" {
                    userData = ["name": pastVisit[index].name ?? "",
                                "gender": pastVisit[index].memberGender ?? "",
                                "time": pastVisit[index].createdDate ?? "",
                                "reason": pastVisit[index].reasonVisit ?? "",
                                "date": "\(pastVisit[index].memberDob ?? "") Yrs,",
                                "id": pastVisit[index].id ?? ""]
                } else{
                    userData = ["name": pastVisit[index].memberName ?? "",
                                "gender": pastVisit[index].memberGender ?? "",
                                "time": pastVisit[index].createdDate ?? "",
                                "reason": pastVisit[index].reasonVisit ?? "",
                                "date": "\(pastVisit[index].memberDob ?? "") Yrs,",
                                "id": pastVisit[index].id ?? ""]
                }
                
                vc.data = userData
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = PrescriptionViewVC()
                
                vc.urlString = pastVisit[index].fileImg
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func prescriptionVisitTapped(sender: UIButton) {
        let index = sender.tag
        let prescription = pastVisit[index].filePdf
        if prescription?.isEmpty == true {
            let vc = PrescriptionViewController()
            vc.bookingId = pastVisit[index].id
            //let age = getAgeFromDOF(date: pastVisit[index].memberDob!)
            if pastVisit[index].memberName == "Me" {
                userData = ["name": pastVisit[index].name ?? "",
                            "gender": pastVisit[index].memberGender ?? "",
                            "time": pastVisit[index].createdDate ?? "",
                            "reason": pastVisit[index].reasonVisit ?? "",
                            "date": "\(pastVisit[index].memberDob ?? "") Yrs,",
                            "id": pastVisit[index].id ?? ""]
            } else{
                userData = ["name": pastVisit[index].memberName ?? "",
                            "gender": pastVisit[index].memberGender ?? "",
                            "time": pastVisit[index].createdDate ?? "",
                            "reason": pastVisit[index].reasonVisit ?? "",
                            "date": "\(pastVisit[index].memberDob ?? "") Yrs,",
                            "id": pastVisit[index].id ?? ""]
            }
            
            vc.data = userData
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = PrescriptionViewVC()
            vc.urlString = pastVisit[index].fileImg
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func clincVist(sender: UIButton) {
        let vc = ChatViewController()
        vc.onclinicPatentId = onClinicPatientId ?? ""
        vc.name = name
        vc.image = profilePic
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
