//
//  DayAvilabilityVC.swift
//  DoctorLive
//
//  Created by call soft on 28/09/21.
//

import UIKit
import PromiseKit
import KYDrawerController
import SideMenu

class DayAvilabilityVC: UIViewController, PerformUpdateAvilability, UpdateAvilabilitydata {
    
    @IBOutlet weak var visitTableView: UITableView!
    @IBOutlet weak var calltableView: UITableView!
    @IBOutlet weak var avilabilityLbl: UILabel!
    @IBOutlet weak var notificationCountTxt: UILabel!
    var menu: SideMenuNavigationController?
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var table1: Bool = true
    var table2: Bool = false
    var slotSet: String?
    var oncall: Bool = true
    var visit: Bool = false
    var section = 0
    var avililabilityList: AvililabilityListModel?
    var dayName: String?
    var slots: [Slots] = []
    var specialtyListArray:[String] = Array()
    var slotID: String?
    var temp: String?
    var setav: Bool?
    var avilabilityId: String?
    var avilabilityId1: String?
    var slotCount: Int?
    var onCallAvilabilityDict = [String: String]()
    var availabilitOnCallItem = [Availabilityfetch]()
    var availabilitOnVisitItem = [Availabilityfetch]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        avilabilityLbl.text = "Availabilities".localized()
        visitTableView.isHidden = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        performGetAvilability()
        notificationCountTxt.text = String(count)
        performGetAvilabilityVisit()
        visitTableView.reloadData()
    }
    
    @IBAction func menuButton(_ sender: Any){
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
        show(secondVC, sender: self)
    }
    
    func updateAvilability() {
        performGetAvilability()
        visitTableView.reloadData()
    }
    func updateAvilabitilty() {
        performGetAvilability()
        visitTableView.reloadData()
    }
    
    @IBAction func notification(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func segTapped(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            calltableView.isHidden = false
            visitTableView.isHidden = true
            self.calltableView.reloadData()
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
            calltableView.isHidden = true
            visitTableView.isHidden = false
            self.visitTableView.reloadData()
        }
    }
    
    func setupTableView() {
        calltableView.delegate = self
        calltableView.dataSource = self
        visitTableView.delegate = self
        visitTableView.dataSource = self
        calltableView.register(UINib(nibName: "AvilabilityTableViewCell", bundle: nil), forCellReuseIdentifier: "AvilabilityTableViewCell")
        visitTableView.register(UINib(nibName: "VisitAvilabilityTableViewCell", bundle: nil), forCellReuseIdentifier: "VisitAvilabilityTableViewCell")
        visitTableView.showsVerticalScrollIndicator = false
        
        calltableView.showsVerticalScrollIndicator = false
        calltableView.rowHeight = UITableView.automaticDimension
        calltableView.estimatedRowHeight = 60
        performGetAvilability()
        performGetAvilabilityVisit()
    }
}

extension DayAvilabilityVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if seg.selectedSegmentIndex == 0 {
            return availabilitOnCallItem.count
//        } else  {
//            return availabilitOnVisitItem.count
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if seg.selectedSegmentIndex == 0 {
            let cell = visitTableView.dequeueReusableCell(withIdentifier: "VisitAvilabilityTableViewCell", for: indexPath) as! VisitAvilabilityTableViewCell
            cell.parent1 = self
            cell.visitTableBtn.tag = indexPath.row
            cell.visitTableBtn.addTarget(self, action: #selector(callBtnTap), for: .touchUpInside)
            if availabilitOnCallItem[indexPath.row].flag == "1" {
                cell.dayName.backgroundColor = .systemGreen
                cell.setVisibilityTxt.isHidden = true
                cell.tableView.isHidden = false
                cell.setVisibilityTxt.text = ""
                cell.slotType = "Call"
                cell.fetchData = availabilitOnCallItem[indexPath.row].slots
                cell.setupTableView()
                cell.dayName.text = availabilitOnCallItem[indexPath.row].dayName ?? ""
            }else{
                cell.dayName.text = availabilitOnCallItem[indexPath.row].dayName ?? ""
                cell.setVisibilityTxt.text = "Set Availability".localized()
                cell.setVisibilityTxt.isHidden = false
                cell.dayName.backgroundColor = .gray
                cell.tableView.isHidden = true
            }
            return cell
//        } else {
//            let cell1 = visitTableView.dequeueReusableCell(withIdentifier: "VisitAvilabilityTableViewCell", for: indexPath) as! VisitAvilabilityTableViewCell
//            cell1.parent1 = self
//            cell1.visitTableBtn.tag = indexPath.row
//            cell1.visitTableBtn.addTarget(self, action: #selector(callBtnTap), for: .touchUpInside)
//            if availabilitOnVisitItem[indexPath.row].flag == "1" {
//                cell1.dayName.backgroundColor = .systemGreen
//                cell1.setVisibilityTxt.isHidden = true
//                cell1.tableView.isHidden = false
//                cell1.setVisibilityTxt.text = ""
//                cell1.slotType = "Visit"
//                cell1.fetchData = availabilitOnVisitItem[indexPath.row].slots
//                cell1.setupTableView()
//                cell1.dayName.text = availabilitOnVisitItem[indexPath.row].dayName ?? ""
//            }else{
//                cell1.dayName.text = availabilitOnVisitItem[indexPath.row].dayName ?? ""
//                cell1.setVisibilityTxt.text = "Set Availability".localized()
//                cell1.setVisibilityTxt.isHidden = false
//                cell1.dayName.backgroundColor = .gray
//                cell1.tableView.isHidden = true
//            }
//            return cell1
//        }
    }
    //Mark:- Call slot button Tapped
    @objc func callBtnTap(_ sender: UIButton){
//        if seg.selectedSegmentIndex == 0 {
            let slot = availabilitOnCallItem[sender.tag].slots?.first?.slots
            if slot?.count != 0 {
                let vc = AddVisitViewController()
                vc.updateDelegate = self
                vc.addslotType = "CallSlots"
                vc.callBackToRoot = {
                    self.navigationController?.popViewController(animated: true)
                }
                vc.slotsArray = availabilitOnCallItem[sender.tag].slots ?? [Slots]()
                vc.avilabilityId = availabilitOnCallItem[sender.tag].id
                vc.id = availabilitOnCallItem[sender.tag].id
                vc.slotId =  availabilitOnCallItem[sender.tag].slots?.first?.id
                vc.dayName = availabilitOnCallItem[sender.tag].dayName
                vc.index = sender.tag
                self.navigationController?.pushViewController(vc, animated: true)
            }
//        } else {
//            let slot = availabilitOnVisitItem[sender.tag].slots?.first?.slots
//            if slot?.count != 0 {
//                let vc = AddVisitViewController()
//                vc.updateDelegate = self
//                vc.addslotType = "VisitSlots"
//                vc.callBackToRoot = {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                vc.slotsArray = availabilitOnVisitItem[sender.tag].slots ?? [Slots]()
//                vc.avilabilityId = availabilitOnVisitItem[sender.tag].id
//                vc.id = availabilitOnVisitItem[sender.tag].id
//                vc.slotId =  availabilitOnVisitItem[sender.tag].slots?.first?.id
//                vc.dayName = availabilitOnVisitItem[sender.tag].dayName
//                vc.index = sender.tag
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if seg.selectedSegmentIndex == 0 {
            return UITableView.automaticDimension
//        }else{
//            if availabilitOnVisitItem[indexPath.row].slots?.count == 0 {
//                return 80
//            }else{
//                return CGFloat(80 * (availabilitOnVisitItem[indexPath.row].slots?.first?.slots?.count ?? 1 ))
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension DayAvilabilityVC {
    func getAvilabilityList(param: [String: String]){
        firstly {
            service!.getAvilabilityList(parameters: param, header: "DeviceToken")
        }.done { (model: AvililabilityListModel) in
            self.updateQualification(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
                
            }
        }
    }
    
    func performGetAvilability() {
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "type": "call"]
        getAvilabilityList(param: parameter)
    }
    
    func updateQualification(model: AvililabilityListModel){
        if model.status == "SUCCESS" {
            if let data = model.availabilityfetch {
                if availabilitOnCallItem.count > 0 {
                    availabilitOnCallItem.removeAll()
                }
                availabilitOnCallItem = data
                print("availablibility.........:\(availabilitOnCallItem)")
                if availabilitOnCallItem.count > 0 {
                    calltableView.reloadData()
                }
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension DayAvilabilityVC {
    func getAvilabilityListVisit(param: [String: String]){
        firstly {
            service!.getAvilabilityList(parameters: param, header: "DeviceToken")
        }.done { (model: AvililabilityListModel) in
            self.updateQualification1(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
        }.finally {
            DispatchQueue.main.async {
                
            }
        }
    }
    
    func performGetAvilabilityVisit(){
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "type": "visit"]
        getAvilabilityListVisit(param: parameter)
    }
    
    func updateQualification1(model: AvililabilityListModel) {
        if model.status == "SUCCESS" {
            self.avililabilityList = model
            if let data = model.availabilityfetch {
                if availabilitOnVisitItem.count > 0 {
                    availabilitOnVisitItem.removeAll()
                }
                availabilitOnVisitItem = data
                print("availabilitOnVisitItem ......\(availabilitOnVisitItem)")
                if availabilitOnVisitItem.count > 0 {
                    visitTableView.reloadData()
                }
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
