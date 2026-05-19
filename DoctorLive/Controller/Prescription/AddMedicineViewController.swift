//
//  AddMedicineViewController.swift
//  DoctorLive
//
//  Created by cst on 12/10/21.
//

import UIKit
import RSSelectionMenu
import PromiseKit
import DropDown
protocol DataDelegate {
    func userData(passData: [Medicine])
    func userEditData(passData: [Medicine])
}

class AddMedicineViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var medicineNameTxt: UITextField!
    @IBOutlet weak var frequency1: UITextField!
    @IBOutlet weak var doseTxt: UITextField!
    @IBOutlet weak var durationTxt: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mealTxt: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var mealView: UIView!
    @IBOutlet weak var mealLbl: UILabel!
    @IBOutlet weak var addMedicineLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var dosage: UILabel!
    @IBOutlet weak var frequencyLbl: UILabel!
    
    var medicineEdit: Bool?
    var medicineName = String()
    var autocompleteUrls = [String]()
    var navController: UINavigationController?
    var delegate: DataDelegate?
    var controller = UIViewController()
    var dropDown = DropDown()
    var editMedicne = [String: String]()
    var editMed: Bool?
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    var investigationState: Bool = false
    var followUpState: Bool = false
    var genralExamState: Bool = false
    var workItem: DispatchWorkItem?
    
    var medicineId: String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
       
        self.navigationController?.navigationBar.isHidden = true
        mainView.layer.cornerRadius = 25
        addButton.layer.cornerRadius = 10
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        backView.addGestureRecognizer(tapGesture)
        doseTxt.text = editMedicne["dosage"]
        frequency1.text = editMedicne["frequency_first"]
        durationTxt.text = editMedicne["duration"]
        mealTxt.text = editMedicne["meals"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        medicineNameTxt.placeholder = "Medicine Name".localized()
        addMedicineLbl.text = "Add Medicine".localized()
        dosage.text = "Dosage".localized()
        frequencyLbl.text = "Frequency".localized()
        durationLbl.text = "Duration".localized()
        mealLbl.text = "Instruction".localized()
        doseTxt.placeholder = "Select Dosage".localized()
        durationTxt.placeholder = "Month".localized()
        mealTxt.placeholder = "Instruction".localized()
        
        if medicineEdit == true {
            medicineNameTxt.text = editMedicne["name"]
        } else {
            self.medicineNameTxt.text = medicineName
        }
        //self.medicineNameTxt.text = medicineName
        
    }
    
    @IBAction func addMedicneTapped(_ sender: Any) {
        let vc = MedicineSearchVC()
        self.medicineEdit = false
        vc.medicinecallback = { (name , id) in
//            text in self.medicineName = text!
            self.medicineName = name ?? ""
            self.medicineId = id ?? ""
            print("yee\(self.medicineName)")
        }
        vc.delegate = delegate
       // self.present(vc, animated: true, completion: nil)
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    @IBAction func addMoreTapped(_ sender: Any) {
        if self.medicineNameTxt.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Add Medicine Name".localized(), self)
        } else if self.doseTxt.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Select doses".localized(), self)
        } else if self.frequency1.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Add Frequency".localized(), self)
        } else if self.durationTxt.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Add Duration".localized(), self)
        } else if self.mealTxt.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Add Meals".localized(), self)
        } else {
            guard let name = medicineNameTxt.text else { return }
            guard let dose = doseTxt.text else { return }
            guard let freq1 = frequency1.text else { return }
            guard let duration = durationTxt.text else { return }
            guard let meal = mealTxt.text else { return }
            if editMed == true {
              //  let comeFromMedice = true
                self.delegate?.userEditData(passData: [Medicine(id: self.medicineId ?? "", name: name, dosage: dose, frequencyFirst: freq1, duration: duration, meals: meal, toggleBtnState: true, genralExamState: self.genralExamState, followUpState: self.followUpState, investigationState: self.investigationState, comeFromMedicne: true)])
                self.dismiss(animated: true, completion: nil)
            }
            //let comeFromMedice = true
            self.delegate?.userData(passData: [Medicine(id: self.medicineId ?? "", name: name, dosage: dose, frequencyFirst: freq1, duration: duration, meals: meal, toggleBtnState: true, genralExamState: self.genralExamState, followUpState: self.followUpState, investigationState: self.investigationState, comeFromMedicne: true)])
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        if let navController = self.navController{
            navController.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    @IBAction func mealTapped(_ sender: Any) {
//        let data: [String] = ["N/A", "Before Meal", "After Meal"]
//        var selectedNames: [String] = []
//        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
//            cell.textLabel?.text = name
//        }
//        menu.cellSelectionStyle = .checkbox
//        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
//            selectedNames = selectedItems
//            //let items = selectedNames.joined(separator:", ")
//            self.mealTxt.text = name
//            self.dismiss(animated: true, completion: nil)
//        }
//        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: mealView.frame.width, height: 300), arrowDirection: .down, hideNavBar: true), from: self)
//    }
    
    
    
    @IBAction func frequencyTapped(_ sender: Any) {
        let data: [String] = ["Required", "Immediately", "Once a day", "Twice daily", "Thrice daily", "Four times a day", "Every hour", "Every night a bedtime", "Every day", "Every other day", "Every Four hours", "Once a week", "Three times a week"]
        
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: data) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        menu.cellSelectionStyle = .checkbox
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            //let items = selectedNames.joined(separator:", ")
            self.frequency1.text = name
            self.dismiss(animated: true, completion: nil)
        }
        menu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: mealView.frame.width, height: view.frame.height - 200), arrowDirection: .any, hideNavBar: true), from: self)
    }
}
