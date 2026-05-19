//
//  ChangePasswordVC.swift
//  DoctorLive
//
//  Created by cst on 08/10/21.
//

import UIKit
import PromiseKit

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var shwoNewPassword: UIButton!
    @IBOutlet weak var newPasswordTxt: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var showConfirmPaswprd: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var chnagePassTxt: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.placeholder = "Password".localized()
        newPasswordTxt.placeholder = "New Password".localized()
        confirmPassword.placeholder = "Confirm Password".localized()
        submitButton.setTitle("Submit".localized(), for: .normal)
        chnagePassTxt.setTitle("Change Password".localized(), for: .normal)
        passwordView.dropShadow(scale: true)
        newPasswordView.dropShadow(scale: true)
        confirmPasswordView.dropShadow(scale: true)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func showPassTapped(_ sender: Any) {
        showPassword.isSelected = !showPassword.isSelected
        if showPassword.isSelected{
            self.passwordTxt.isSecureTextEntry = false
        }else{
            self.passwordTxt.isSecureTextEntry = true
        }
    }
    
    @IBAction func confirmPassword(_ sender: Any) {
        shwoNewPassword.isSelected = !shwoNewPassword.isSelected
        if shwoNewPassword.isSelected {
            self.newPasswordTxt.isSecureTextEntry = false
        } else {
            self.newPasswordTxt.isSecureTextEntry = true
        }
    }
    
   
    
    @IBAction func CinfimPasswordShow(_ sender: Any) {
        showConfirmPaswprd.isSelected = !showConfirmPaswprd.isSelected
        if showConfirmPaswprd.isSelected{
            self.confirmPassword.isSecureTextEntry = false
        }else{
            self.confirmPassword.isSecureTextEntry = true
        }
    }
    @IBAction func changePasswordTapped(_ sender: Any) {
        validations()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
extension ChangePasswordVC {
    func performResetPass(param: [String: String]) {
        firstly {
            service!.changePassword(parameters: param, header: "DeviceToken")
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
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return}
        var parameter = [String: String]()
        if self.passwordTxt.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter your Old password".localized())
        } else if self.newPasswordTxt.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter New Password".localized())
        } else if !Utils.shared.isValidPassword(passString: self.newPasswordTxt.text ?? "") {
            AppToast.showMessage(message: "Please Enter Valid Password".localized())
        } else if self.confirmPassword.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please confirm Your Password".localized())
        } else if !Utils.shared.isValidPassword(passString: confirmPassword.text ?? "") {
            AppToast.showMessage(message: "Please Enter Valid Password".localized())
        } else if self.newPasswordTxt.text != self.confirmPassword.text {
            AppToast.showMessage(message: "Your password not match".localized())
        } else {
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            parameter = ["language_type": code,
                         "token": token,
                         "old_pass": passwordTxt.text ?? "",
                         "new_pass": newPasswordTxt.text ?? "",
                         "confirm_pass": confirmPassword.text ?? ""]
            performResetPass(param: parameter)
        }
    }
    func handleResponse(model: ForgetPassword){
        if model.status == "SUCCESS" {
            let view = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = view.instantiateViewController(withIdentifier: "SelectLanguageVC") as! SelectLanguageVC
            vc.passChange = true
            resetDefaults()
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            AppToast.showMessage1(message: model.message ?? "", self)
        }
    }
}
