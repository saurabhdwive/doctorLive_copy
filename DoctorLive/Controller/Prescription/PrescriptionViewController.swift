//
//  PrescriptionViewController.swift
//  DoctorLive
//
//  Created by cst on 11/10/21.
//

import UIKit
import RSSelectionMenu
import PromiseKit
import SideMenu
import SwiftyJSON

protocol VideoCallFlowDelagate {
    func prescriptionBackFunc(_ returnToVideo: Bool, _ medicineState: Bool, _ investigationState: Bool, _ genralExamState: Bool, _ followUpState: Bool)
}

class PrescriptionViewController: UIViewController, DataDelegate, DeletePresecriptionDelegate {
    
    @IBOutlet weak var userName, yearOldLable, gender, dateTxt, investigationLbl, medicineLbl, titleTxt, gernralExamTitle, tempLbl, bloodPressureLbl, pluseLbl, bloodSugarLbl, followUpTitle: UILabel!
    @IBOutlet weak var ChiefTxtComplain, pastHistoryTxt, tempLable, systolicBp, diaystolicLable, pulseTxt, bloodSugar1, provisionTxt, bloodSugar2, investigationTxt, genralTxt, followUpDays: UITextField!
    @IBOutlet weak var pastHistory, genralExaminationView, userDetailView, provisonDiagnos, investigationView, genralView, followUpView, medicineView, ChiefComplainView: UIView!
    @IBOutlet weak var genralSwitchButton, medicinceTogle, investigationToggle, switchButton: UISwitch!
    @IBOutlet weak var tempButton, systolicButton, pulseButton, sugar1Button, sugar2Button, diastyolicButton, xrayButton, submItButton, addMedicineView, changePatientBtn: UIButton!
    @IBOutlet weak var medicineViewHeight, investigationViewHeight, genralViewHeight, prescriptionHeight, tableHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var investigationDropDown: UIImageView!
    @IBOutlet weak var genralExamStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedNames: [String] = []
    var comeFromMedicne = Bool()
    var index = Int()
    var videoCallflowdelegate: VideoCallFlowDelagate?
    var medicineData = [Medicine]()
    var specialtyListArray:[String] = Array()
    var bookingId: String?
    var avilability: String? = "1"
    var genral: String? = "1"
    var xRay = false
    var returnToVideo: Bool = false
    var xRayValue: String?
    var arrayData = [Medicine]()
    var data = [String: String]()
    var medicineDict = [String: String]()
    var controller = UIViewController()
    var prescriptionDataDict = [String: Any]()
    var comeFrom = String()
    var menu: SideMenuNavigationController?
    var medicineSwitch: Bool = false
    var investigationToggleState: Bool = false
    var genralSwitchButtonState: Bool = false
    var followUpState: Bool = false
    var bookingIdComeFromChat: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validations()
        setupUi()
        userName.text = data["name"]
        yearOldLable.text = data["date"]
        if data["gender"] == "f" {
            gender.text = "Female".localized()
        } else if data["gender"] == "m" {
            gender.text = "Male".localized()
        } else {
            gender.text = "Others".localized()
        }
        dateTxt.text = Date.getCurrentDate()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        investigationToggle.isOn = investigationToggleState
        medicinceTogle.isOn = medicineSwitch
        genralSwitchButton.isOn = genralSwitchButtonState
        switchButton.isOn = followUpState
        titleTxt.text = "Prescriptions".localized()
        ChiefTxtComplain.placeholder = "Chief Complain".localized()
        pastHistoryTxt.placeholder = "Past History".localized()
        provisionTxt.placeholder = "Provisional Diagnosis".localized()
        genralTxt.placeholder = "General Advice".localized()
        gernralExamTitle.text = "General Examination".localized()
        medicineLbl.text = "Medicine".localized()
        tempLbl.text = "Temperature".localized()
        bloodPressureLbl.text = "Blood Pressure".localized()
        pluseLbl.text = "Pulse".localized()
        investigationLbl.text = "Investigation".localized()
        bloodSugarLbl.text = "Blood Sugar".localized()
        submItButton.setTitle("Submit".localized(), for: .normal)
        addMedicineView.setTitle("+ Add Medicine".localized(), for: .normal)
        followUpTitle.text = "Follow Up".localized()
        if comeFromMedicne == true {
            print("hi")
        } else {
            if comeFrom == "videoCallViaChat" {
                savePrescriptionData()
            } else {
                let bookingIdFromChat = UserDefaults.standard.string(forKey: "bookingIdComeFromChat")
                if bookingIdFromChat == bookingId {
                    savePrescriptionData()
                } else {
                    print("hi")
                    pastHistoryTxt.text = ""
                    provisionTxt.text = ""
                    tempLable.text = ""
                    bloodSugar1.text = ""
                    bloodSugar2.text = ""
                    systolicBp.text = ""
                    diaystolicLable.text = ""
                    ChiefTxtComplain.text = ""
                    pulseTxt.text = ""
                    genralTxt.text = ""
                    followUpDays.text = ""
                    investigationTxt.text = ""
                    arrayData.removeAll()
                }
            }
        }
       
        
        if tempLable.text == "" {
            self.genralSwitchButton.isOn = false
        } else {
            self.genralSwitchButton.isOn = true
        }
        if investigationTxt.text == "" {
            investigationToggle?.isOn = false
        } else {
            investigationToggle?.isOn = true
        }
        if arrayData.count == 0 {
            medicinceTogle?.isOn = false
        } else {
            medicinceTogle?.isOn = true
        }
        
        if followUpDays.text == "" {
            switchButton?.isOn = false
        } else {
            switchButton?.isOn = true
        }
        
        if (genralSwitchButton?.isOn ?? true) {
            self.genral = "1"
            genralViewHeight.constant = 370
            genralExamStack.isHidden = false
            
        } else {
            self.genral = "0"
            genralViewHeight.constant = 60
            genralExamStack.isHidden = true
        }
        if(medicinceTogle?.isOn ?? true) {
            medicineViewHeight.constant = 110
            addMedicineView.isHidden = false
            
        } else {
            medicineViewHeight.constant = 60
            addMedicineView.isHidden = true
        }
        
        if (switchButton?.isOn ?? true) {
            self.avilability = "1"
            prescriptionHeight.constant = 110
            followUpDays.isHidden = false
            
        } else {
            self.avilability = "0"
            prescriptionHeight.constant = 60
            followUpDays.isHidden = true
        }
        
        if (investigationToggle?.isOn ?? true) {
            investigationViewHeight.constant = 130
            investigationTxt.isHidden = false
            investigationDropDown.isHidden = false
        } else {
            investigationViewHeight.constant = 60
            investigationTxt.isHidden = true
            investigationDropDown.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        savePrescriptionData1()
    }
    
    func savePrescriptionData() {
        let pastHistory = PrescriptionDetail.pasthistory ?? ""
        let provisionProfile = PrescriptionDetail.provisonalDiagnosis ?? ""
        let chiefComplain = PrescriptionDetail.cheifComaplain ?? ""
        let temprature = PrescriptionDetail.temprature ?? ""
        let bloodPressure1 = PrescriptionDetail.bloodPresure1 ?? ""
        let bloodPressure2 = PrescriptionDetail.bloodPresure2 ?? ""
        let puluse = PrescriptionDetail.pluse ?? ""
        let bloodsugar1 = PrescriptionDetail.bloodsugar1 ?? ""
        let bloodsugar2 = PrescriptionDetail.bloodsugar1 ?? ""
        let genralAdvice = PrescriptionDetail.genralAdvice ?? ""
        let followUpday = PrescriptionDetail.followUP ?? ""
        let investigation = PrescriptionDetail.investigationGuide ?? ""
        let genralExamTogleState = PrescriptionDetail.genralExamToggle
        let medicineRefillData = PrescriptionDetail.medicineData
        if pastHistory.isEmpty || provisionProfile.isEmpty ||  temprature.isEmpty || bloodPressure1.isEmpty || bloodPressure2.isEmpty || puluse.isEmpty || bloodsugar1.isEmpty || bloodsugar2.isEmpty || genralAdvice.isEmpty || followUpday.isEmpty || investigation.isEmpty || chiefComplain.isEmpty ==  false {
            pastHistoryTxt.text = pastHistory
            provisionTxt.text = provisionProfile
            tempLable.text = temprature
            bloodSugar1.text = bloodsugar1
            bloodSugar2.text = bloodsugar2
            systolicBp.text = bloodPressure1
            diaystolicLable.text = bloodPressure2
            pulseTxt.text = puluse
            ChiefTxtComplain.text = chiefComplain
            investigationTxt.text = investigation
            genralTxt.text = genralAdvice
            followUpDays.text = followUpday
            if let medicineDatas = medicineRefillData, !medicineDatas.isEmpty {
                arrayData = medicineDatas
                tableView.reloadData()
            }
        } else {
            pastHistoryTxt.text = ""
            provisionTxt.text = ""
            tempLable.text = ""
            bloodSugar1.text = ""
            bloodSugar2.text = ""
            systolicBp.text = ""
            diaystolicLable.text = ""
            ChiefTxtComplain.text = ""
            pulseTxt.text = ""
            genralTxt.text = ""
            followUpDays.text = ""
            self.investigationTxt.text = ""
            self.arrayData.removeAll()
            //self.genral = ""
            // arrayData.removeAll()
        }
    }
    
    func setupUi() {
        ChiefComplainView.dropShadow(scale: true)
        pastHistory.dropShadow(scale: true)
        genralExaminationView.dropShadow(scale: true)
        provisonDiagnos.dropShadow(scale: true)
        investigationView.dropShadow(scale: true)
        medicineView.dropShadow(scale: true)
        genralView.dropShadow(scale: true)
        ChiefComplainView.dropShadow(scale: true)
        ChiefComplainView.dropShadow(scale: true)
        userDetailView.dropShadow(scale: true)
        followUpView.dropShadow(scale: true)
        tempButton.isHidden = true
        systolicButton.isHidden = true
        diastyolicButton.isHidden = true
        pulseButton.isHidden = true
        sugar1Button.isHidden = true
        sugar2Button.isHidden = true
        submItButton.layer.cornerRadius = 10
        addMedicineView.layer.cornerRadius = 10
        prescriptionHeight.constant = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PrescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "PrescriptionTableViewCell")
        print("arrrray\(arrayData)")
    }
    
    func userData(passData: [Medicine]) {
        self.arrayData.append(contentsOf: passData)
        self.medicineSwitch = passData.first?.toggleBtnState ?? true
        self.followUpState = passData.first?.followUpState ?? true
        self.genralSwitchButtonState = passData.first?.genralExamState ?? true
        self.investigationToggleState = passData.first?.investigationState ?? false
        PrescriptionDetail.medicineData = arrayData
        self.comeFromMedicne = passData.first?.comeFromMedicne ?? true
        self.tableView.reloadData()
    }
    
    func userEditData(passData: [Medicine]) {
        self.arrayData.remove(at: index)
        self.tableView.reloadData()
    }
    
//    @IBAction func reasonTapped(_ sender: Any) {
//        let action = ReasonForVisitPopUp()
//        action.message = data["reason"]
//        action.modalTransitionStyle = .crossDissolve
//        action.modalPresentationStyle = .overCurrentContext
//        self.present(action, animated: true)
//    }
    
    @IBAction func changePatientBtn_Action(_ sender: Any) {
        
    }
    
    @IBAction func investigationToggleTapped(_ sender: UISwitch) {
        if (sender.isOn) {
            investigationViewHeight.constant = 130
            self.investigationToggleState = true
            investigationTxt.isHidden = false
            investigationDropDown.isHidden = false
            
        } else {
            investigationViewHeight.constant = 60
            self.investigationToggleState = false
            investigationTxt.isHidden = true
            investigationDropDown.isHidden = true
        }
    }
    
    @IBAction func medicineToggle(_ sender: UISwitch) {
        if (sender.isOn) {
            medicineViewHeight.constant = 110
            addMedicineView.isHidden = false
        } else {
            medicineViewHeight.constant = 60
            addMedicineView.isHidden = true
        }
    }

    fileprivate func savePrescriptionData1() {
        if comeFrom == "videoCallViaChat" {
            PrescriptionDetail.pasthistory = pastHistoryTxt.text ?? ""
            PrescriptionDetail.provisonalDiagnosis = provisionTxt.text ?? ""
            PrescriptionDetail.bloodPresure1 = systolicBp.text ?? ""
            PrescriptionDetail.bloodPresure2 = diaystolicLable.text ?? ""
            PrescriptionDetail.temprature = tempLable.text ?? ""
            PrescriptionDetail.pluse = pulseTxt.text ?? ""
            PrescriptionDetail.bloodsugar1 = bloodSugar1.text ?? ""
            PrescriptionDetail.bloodsugar2 = bloodSugar2.text ?? ""
            PrescriptionDetail.genralAdvice = genralTxt.text ?? ""
            PrescriptionDetail.followUP = followUpDays.text ?? ""
            PrescriptionDetail.cheifComaplain = ChiefTxtComplain.text ?? ""
            PrescriptionDetail.genralExamToggle = genralSwitchButton
            PrescriptionDetail.medicineData = arrayData
            PrescriptionDetail.investigationGuide = investigationTxt.text ?? ""
            //self.returnToVideo = true
            // self.videoCallflowdelegate?.prescriptionBackFunc(returnToVideo, self.medicineSwitch, self.investigationToggleState, self.genralSwitchButtonState, self.followUpState)
            //self.navigationController?.popViewController(animated: true)
        } else {
            // self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func menuButton(_ sender: Any) {
        savePrescriptionData1()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func noticficationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "NotificationViewController")
        show(secondVC, sender: self)
    }
    
    func buttonTapped(cell: PrescriptionTableViewCell){
        let actionSheet = UIAlertController(title: "", message: "Do you want to delete this?".localized(), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { [weak self]_ in
            guard let indexPath = self?.tableView.indexPath(for: cell) else {
                return
            }
            self?.tableView.beginUpdates()
            self?.arrayData.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .bottom)
            self?.tableView.endUpdates()
            
            print("Button tapped on row \(indexPath.row)")
        }))
        actionSheet.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: { [self]_ in
            self.tableView.reloadData()
        }))
        self.present(actionSheet, animated: true)
    }
    
    @objc func buttonEditTapped(sender: UIButton) {
        self.index = sender.tag
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        medicineDict = ["id": "\(arrayData[index].id)", "name": "\(arrayData[index].name)", "dosage": "\(arrayData[index].dosage)", "frequency_first": "\(arrayData[index].frequencyFirst)","duration":"\(arrayData[index].duration)", "meals": "\(arrayData[index].meals)"]
        let vc = view.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
        vc.editMedicne = medicineDict
        vc.editMed = true
        vc.delegate = self
        vc.medicineEdit = true
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func genralExamSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            self.genral = "1"
            genralViewHeight.constant = 370
            genralExamStack.isHidden = false
            genralSwitchButtonState = true
            
        } else {
            self.genral = "0"
            genralViewHeight.constant = 60
            genralExamStack.isHidden = true
            genralSwitchButtonState = false
        }
    }
    
    @IBAction func tepmButtonTapped(_ sender: Any) {
        let data: [String] = ["97.5 °F", "98.5 °F"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.tempLable.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: tempButton.frame.width, height: 110), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func bloodPressure(_ sender: Any) {
        let data: [String] = ["70", "80", "90", "100", "110"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.systolicBp.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: tempButton.frame.width, height: 200), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func bloodPresure2(_ sender: Any) {
        let data: [String] = ["100", "110", "120","130","140", "150", "160"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.diaystolicLable.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: tempButton.frame.width, height: 250), arrowDirection: .any, hideNavBar: true), from: self)
    }
    @IBAction func pulse(_ sender: Any) {
        let data: [String] = ["70", "80", "90", "100", "110"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.pulseTxt.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: pulseButton.frame.width, height: 230), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    
    @IBAction func bloodSugar1(_ sender: Any) {
        let data: [String] = ["70", "80", "90", "100", "110"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.bloodSugar1.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: tempButton.frame.width, height: 230), arrowDirection: .any, hideNavBar: true), from: self)
        
    }
    
    @IBAction func bloodSugar2(_ sender: Any) {
        let data: [String] = ["100", "110", "120", "130"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.bloodSugar2.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: tempButton.frame.width, height: 200), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func xrayButtonTapped(_ sender: UIButton) {
        let menu = RSSelectionMenu(selectionStyle: .multiple, dataSource: specialtyListArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.showSearchBar { [weak self] (searchText) -> ([String]) in
            
            return self?.specialtyListArray.filter({ $0.lowercased().starts(with:      searchText.lowercased()) }) ?? []
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            self.selectedNames = selectedItems
            let items = self.selectedNames.joined(separator:", ")
            //self.dismiss(animated: true, completion: nil)
            self.investigationTxt.text = items
        }
        menu.show(style: .actionSheet(title: nil, action: "Done", height: nil), from: self)
        // menu.show(style: .popover(sourceView: sender as UIView, size: CGSize(width: view.frame.width, height: view.frame.height - 200), arrowDirection: .any, hideNavBar: true), from: self)
    }
    
    @IBAction func addMedicineTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
        vc.delegate = self
        vc.controller = self
        vc.investigationState = investigationToggleState
        vc.followUpState = followUpState
        vc.genralExamState = genralSwitchButtonState
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followUpSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            self.avilability = "1"
            prescriptionHeight.constant = 110
            followUpDays.isHidden = false
            followUpState = true
        } else {
            self.avilability = "0"
            prescriptionHeight.constant = 60
            followUpDays.isHidden = true
            followUpState = false
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if self.ChiefTxtComplain.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Add Chief Complain".localized())
        } else if self.provisionTxt.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Add provisonal Diagnosis".localized())
        } else if self.genralTxt.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Add General Advice".localized())
        } else {
            let alertController = UIAlertController(title: "Alert!", message: "Are you sure you want to save this prescription?".localized(), preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "Yes".localized(), style: .default) { (action:UIAlertAction!) in
                self.performSavePrescription()
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "No".localized(), style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            return
        }
    }
}

extension Date {
    static func getCurrentDateWithTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}

struct PrescriptionDetail {
    static var pasthistory: String?
    static var cheifComaplain: String?
    static var temprature: String?
    static var bloodPresure1: String?
    static var bloodPresure2: String?
    static var pluse: String?
    static var bloodsugar1: String?
    static var bloodsugar2: String?
    static var provisonalDiagnosis: String?
    static var investigationGuide: String?
    static var genralAdvice: String?
    static var followUP: String?
    static var genralExamToggle: UISwitch?
    static var followUpToggle: Bool?
    static var medicineData: [Medicine]?
}
