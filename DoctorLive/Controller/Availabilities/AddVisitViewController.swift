//
//  AddVisitViewController.swift
//  DoctorLive
//
//  Created by call soft on 30/09/21.
//

import UIKit
import PromiseKit
import SideMenu

protocol UpdateAvilabilitydata {
    func updateAvilabitilty()
}

class AddVisitViewController: UIViewController, DeleteAvilabilityDelegate, EditAvilabilityDelegate, updateVisitDataDelegate {
    
    @IBOutlet weak var tableHieght: NSLayoutConstraint!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var notificationCountTxt: UILabel!
    
    var addslotType = String()
    
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var slotId: String?
    var dayName: String?
    var slotsArray = [Slots]()
    var avilabilityId: String?
    var visitDict = [String: String]()   //what is this
    var id: String?
    var clinic_ID: String?
    var slotAdded = Int()
    var str = "2"
    var index: Int?
    var avilabilityData = [NewSlotAdd]()
    var from: String?
    var to: String?
    var clinicIdToPass: String?
    var availabilitOnVisitItem1 = [Availabilityfetch]()
    var availabilitOnCallItem1 = [Availabilityfetch]()
    var avililabilityList1: AvililabilityListModel?
    var deleteItmeId: String?
    var updateDelegate: UpdateAvilabilitydata? = nil
    
    var callBackToRoot:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCountTxt.text = String(count)
        addMoreButton.setTitle("Add More".localized(), for: .normal)
        if dayName == "Mon" {
            titleLable.text = "Monday".localized()
        } else if dayName == "Tue" {
            titleLable.text = "Tuesday".localized()
        } else if dayName == "Wed" {
            titleLable.text = "Wednesday".localized()
        } else if dayName == "Thu" {
            titleLable.text = "Thursday".localized()
        } else if dayName == "Fri" {
            titleLable.text = "Friday".localized()
        } else if dayName == "Sat" {
            titleLable.text = "Saturday".localized()
        } else if dayName == "Sun" {
            titleLable.text = "Sunday".localized()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if addslotType == "CallSlots" {
            self.performGetAvilability()
        } else {
            self.performGetAvilabilityVisit1()
        }
        setUpTable()
        
    }
    
    func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.register(UINib(nibName: "AddMoreVisitTableViewCell", bundle: nil), forCellReuseIdentifier: "AddMoreVisitTableViewCell")
        if addslotType == "CallSlots" {
            if str == "1"{
                tableHieght.constant = CGFloat(120 * (availabilitOnCallItem1[index ?? 0].slots?.first?.slots?.count ?? 0))
                tableView.layoutIfNeeded()
            }else{
                tableHieght.constant = 0
            }
        } else {
            if str == "1"{
                tableHieght.constant = CGFloat(120 * (availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?.count ?? 0))
                tableView.layoutIfNeeded()
            }else{
                tableHieght.constant = 0
            }
        }
        
    }
    
    @IBAction func addMoreTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddVisitAvilabilityVC") as! AddVisitAvilabilityVC
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.slotsArray = slotsArray
        vc.dayName = dayName ?? ""
        //        slotAdded = availabilitOnVisitItem[index ?? 0].slots?.first?.slots?.count ?? 0
        slotAdded = slotsArray.first?.slots?.count ?? 0
        slotAdded += 1
        vc.slotAdd = slotAdded
        vc.addSlotType = addslotType
        vc.addAvilabilityId = avilabilityId
        vc.callBack = {
            self.dismiss(animated: true, completion: nil)
            self.callBackToRoot?()
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func buttonTapped1(cell: AddMoreVisitTableViewCell) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddVisitAvilabilityVC") as! AddVisitAvilabilityVC
        vc.visitDict = visitDict
        vc.callBack = {
            self.dismiss(animated: true, completion: nil)
            self.callBackToRoot?()
           // self.dismiss(animated: true, completion: nil)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.avilabilityId = avilabilityId
        vc.slotId = slotId
        vc.id = id
        vc.dayName = dayName ?? ""
        vc.editSlot = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func goToFirstViewController() {
        let dic = ["myMessage": "testing"]
        NotificationCenter.default.post(name: Notification.Name("NotificationName"), object: dic)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func notificationTapped(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func updateVisitData(slot: [Slots]) {
        self.slotsArray = slot
        tableView.reloadData()
    }
    
    func buttonTapped(cell: AddMoreVisitTableViewCell) {
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?".localized(), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { [weak self]_ in
            guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
            if self?.addslotType == "CallSlots" {
                self?.from = self?.availabilitOnCallItem1[self?.index ?? 0].slots?.first?.slots?[indexPath.row].from
                self?.to = self?.availabilitOnCallItem1[self?.index ?? 0].slots?.first?.slots?[indexPath.row].to
                self?.clinicIdToPass = self?.availabilitOnCallItem1[self?.index ?? 0].slots?.first?.slots?[indexPath.row].clinicId
            } else {
                self?.from = self?.availabilitOnVisitItem1[self?.index ?? 0].slots?.first?.slots?[indexPath.row].from
                self?.to = self?.availabilitOnVisitItem1[self?.index ?? 0].slots?.first?.slots?[indexPath.row].to
                self?.clinicIdToPass = self?.availabilitOnVisitItem1[self?.index ?? 0].slots?.first?.slots?[indexPath.row].clinicId
            }
            //            self?.tableView.beginUpdates()
            //            self?.slotsArray.first?.slots?.remove(at: indexPath.row)
            //            self?.tableView.deleteRows(at: [indexPath], with: .bottom)
            //            self?.tableView.endUpdates()
            self?.validations()
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { [self]_ in
            self.tableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
}

//MARK:- Extension for tableView Delegate & DataSource

extension AddVisitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if addslotType == "CallSlots" {
            if str == "1" {
                return availabilitOnCallItem1[index ?? 0].slots?.first?.slots?.count ?? 0
            } else {
                return 0
            }
        } else {
            if str == "1"{
                return availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?.count ?? 0
            }else{
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMoreVisitTableViewCell", for: indexPath) as! AddMoreVisitTableViewCell
        if addslotType == "CallSlots" {
            cell.delegate = self
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(self.editCallSlot), for: .touchUpInside)
            cell.clinicName.text = availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[indexPath.row].clinic
            let status = availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[indexPath.row].status
            if status == "0" {
                cell.statusLable.text = "Status: Not Available"
            } else {
                cell.statusLable.text = "Status: Available"
            }
            cell.slotTime.text = "\(availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[indexPath.row].from ?? "") - \(availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[indexPath.row].to ?? "")"
            
        } else {
            cell.delegate = self
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(self.editVisitSlot), for: .touchUpInside)
            cell.clinicName.text = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[indexPath.row].clinic
            let status = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[indexPath.row].status
            if status == "0" {
                cell.statusLable.text = "Status: Not Available"
            } else {
                cell.statusLable.text = "Status: Available"
            }
            cell.slotTime.text = "\(availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[indexPath.row].from ?? "") - \(availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[indexPath.row].to ?? "")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    @objc func editCallSlot(sender: UIButton) {
        let index1 = sender.tag
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddVisitAvilabilityVC") as! AddVisitAvilabilityVC
        vc.callBack = {
            self.dismiss(animated: true, completion: nil)
            self.callBackToRoot?()
            
           // self.navigationController?.popViewController(animated: true)
            
        }
        vc.visitDict = visitDict
        vc.addSlotType = "CallSlots"
        vc.addAvilabilityId = avilabilityId
        vc.slotId = slotId
        vc.id = id
        vc.slotsArray = slotsArray
        vc.from = availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[index1].from
        vc.to = availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[index1].to
        vc.avilability = availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[index1].status
        vc.clinic_ID = availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[index1].clinicId
        vc.slotNo = availabilitOnCallItem1[index ?? 0].slots?.first?.slots?[index1].slotNum
        vc.editSlot = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func editVisitSlot(sender: UIButton) {
        let index1 = sender.tag
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddVisitAvilabilityVC") as! AddVisitAvilabilityVC
        vc.callBack = {
            self.dismiss(animated: true, completion: nil)
            self.callBackToRoot?()
           
        }
        vc.visitDict = visitDict
        vc.addAvilabilityId = avilabilityId
        vc.slotId = slotId
        vc.id = id
        vc.slotsArray = slotsArray
        vc.from = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[index1].from
        vc.to = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[index1].to
        vc.avilability = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[index1].status
        vc.clinicName = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[index1].clinic
        vc.clinic_ID = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[index1].clinicId
        vc.slotNo = availabilitOnVisitItem1[index ?? 0].slots?.first?.slots?[index1].slotNum
        vc.editSlot = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
 }

extension AddVisitViewController {
    func addQualification(param: [String: String]) {
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.deleteClinicVisit(parameters: param, header: "DeviceToken")
        }.done { (model: ClinicListModel) in
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
    
    func validations() {
        guard let doctor_Id = UserDefaults.standard.string(forKey: Constants.userId) else {return}
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": doctor_Id,
                     "id": avilabilityId ?? "",
                     "from": from ?? "",
                     "to": to ?? "",
                     "clinic_id": clinicIdToPass ?? ""]
        addQualification(param: parameter)
    }
    
    func handleResponse(model: ClinicListModel){
        print("suceess")
        if model.status == "SUCCESS"{
            DispatchQueue.main.async {
                self.performGetAvilabilityVisit1()
                self.performGetAvilability()
            }
            LoaderController.sharedInstance.removeLoader()
        } else {
            
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}


extension AddVisitViewController {
    func getAvilabilityListVisit1(param: [String: String]){
        firstly {
            service!.getAvilabilityList1(parameters: param, header: "DeviceToken")
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
    
    func performGetAvilabilityVisit1(){
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "type": "visit"]
        getAvilabilityListVisit1(param: parameter)
    }
    
    func updateQualification1(model: AvililabilityListModel) {
        if model.status == "SUCCESS" {
            self.avililabilityList1 = model
            if let data = model.availabilityfetch {
                if availabilitOnVisitItem1.count > 0 {
                    availabilitOnVisitItem1.removeAll()
                }
                availabilitOnVisitItem1 = data
                print("availabilitOnVisitItem ......\(availabilitOnVisitItem1)")
                
                if availabilitOnVisitItem1.count > 0 {
                    self.str = "1"
                    setUpTable()
                    tableView.reloadData()
                }
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
  }

extension AddVisitViewController {
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
    
    func updateQualification(model: AvililabilityListModel) {
        if model.status == "SUCCESS" {
            
            if let data = model.availabilityfetch {
                if availabilitOnCallItem1.count > 0 {
                    availabilitOnCallItem1.removeAll()
                }
                availabilitOnCallItem1 = data
                print("availabilitOnVisitItem ......\(availabilitOnCallItem1)")
                
                if availabilitOnCallItem1.count > 0 {
                    self.str = "1"
                    setUpTable()
                    tableView.reloadData()
                }
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
