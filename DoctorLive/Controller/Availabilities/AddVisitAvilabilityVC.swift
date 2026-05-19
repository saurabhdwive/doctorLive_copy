//
//  AddVisitAvilabilityVC.swift
//  DoctorLive
//
//  Created by call soft on 30/09/21.
//

import UIKit
import PromiseKit
import RSSelectionMenu
protocol updateVisitDataDelegate {
    func updateVisitData(slot: [Slots])
}

class AddVisitAvilabilityVC: UIViewController, AnimationProviding {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var selectClinicTxt: UITextField!
    @IBOutlet weak var clinicButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var slotView: UIView!
    @IBOutlet weak var toSlotTime: UITextField!
    @IBOutlet weak var fromSlotTime: UITextField!
    @IBOutlet weak var clinicHeight: NSLayoutConstraint!
    @IBOutlet weak var clinicView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    var dayName = String()
    var navController: UINavigationController?
    var delegate: updateVisitDataDelegate?
    var visitDict = [String: String]()
    var avilabilityData = [NewSlotAdd]()
    var avilability: String?
    var clinicListArray: [Cliniclisting] = []
    var array: [String] = []
    var clinicId: [String] = []
    var slotId: String?
    var id: String?
    var clinicIdForVisit: String?
    var slotNo: String?
    var slotAdd : Int?
    var from: String?
    var to: String?
    var clinicName: String?
    var clinic_ID: String?
    var addSlotType = String()
    var slotsArray = [Slots]()
    var addAvilabilityId: String?
    var editSlot: Bool?
    var avilabilityId: String?
    var updateData = [NewSlotAdd]()
    var updateAvilabilityData = [Slot1]()
    var callBack:(()->())?
    var clinicEdit: Bool = false
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if addSlotType == "CallSlots" {
            clinicView.isHidden = true
            mainViewHeight.constant = 330
            clinicHeight.constant = 0
        }
        
        if avilability == "0" {
            switchButton.isOn = false
        }
        fromSlotTime.text = from
        toSlotTime.text = to
        selectClinicTxt.text = clinicName
        print(clinic_ID as Any)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        backView.addGestureRecognizer(tapGesture)
        mainView.layer.cornerRadius = 25
       
        fromLbl.text = "From".localized()
        toLbl.text = "To".localized()
        selectClinicTxt.placeholder = "Select Clinic".localized()
        statusLbl.text = "Status".localized()
        saveButton.setTitle("Save".localized(), for: .normal)
        if dayName == "Mon" {
            titleLbl.text = "Monday".localized()
        } else if dayName == "Tue" {
            titleLbl.text = "Tuesday".localized()
        } else if dayName == "Wed" {
            titleLbl.text = "Wednesday".localized()
        } else if dayName == "Thu" {
            titleLbl.text = "Thursday".localized()
        } else if dayName == "Fri" {
            titleLbl.text = "Friday".localized()
        } else if dayName == "Sat" {
            titleLbl.text = "Saturday".localized()
        } else if dayName == "Sun" {
            titleLbl.text = "Sunday".localized()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if addSlotType == "CallSlots" {
            titleLbl.text = "Please edit slot for Call".localized()
        } else {
            titleLbl.text = "Please edit slot for Visit".localized()
        }
        validations()
    }
    
    @IBAction func switchButton(_ sender: UISwitch) {
        if (sender.isOn) {
            self.avilability = "1"
        } else {
            self.avilability = "0"
        }
    }
    
    @IBAction func clincTypeButton(_ sender: Any){
        if array.count == 0 {
            AppToast.showMessage1(message: "Please Add Clinic First", self)
        }else {
            let data: [String] = array
            
            var selectedNames: [String] = []
            let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
                cell.textLabel?.text = name
            }
            menu.cellSelectionStyle = .tickmark
            menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
                selectedNames = selectedItems
                self.selectClinicTxt.text = name
                self.clinicIdForVisit = self.clinicId[index]
                self.clinicEdit = true
                self.dismiss(animated: true, completion: nil)
            }
            menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: clinicButton.frame.width, height: view.frame.height), arrowDirection: .up, hideNavBar: true), from: self)
        }
    }
    @IBAction func fromDate(_ sender: Any) {
        let data: [String] = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.fromSlotTime.text = name
            self.dismiss(animated: true, completion: nil)
            
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: fromSlotTime.frame.width, height: view.frame.height - 200), arrowDirection: .down, hideNavBar: true), from: self)
    }
    
    @IBAction func toDate(_ sender: Any) {
        let data: [String] = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm" ]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.toSlotTime.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: toSlotTime.frame.width, height: view.frame.height - 200), arrowDirection: .down, hideNavBar: true), from: self)
    }
    
    @IBAction func saveTapped(_ sender: Any){
        if editSlot == true {
            performUpdateAvilability()
        } else {
            performGetAvilability()
        }
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        if let navController = self.navController{
            navController.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddVisitAvilabilityVC {
    func getAvilabilityList(param:[String:Any]?) {
        ApiManager.instance.fetchApiService(method: .post, url: APIEndpoint.createBooking, passDict: param, header: ApiManager.instance.getHeadeWithJwtToken())  { (result) in
            DispatchQueue.main.async {
                
            }
            switch result{
            case .success(let data):
                let modelData = try? JSONDecoder().decode(AvililabilityListModel.self, from: data)
                print(modelData!)
                if modelData?.message == "Availability slot is already added" {
                    AppToast.showMessage(message: "Availability slot is already added")
                }
                self.delegate?.updateVisitData(slot: self.slotsArray)
               // self.dismiss(animated: true) {
                    self.callBack?()
                LoaderController.sharedInstance.removeLoader()
               // }
                break
            case .failure(let error):
                print("error.........\(error.localizedDescription)")
                break
            }
        }
    }
    
    func performGetAvilability() {
        LoaderController.sharedInstance.showLoader(view: self.view)
        let slotFrom = fromSlotTime.text ?? ""
        let slotToTime = toSlotTime.text ?? ""
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        self.avilabilityData.append(NewSlotAdd(slotNum: "\(slotAdd ?? 1)", from: "\(slotFrom)", to: "\(slotToTime)", clinicId: clinicIdForVisit ?? "", status: self.avilability ?? "1"))
        var slotArray1 = [[String:String]]()
        self.avilabilityData.forEach { slot in
            slotArray1.append(["slot_num":"\(slot.slotNum)","clinic_id":"\(slot.clinicId)","from":"\(slot.from)","to":"\(slot.to)", "status": "\(slot.status)"])
        }
        
        var parameter = [String: Any]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "slot_id": addAvilabilityId ?? "",
                     "slots": slotArray1]
        getAvilabilityList(param: parameter)
    }
}

extension AddVisitAvilabilityVC {
    func addQualification(param: [String: String]) {
        firstly {
            service!.clinicList(parameters: param, header: "DeviceToken")
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
        let token = UserDefaults.standard.string(forKey: Constants.accessToken)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": "\(token ?? "")"]
        addQualification(param: parameter)
    }
    
    func handleResponse(model: ClinicListModel){
        
        if model.status == "SUCCESS"{
            self.clinicListArray = model.cliniclisting ?? [Cliniclisting]()
            for person in model.cliniclisting! {
                array.append(person.clinicName ?? "")
                clinicId.append(person.clinicId ?? "")
            }
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension AddVisitAvilabilityVC {
    func getUpdateList(param:[String:Any]?) {
       
        ApiManager.instance.fetchApiService(method: .post, url: APIEndpoint.updateBooking, passDict: param, header: ApiManager.instance.getHeadeWithJwtToken())  { (result) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
            switch result {
            case .success(let data):
                let modelData = try? JSONDecoder().decode(UpdateAvilabilityModel.self, from: data)
                print(modelData!)
                self.callBack?()
                LoaderController.sharedInstance.removeLoader()
              break
            case .failure(let error):
                print("error.........\(error.localizedDescription)")
                LoaderController.sharedInstance.removeLoader()
               break
            }
        }
    }
    
    func performUpdateAvilability(){
        LoaderController.sharedInstance.showLoader(view: self.view)
        let slotFrom = fromSlotTime.text ?? ""
        let slotToTime = toSlotTime.text ?? ""
        for i in 0..<(slotsArray.first?.slots?.count ?? 0) {
            if clinicEdit == true {
                if slotsArray.first?.slots?[i].slotNum == slotNo {
                    self.updateData.append(NewSlotAdd(slotNum: slotNo ?? "", from: "\(slotFrom)", to: "\(slotToTime)", clinicId: clinicIdForVisit ?? "", status: self.avilability ?? ""))
                } else {
                    self.updateData.append(NewSlotAdd(slotNum: slotsArray.first?.slots?[i].slotNum ?? "1", from: slotsArray.first?.slots?[i].from ?? "", to: slotsArray.first?.slots?[i].to ?? "", clinicId: slotsArray.first?.slots?[i].clinicId ?? "", status: slotsArray.first?.slots?[i].status ?? ""))
                }
            } else {
                if slotsArray.first?.slots?[i].slotNum == slotNo {
                    self.updateData.append(NewSlotAdd(slotNum: slotNo ?? "", from: "\(slotFrom)", to: "\(slotToTime)", clinicId: clinic_ID ?? "", status: self.avilability ?? ""))
                } else {
                    self.updateData.append(NewSlotAdd(slotNum: slotsArray.first?.slots?[i].slotNum ?? "1", from: slotsArray.first?.slots?[i].from ?? "", to: slotsArray.first?.slots?[i].to ?? "", clinicId: slotsArray.first?.slots?[i].clinicId ?? "", status: slotsArray.first?.slots?[i].status ?? ""))
                }
            }
        }
        var slotArray1 = [[String:String]]()
        
        self.updateData.forEach { slot in
            slotArray1.append(["slot_num":"\(slot.slotNum)","clinic_id":"\(slot.clinicId)","from":"\(slot.from)","to":"\(slot.to)", "status": "\(slot.status)"])
        }
        
        var parameter = [String: Any]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "slot_id": addAvilabilityId ?? "",
                     "slots": slotArray1]
        getUpdateList(param: parameter)
    }
}
