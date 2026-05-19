//
//  WidhrawViewController.swift
//  DoctorLive
//
//  Created by cst on 10/10/21.
//

import UIKit
import PromiseKit

class WidhrawViewController: UIViewController {

    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var widhrawView: UIView!
    @IBOutlet weak var widhrawAmountTxt: UITextField!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var bankTxtField: UITextField!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var accountNumView: UIView!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteTxt: UITextField!
    @IBOutlet weak var amountTxt: UILabel!
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var amount: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountTxt.text = "৳ \(amount ?? "0")"
        self.userNameTxt.text = UserDefaults.standard.string(forKey: Constants.userName)
        self.accountNumber.text = UserDefaults.standard.string(forKey: Constants.accountNo)
        self.bankTxtField.text = UserDefaults.standard.string(forKey: Constants.bankName)
        
        noteTxt.placeholder = "Note".localized()
        withdrawButton.setTitle("Withdraw Request".localized(), for: .normal)
        titleTxt.text = "Withdraw".localized()
        balance.text = "balance".localized()
        setUpUI()
    }
    
    func setUpUI() {
        widhrawView.dropShadow(scale: true)
        bankView.dropShadow(scale: true)
        accountNumView.dropShadow(scale: true)
        noteView.dropShadow(scale: true)
        userNameView.dropShadow(scale: true)
    }
   
    @IBAction func widhrawButton(_ sender: Any) {
        performWidhrawAmount()
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WidhrawViewController {
    func myWidhraw(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.widhrawAmount(parameters: param, header: "DeviceToken")
        }.done { (model: WidhrawRequestModel) in
            self.myWidhrawResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                AppToast.showMessage1(message: "Not Enough Balance", self)
                LoaderController.sharedInstance.removeLoader()
            }
            
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    
    func performWidhrawAmount() {
        let bankId = UserDefaults.standard.string(forKey: Constants.bankId)
        if widhrawAmountTxt.text?.isEmpty == true {
            AppToast.showMessage1(message: "Please Enter Amount", self)
        } else {
            var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "bank_id": bankId ?? "",
                     "withdraw_amount": widhrawAmountTxt.text ?? ""]
         myWidhraw(param: parameter)
      }
    }
    
    func myWidhrawResponse(model: WidhrawRequestModel) {
        if model.status == "SUCCESS" {
            print(model)
            let view = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = view.instantiateViewController(withIdentifier: "MyEarningViewController") as! MyEarningViewController
            navigationController?.pushViewController(vc, animated: true)
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage1(message: model.message ?? "", self)
            LoaderController.sharedInstance.removeLoader()
        }
    }
}
