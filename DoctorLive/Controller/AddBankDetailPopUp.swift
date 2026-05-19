//
//  AddBankDetailPopUp.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import PromiseKit
import DropDown

protocol updateBankDelegateProtocol {
    func updateBankDelegate()
}

class AddBankDetailPopUp: UIViewController, AnimationProviding {
    
    //MARK:- Variable
    var addBankDetailCallBack: (() -> ())?
    var controller = UIViewController()
    //MARK:- Outlets
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnAddQualification : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var bankNameText : UITextField!
    @IBOutlet weak var branchNameText : UITextField!
    @IBOutlet weak var accountNameText : UITextField!
    @IBOutlet weak var accountNumberText : UITextField!
    var bankDict1 = [String: String]()
    var bankListArray:[String] = Array()
    var bankDetailsCallback: ((String) -> ())?
   
    var updateBank: Bool?
    var bankId: String?
    var delegate: updateBankDelegateProtocol? = nil
    var navController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 25
        performBankList()
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        popView.addGestureRecognizer(tapGesture)
        bankNameText.text = bankDict1["bankName"]
        branchNameText.text = bankDict1["branchName"]
        accountNameText.text = bankDict1["accountName"]
        accountNumberText.text = bankDict1["accountNumber"]
        lblHeading.text = "Add Bank Detail".localized()
        bankNameText.placeholder = "Select Bank Name".localized()
        branchNameText.placeholder = "Branch Name".localized()
        accountNumberText.placeholder = "Account Number".localized()
        accountNameText.placeholder = "Account Name".localized()
        btnAddQualification.setTitle("Add Bank".localized(), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK:- IBAction
    @IBAction func btnAddQualificationPressed(_ sender: UIButton){
        if updateBank == true {
            performUpdateBankDetails()
        } else {
            validations()
        }
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        if let navController = self.navController{
            navController.dismiss(animated: true, completion: nil)
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func selectBankButton(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = bankListArray
        dropDown.anchorView = sender as? AnchorView
        dropDown.direction = .bottom
        //dropDown.backgroundColor = .white
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
        //self.dropDownButton.isHidden = true
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            // (sender as AnyObject).setTitle(item, for: .normal)
            self?.bankNameText.text = item
        }
    }
   
}

extension AddBankDetailPopUp {
    func addBankDetails(param: [String: String]) {
        firstly {
            service!.bankDetails(parameters: param, header: "DeviceToken")
        }.done { (model: AddBank) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func validations() {
        if self.bankNameText.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please select your bank".localized(), self)
        } else if self.branchNameText.text == nil  {
            AppToast.showMessage1(message: "Please Fill your branch Name".localized(), self)
        } else if self.accountNameText.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your Name on Account".localized(), self)
        } else if self.accountNumberText.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Fill your Account Number".localized(), self)
        } else {
            let id = UserDefaults.standard.string(forKey: Constants.userId)
            var parameter = [String: String]()
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            parameter = ["language_type": code,
                         "id": "\(id ?? "")",
                         "bank_name": "\(bankNameText.text ?? "")",
                         "branch_name": "\(branchNameText.text ?? "")",
                         "ac_holder_name": "\(accountNameText.text ?? "")",
                         "account_no": "\(accountNumberText.text ?? "")"]
            addBankDetails(param: parameter)
        }
    }
    func handleResponse(model: AddBank){
        if model.status == "SUCCESS"{
            print(model)
            bankDetailsCallback?(bankNameText.text ?? "")
           
        }else{
            
        }
    }
}

extension AddBankDetailPopUp {
    func banklist(param: [String: String]){
        firstly {
            service!.bankList(parameters: param, header: "DeviceToken")
        }.done { (model: BankListModel) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performBankList() {
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code]
        banklist(param: parameter)
    }
    
    func handleResponse(model: BankListModel){
        if model.status == "SUCCESS"{
            for person in model.banklist! {
                bankListArray.append(person.name ?? "")
            }
        }else{
            // AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension AddBankDetailPopUp {
    func updateBank(param: [String: String]){
        firstly {
            service!.updateBank(parameters: param, header: "DeviceToken")
        }.done { (model: UpdateQualificationModel) in
            self.updateBankd(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performUpdateBankDetails() {
        let token = UserDefaults.standard.string(forKey: Constants.accessToken)
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": "\(token ?? "")",
                     "id": "\(bankId ?? "")",
                     "bank_name": "\(bankNameText.text ?? "")",
                     "branch_name": "\(branchNameText.text ?? "")",
                     "ac_holder_name": "\(accountNameText.text ?? "")",
                     "account_no": "\(accountNumberText.text ?? "")"]
        updateBank(param: parameter)
    }
    
    func updateBankd(model: UpdateQualificationModel){
        if model.status == "SUCCESS" {
            print(model)
            self.delegate?.updateBankDelegate()
            
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
