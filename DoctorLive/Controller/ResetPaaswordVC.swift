//
//  ResetPaaswordVC.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import PromiseKit

class ResetPaaswordVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var passwordView : UIView!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var ConfirmpasswordView : UIView!
    var countryCode: String?
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var confirmPass: UIButton!
    
    var mobile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.dropShadow(scale: true)
        ConfirmpasswordView.dropShadow(scale: true)
        setupUI()
    }

    @IBAction func btnResetPasswordPressed(_ sender: UIButton){
        performForgetPass()
    }
    
    @IBAction func passShowButton(_ sender: Any) {
        passButton.isSelected = !passButton.isSelected
        if passButton.isSelected{
            self.newPasswordText.isSecureTextEntry = false
        }else{
            self.newPasswordText.isSecureTextEntry = true
        }
    }
    
    @IBAction func confirmPassShowButton(_ sender: Any) {
        confirmPass.isSelected = !confirmPass.isSelected
        if confirmPass.isSelected{
            self.confirmPassword.isSecureTextEntry = false
        }else{
            self.confirmPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    fileprivate func setupUI() {
        passwordView.dropShadow(scale: true)
        ConfirmpasswordView.dropShadow(scale: true)
    }
  }

extension ResetPaaswordVC {
    func performResetPass(param: [String: String]) {
        firstly {
            service!.forgetPass(parameters: param, header: "DeviceToken")
        }.done { (model: ForgetPassword) in
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
        var parameter = [String: String]()
        let phone = "\(mobile ?? "")"
        if self.newPasswordText.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter your  password".localized())
        } else if self.confirmPassword.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please confirm Your Password".localized())
        } else if !Utils.shared.isValidPassword(passString: self.newPasswordText.text ?? "") {
            AppToast.showMessage(message: "Please Enter Valid Password".localized())
        } else if !Utils.shared.isValidPassword(passString: confirmPassword.text ?? "") {
            AppToast.showMessage(message: "Your password not match".localized())
        } else if self.newPasswordText.text != self.confirmPassword.text {
            AppToast.showMessage(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password_Not_Match", comment: ""))
        } else {
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            parameter = ["language_type": code,
                         "new_pass": newPasswordText.text ?? "",
                         "confirm_pass": confirmPassword.text ?? "",
                         "mobile": phone]
            performResetPass(param: parameter)
     }
  } 
    func handleResponse(model: ForgetPassword){
        if model.status == "SUCCESS" {
            print(model)
            let view = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = view.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)

        } else{
            AppToast.showMessage(message: model.message ?? "")
     }
   }
}

extension ResetPaaswordVC {
    func performForgetPass(param: [String: String]) {
        firstly {
            service!.forgetPasss(parameters: param, header: "DeviceToken")
        }.done { (model: ForgetPasswordModel1) in
            self.performForgetPassword(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
        }
           
        }.finally {
            DispatchQueue.main.async {
               // Loader.hide()
            }
        }
    }
    
    func performForgetPass() {
        let countrycode = self.countryCode?.chopPrefix()
        var parameter = [String: String]()
        //let phone = "\(countrycode ?? "")\(mobile ?? "")"
       
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                         "country_code": countrycode ?? "",
                         "mobile": self.mobile ?? ""]
           performForgetPass(param: parameter)
     }
    
    func performForgetPassword(model: ForgetPasswordModel1){
        if model.status == "SUCCESS" {
            print(model)
            validations()
       } else{
            AppToast.showMessage(message: model.message ?? "")
     }
   }
}
