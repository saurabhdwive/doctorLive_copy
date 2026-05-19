//
//  SetAvilabilityOnCallVC.swift
//  DoctorLive
//
//  Created by call soft on 19/09/21.
//

import UIKit
import RSSelectionMenu
import PromiseKit


protocol PerformUpdateAvilability {
    func updateAvilability()
}

class SetAvilabilityOnCallVC: UIViewController {
    
    @IBOutlet weak var fromTime1: UITextField!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var toTime1: UITextField!
    @IBOutlet weak var fromAmLable: UITextField!
    @IBOutlet weak var toAmLable: UITextField!
    @IBOutlet weak var fromTime2: UITextField!
    @IBOutlet weak var toTime2: UITextField!
    @IBOutlet weak var slot1Txt: UILabel!
    @IBOutlet weak var slot2Txt: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var fromLbl2: UILabel!
    @IBOutlet weak var toLbl2: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var avilableLbl: UILabel!
    @IBOutlet weak var fromAmLable1: UITextField!
    @IBOutlet weak var toAmLable2: UITextField!
    @IBOutlet weak var dropButton1: UIButton!
    @IBOutlet weak var dropButton2: UIButton!
    @IBOutlet weak var dropButton3: UIButton!
    @IBOutlet weak var dropButton4: UIButton!
    @IBOutlet weak var dropButton5: UIButton!
    @IBOutlet weak var dropButton6: UIButton!
    @IBOutlet weak var dropButton7: UIButton!
    @IBOutlet weak var dropButton8: UIButton!
    @IBOutlet weak var button1View: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var notificationCountTxt: UILabel!
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var slot1TimeFrom = String()
    var slot2TimeFrom = String()
    var slot1TimeTo = String()
    var slot2TimeTo = String()
    var visitEdit: Bool?
    var callDictSlot1 = [String: String]()
    var callDictSlot2 = [String: String]()
    var slotId: String?
    var dayName = String()
    var avilabilityId: String?
    var avilabilityId1: String?
    var avilability: String? = "1"
    var slotCount: Int?
    var fromTextOne: String = ""
    var toTextOne: String = ""
    var fromTextOne1: String = ""
    var toTextOne1: String = ""
    var avilabilityData = [NewSlotAdd]()
    
    var updateAddAvilabilty = [NewSlotAdd]()
    
    var updateAvilabilityData = [Slot1]()
    var delegate: PerformUpdateAvilability? = nil
    var timeArray = ["","1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00", "11:00", "12:00"]
    var amPmArray = ["","am".localized(), "pm".localized()]
    var slot1SelectedIndex: Int?
    var slot2SelectedIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        notificationCountTxt.text = String(count)
        saveButton.layer.cornerRadius = 10
        fromLbl.text = "From".localized()
        toLbl.text = "To".localized()
        fromLbl2.text = "From".localized()
        toLbl2.text = "To".localized()
        avilableLbl.text = "Available".localized()
       
        slot1Txt.text = "Slot 1".localized()
        saveButton.setTitle("Save".localized(), for: .normal)
        slot2Txt.text = "Slot 2".localized()
        if slotCount != 0 {
            self.fromTime1.text = callDictSlot1["slot1From"] ?? ""
            self.fromTime2.text = callDictSlot2["slot2From"] ?? ""
            self.toTime1.text = callDictSlot1["slot1To"] ?? ""
            self.toTime2.text = callDictSlot2["slot2To"] ?? ""
            fromAmLable.text = callDictSlot1["slot1FromAm"] ?? ""
            toAmLable.text = callDictSlot1["slot1ToAm"] ?? ""
            fromAmLable1.text = callDictSlot2["slot2FromAm"] ?? ""
            toAmLable2.text = callDictSlot2["slot2ToAm"] ?? ""
        }
        if dayName == "Mon" {
            titleTxt.text = "Monday".localized()
        } else if dayName == "Tue" {
            titleTxt.text = "Tuesday".localized()
        } else if dayName == "Wed" {
            titleTxt.text = "Wednesday".localized()
        } else if dayName == "Thu" {
            titleTxt.text = "Thursday".localized()
        } else if dayName == "Fri" {
            titleTxt.text = "Friday".localized()
        } else if dayName == "Sat" {
            titleTxt.text = "Saturday".localized()
        } else if dayName == "Sun" {
            titleTxt.text = "Sunday".localized()
      }
    }
    func setUpView() {
        EditingTextField()
    }
    
    func EditingTextField() {
        [dropButton1, dropButton2,dropButton3,dropButton4,dropButton5,dropButton6,dropButton7,dropButton8].forEach({ text in
            text?.layer.borderWidth = 1
            text?.layer.cornerRadius = 8
            text?.layer.borderColor = UIColor.gray.cgColor
        })
    }
    
    @IBAction func dropButton1Tapped(_ sender: Any) {
        let data: [String] = timeArray
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
            
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { [self] (name, index, selected, selectedItems) in
            self.slot1SelectedIndex = index + 1
            
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.fromTime1.text = name
           
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: view.frame.height - 200), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func dropButton2Tapped(_ sender: Any) {
        let data: [String] = amPmArray
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.fromAmLable.text = name
            self.dismiss(animated: true, completion: nil)
            
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: 160), arrowDirection: .up, hideNavBar: true), from: self)
    }
    
    @IBAction func dropButton3Tapped(_ sender: Any) {
        
       // let arraySlice = timeArray.suffix(from: slot1SelectedIndex ?? 0)
        let arraySlice = timeArray
        let data: [String] = Array(arraySlice)
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { [self] (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.toTime1.text = name
          
           
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: view.frame.height - 200), arrowDirection: .up, hideNavBar: true), from: self)
    }
    
    @IBAction func dropButton4Tapped(_ sender: Any) {
        let data: [String] = amPmArray
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            
            self.toAmLable.text = name
            self.dismiss(animated: true, completion: nil)
            
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: 160), arrowDirection: .up, hideNavBar: true), from: self)
    }
    
    @IBAction func dropButton5Tapped(_ sender: Any) {
        let data: [String] = timeArray
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.slot2SelectedIndex = index + 1
            selectedNames = selectedItems
            self.fromTime2.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: view.frame.height - 200), arrowDirection: .up, hideNavBar: true), from: self)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //MARK:- To time 1
        self.toTextOne = self.toTime1.text!
        switch self.toTextOne{
        case "":
            toTextOne = "0"
        case "1:00":
            toTextOne = "1"
        case "2:00":
            toTextOne = "2"
        case "3:00":
            toTextOne = "3"
        case "4:00":
            toTextOne = "4"
        case "5:00":
            toTextOne = "5"
        case "6:00":
            toTextOne = "6"
        case "7:00":
            toTextOne = "7"
        case "8:00":
            toTextOne = "8"
        case "9:00":
            toTextOne = "9"
        case "10:00":
            toTextOne = "10"
        case "11:00":
            toTextOne = "11"
        default:
            toTextOne = "12"
        }
        
        //MARK:- From time 2
        self.fromTextOne = self.fromTime1.text!
        switch self.fromTextOne{
        case "":
            fromTextOne = "0"
        case "1:00":
            fromTextOne = "1"
        case "2:00":
            fromTextOne = "2"
        case "3:00":
            fromTextOne = "3"
        case "4:00":
            fromTextOne = "4"
        case "5:00":
            fromTextOne = "5"
        case "6:00":
            fromTextOne = "6"
        case "7:00":
            fromTextOne = "7"
        case "8:00":
            fromTextOne = "8"
        case "9:00":
            fromTextOne = "9"
        case "10:00":
            fromTextOne = "10"
        case "11:00":
            fromTextOne = "11"
        default:
            fromTextOne = "12"
        }
        //MARK:- To time 2
        self.toTextOne1 = self.toTime2.text!
        switch self.toTextOne1{
        case "":
            toTextOne1 = "0"
        case "1:00":
            toTextOne1 = "1"
        case "2:00":
            toTextOne1 = "2"
        case "3:00":
            toTextOne1 = "3"
        case "4:00":
            toTextOne1 = "4"
        case "5:00":
            toTextOne1 = "5"
        case "6:00":
            toTextOne1 = "6"
        case "7:00":
            toTextOne1 = "7"
        case "8:00":
            toTextOne1 = "8"
        case "9:00":
            toTextOne1 = "9"
        case "10:00":
            toTextOne1 = "10"
        case "11:00":
            toTextOne1 = "11"
        default:
            toTextOne1 = "12"
        }
        //MARK:- From time 2
        self.fromTextOne1 = self.fromTime2.text!
        switch self.fromTextOne1{
        case "":
            fromTextOne1 = "0"
        case "1:00":
            fromTextOne1 = "1"
        case "2:00":
            fromTextOne1 = "2"
        case "3:00":
            fromTextOne1 = "3"
        case "4:00":
            fromTextOne1 = "4"
        case "5:00":
            fromTextOne1 = "5"
        case "6:00":
            fromTextOne1 = "6"
        case "7:00":
            fromTextOne1 = "7"
        case "8:00":
            fromTextOne1 = "8"
        case "9:00":
            fromTextOne1 = "9"
        case "10:00":
            fromTextOne1 = "10"
        case "11:00":
            fromTextOne1 = "11"
        default:
            fromTextOne1 = "12"
        }
        
        if slotCount != nil || slotCount != 0 {
            if switchButton.isOn {
            if self.fromTime1.text?.isEmpty ?? false {
                AppToast.showMessage1(message: "Please Select Time", self)
            } else if fromAmLable.text?.isEmpty ?? false {
                AppToast.showMessage1(message: "Please Select Am/Pm", self)
            } else if self.toTime1.text?.isEmpty ?? false {
                AppToast.showMessage1(message: "Please Select Time", self)
            } else if toAmLable.text?.isEmpty ?? false {
                AppToast.showMessage1(message: "Please Select Am/Pm", self)
            } else if fromAmLable.text == amPmArray[1] && toAmLable.text == amPmArray[1] {
                    if(Int(fromTextOne) ?? 0 < Int(toTextOne) ?? 1) {
                        //MARK:- for second slot validation
                        
                        if (fromTime2.text == ""){
                        self.performUpdateAvilability()
                        }else{
                            if fromAmLable.text == amPmArray[1] && toAmLable.text == amPmArray[1] {
                                    if(Int(fromTextOne1) ?? 0 < Int(toTextOne1) ?? 1) {
                                        self.performUpdateAvilability()
                                    } else {
                                        AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                    }
                                }else if fromAmLable.text == amPmArray[0] && toAmLable.text == amPmArray[0] {
                                    if Int(fromTextOne1) ?? 1 > Int(toTextOne1) ?? 0{
                                        AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                    }else{
                                       self.performUpdateAvilability()
                                    }
                                } else if toAmLable.text == amPmArray[0] && fromAmLable.text == amPmArray[1] {
                                    AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                }else {
                                    self.performUpdateAvilability()
                                }
                        }
                    } else {
                        AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                    }
                }else if fromAmLable.text == amPmArray[0] && toAmLable.text == amPmArray[0] {
                    if Int(fromTextOne) ?? 1 > Int(toTextOne) ?? 0{
                        AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                    }else{
                        
                        //MARK:- for second slot validation
                        
                        if (fromTime2.text == ""){
                        self.performUpdateAvilability()
                        }else{
                            if fromAmLable.text == amPmArray[1] && toAmLable.text == amPmArray[1] {
                                    if(Int(fromTextOne) ?? 0 < Int(toTextOne) ?? 1) {
                                        self.performUpdateAvilability()
                                    } else {
                                        AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                    }
                                }else if fromAmLable.text == amPmArray[0] && toAmLable.text == amPmArray[0] {
                                    if Int(fromTextOne) ?? 1 > Int(toTextOne) ?? 0{
                                        AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                    }else{
                                       self.performUpdateAvilability()
                                    }
                                } else if toAmLable.text == amPmArray[0] && fromAmLable.text == amPmArray[1] {
                                    AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                }else {
                                    self.performUpdateAvilability()
                                }
                        }
                    }
                } else if toAmLable.text == amPmArray[0] && fromAmLable.text == amPmArray[1] {
                    AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                }else {
                    //MARK:- for second slot validation
                    
                    if (fromTime2.text == ""){
                    self.performUpdateAvilability()
                    }else{
                        if fromAmLable.text == amPmArray[1] && toAmLable.text == amPmArray[1] {
                                if(Int(fromTextOne) ?? 0 < Int(toTextOne) ?? 1) {
                                    self.performUpdateAvilability()
                                } else {
                                    AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                }
                            }else if fromAmLable.text == amPmArray[0] && toAmLable.text == amPmArray[0] {
                                if Int(fromTextOne) ?? 1 > Int(toTextOne) ?? 0{
                                    AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                                }else{
                                   self.performUpdateAvilability()
                                }
                            } else if toAmLable.text == amPmArray[0] && fromAmLable.text == amPmArray[1] {
                                AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                            }else {
                                self.performUpdateAvilability()
                            }
                    }
                }
                
            } else {
                self.performUpdateAvilability()
            }
        } else {
            if switchButton.isOn {
                if self.fromTime1.text?.isEmpty ?? false {
                    AppToast.showMessage1(message: "Please Select Time".localized(), self)
                } else if fromAmLable.text?.isEmpty ?? false {
                    AppToast.showMessage1(message: "Please Select Am/Pm".localized(), self)
                } else if self.toTime1.text?.isEmpty ?? false {
                    AppToast.showMessage1(message: "Please Select Time".localized(), self)
                } else if toAmLable.text?.isEmpty ?? false {
                    AppToast.showMessage1(message: "Please Select Am/Pm".localized(), self)
//                }else if self.fromTime2.text?.isEmpty ?? false {
//                    AppToast.showMessage1(message: "Please Select Time".localized(), self)
//                } else if fromAmLable1.text?.isEmpty ?? false {
//                    AppToast.showMessage1(message: "Please Select Am/Pm".localized(), self)
//               } else if self.toTime2.text?.isEmpty ?? false {
//                AppToast.showMessage1(message: "Please Select Time".localized(), self)
//                } else if toAmLable2.text?.isEmpty ?? false {
//                    AppToast.showMessage1(message: "Please Select Am/Pm".localized(), self)
                }else if fromAmLable.text == amPmArray[1] && toAmLable.text == amPmArray[1] {
                        if(Int(fromTextOne) ?? 0 < Int(toTextOne) ?? 1) {
                            self.performGetAvilability()
                        } else {
                            AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                        }
                    }else if fromAmLable.text == amPmArray[0] && toAmLable.text == amPmArray[0] {
                        if Int(fromTextOne) ?? 1 > Int(toTextOne) ?? 0{
                            AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                        }else{
                           self.performGetAvilability()
                        }
                    } else if toAmLable.text == amPmArray[0] && fromAmLable.text == amPmArray[1] {
                        AppToast.showMessage1(message: "Please Select Proper Time".localized(), self)
                    }else {
                        self.performGetAvilability()
                    }
                } else {
                self.performGetAvilability()
            }
         }
      }
    
    @IBAction func dropButton6Tapped(_ sender: Any) {
        let arraySlice = timeArray
        let data: [String] = Array(arraySlice)
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.toTime2.text = name
            self.dismiss(animated: true, completion: nil)
            
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: view.frame.height - 200), arrowDirection: .up, hideNavBar: true), from: self)
    }
    
    @IBAction func dropButton7Tapped(_ sender: Any) {
        let data: [String] = amPmArray
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.fromAmLable1.text = name
            self.dismiss(animated: true, completion: nil)
            
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: 160), arrowDirection: .up, hideNavBar: true), from: self)
    }
    
    @IBAction func dropButton8Tapped(_ sender: Any) {
        let data: [String] = amPmArray
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .tickmark
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.toAmLable2.text = name
            self.dismiss(animated: true, completion: nil)
            
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: button1View.frame.width, height: 160), arrowDirection: .up, hideNavBar: true), from: self)
    }
    
    @IBAction func switchButtonTapped(_ sender: UISwitch) {
        if (sender.isOn) {
            enableButton()
            self.avilability = "1"
        } else {
            disableButton()
            self.avilability = "0"
            clearTxt()
        }
    }
    
    @IBAction func notification(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    func disableButton(){
        [dropButton1, dropButton2,dropButton3,dropButton4,dropButton5,dropButton6,dropButton7,dropButton8].forEach({ text in
            text?.isEnabled = false
            
        })
    }
    
    func clearTxt() {
        [fromTime1, fromTime2,toTime1,toTime2,fromAmLable,toAmLable,fromAmLable1,toAmLable2].forEach({ text in
            text?.text = ""
            
        })
    }
    
    func enableButton(){
        [dropButton1, dropButton2,dropButton3,dropButton4,dropButton5,dropButton6,dropButton7,dropButton8].forEach({ text in
            text?.isEnabled = true
        })
    }
}

extension SetAvilabilityOnCallVC {
    func getAvilabilityList(param:[String:Any]?){
       
        ApiManager.instance.fetchApiService(method: .post, url: APIEndpoint.createBooking, passDict: param, header: ApiManager.instance.getHeadeWithJwtToken())  { (result) in
            DispatchQueue.main.async {
               
            }
            switch result{
            case .success(let data):
                let modelData = try? JSONDecoder().decode(AvililabilityListModel.self, from: data)
                print(modelData!)
                self.delegate?.updateAvilability()
                self.navigationController?.popViewController(animated: true)

                break
            case .failure(let error):
                print("error.........\(error.localizedDescription)")
               
                break
            }
        }
    }
    
    func performGetAvilability() {
        let slot1From = fromTime1.text ?? ""
        let fromAm = fromAmLable.text ?? ""
        let toAm = toAmLable.text ?? ""
        let slot2From = fromTime2.text ?? ""
        let slot1To = toTime1.text ?? ""
        let slot2To = toTime2.text ?? ""
        let fromAm1 = fromAmLable1.text ?? ""
        let toAmLable1 = toAmLable2.text ?? ""
        let id = UserDefaults.standard.string(forKey: Constants.userId)
      
       // self.avilabilityData.append(NewSlotAdd(slotNum: "1", from: "\(slot1From)\(fromAm)", to: "\(slot1To)\(toAm)", clinicId: ""))
       
        //self.avilabilityData.append(NewSlotAdd(slotNum: "2", from: "\(slot2From)\(fromAm1)", to: "\(slot2To)\(toAmLable1)", clinicId: ""))
        var slotArray = [[String:Any]]()
//        self.avilabilityData.forEach { slot in
//            slotArray.append(["slot":"\(slot.slotNum)","clinic_name":"\(slot.clinicName)","slot_from":"\(slot.slotFrom)","slot_to":"\(slot.slotTo)","availability":"\(slot.availability)"])
//        }
        self.avilabilityData.forEach { slot in
            slotArray.append(["slot_num":"\(slot.slotNum)","clinic_id":"\(slot.clinicId)","from":"\(slot.from)","to":"\(slot.to)"])
        }
        var parameter = [String: Any]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "slot_id": slotId ?? "",
                     "status": avilability ?? "0" ,
                     "slots": slotArray]
        getAvilabilityList(param: parameter)
    }}


extension SetAvilabilityOnCallVC {
    func getUpdateList(param:[String:Any]?) {
        ApiManager.instance.fetchApiService(method: .post, url: APIEndpoint.updateBooking, passDict: param, header: ApiManager.instance.getHeadeWithJwtToken())  { (result) in
            DispatchQueue.main.async {
               
            }
            switch result {
            case .success(let data):
                let modelData = try? JSONDecoder().decode(UpdateAvilabilityModel.self, from: data)
                print(modelData!)
                self.delegate?.updateAvilability()
                self.navigationController?.popViewController(animated: true)
                break
            case .failure(let error):
                print("error.........\(error.localizedDescription)")
                
                break
            }
        }
    }
    
    func performUpdateAvilability() {
        let slot1From = fromTime1.text ?? ""
        let fromAm = fromAmLable.text ?? ""
        let toAm = toAmLable.text ?? ""
        let slot2From = fromTime2.text ?? ""
        let slot1To = toTime1.text ?? ""
        let slot2To = toTime2.text ?? ""
        let fromAm1 = fromAmLable1.text ?? ""
        let toAmLable1 = toAmLable2.text ?? ""
        let id = UserDefaults.standard.string(forKey: Constants.userId)
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
//        self.updateAvilabilityData.append(Slot1(id: Int(avilabilityId ?? "") ?? 0, slot: "1", clinicName: "",slotFrom: "\(slot1From)\(fromAm)", slotTo: "\(slot1To)\(toAm)", availability: self.avilability ?? "1"))
//        self.updateAvilabilityData.append(Slot1(id: Int(avilabilityId1 ?? "") ?? 0, slot: "2", clinicName: "", slotFrom: "\(slot2From)\(fromAm1)", slotTo: "\(slot2To)\(toAmLable1)", availability: self.avilability ?? "1"))
        
      //  self.updateAddAvilabilty.append(NewSlotAdd(slotNum: "1", from: "\(slot1From)\(fromAm)", to: "\(slot1To)\(toAm)", clinicId: ""))
        
       // self.updateAddAvilabilty.append(NewSlotAdd(slotNum: "2", from: "\(slot2From)\(fromAm1)", to: "\(slot2To)\(toAmLable1)", clinicId: ""))
        
        var slotArray = [[String:Any]]()
        self.updateAddAvilabilty.forEach { updatedSlot in
            slotArray.append(["slot_num": "\(updatedSlot.slotNum)","from":"\(updatedSlot.from)", "to":"\(updatedSlot.to)", "clinic_id":"\(updatedSlot.clinicId)"])
        }
        var parameter = [String: Any]()
//        parameter = ["language_type": code,
//                     "availability_id": slotId ?? "",
//                     "slots": slotArray]
        parameter = ["language_type": code,
                     "doctor_id": "\(id ?? "")",
                     "slot_id": slotId ?? "",
                     "status": avilability ?? "0" ,
                     "slots": slotArray]
        getUpdateList(param: parameter)
    }
}

extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
       str = nsString.substring(with: NSRange(location: 0, length: nsString.length > length ? length : nsString.length))}
        return  str
    }
}
