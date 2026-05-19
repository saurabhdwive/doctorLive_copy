//
//  LoginVC+ApiSercice.swift
//  DoctorLive
//
//  Created by Kv on 05/09/24.
//

import Foundation
import PromiseKit
import UIKit
import FirebaseAuth

extension LoginVC {
    func languageChange(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.changeLanguage(parameters: param, header: "DeviceToken")
        }.done { (model: LanguageChangeModel) in
            self.myWidhrawResponse(model: model)
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
    
    func performLangaugeChange() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        languageChange(param: parameter)
    }
    
    func myWidhrawResponse(model: LanguageChangeModel) {
        if model.status == "SUCCESS" {
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: "Language Change Successfully")
            // LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension LoginVC {
    func verifyNumber(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.validateMobile(parameters: param, header: "DeviceToken")
        }.done { (model: LanguageChangeModel) in
            self.myVarifyNumber(model: model)
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
    
    func validatePhoneNumber() {
        if self.lblCountryCode.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Select Country Code".localized())
        } else if self.txtPhone.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter Mobile Number".localized())
        } else if !Utils.shared.isValidPhone(phone: self.txtPhone.text ?? "") {
            AppToast.showMessage(message: "Please Enter Correct Mobile Number".localized())
        }else {
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "mobile": txtPhone.text ?? ""]
        verifyNumber(param: parameter)
      }
    }
    
    func myVarifyNumber(model: LanguageChangeModel) {
        if model.status == "SUCCESS" {
            LoaderController.sharedInstance.removeLoader()
            if loginWithPassBtn.titleLabel?.text == "Login With OTP" || loginWithPassBtn.titleLabel?.text == "দিয়ে লগইন করুন" {
                loginWithPassword()
            } else if loginWithPassBtn.titleLabel?.text == "Login With Password" || loginWithPassBtn.titleLabel?.text == "পাসওয়ার্ড দিয়ে লগইন করুন"{
                performPhoneAuthentication()
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
            
        }
    }
    
    func performPhoneAuthentication() {
        guard let numbers = self.txtPhone.text else { return }
        guard let country = self.countryCodeNum else { return }
        let number = "\(country)\(numbers )"
        let defaults = UserDefaults.standard
        defaults.set(country, forKey: Constants.countryCode)
        defaults.set(numbers, forKey: Constants.mobileNo)
        defaults.synchronize()
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationId, error) in
            // HUD.hide()
            if error == nil {
                guard let verifyId = verificationId else {return}
                self.userDefault.setValue(verifyId, forKey: Constants.verificationId)
                
                self.userDefault.synchronize()
                let view = UIStoryboard.init(name: "Auth", bundle: nil)
                let vc = view.instantiateViewController(withIdentifier: "OTPPopUp") as! OTPPopUp
                vc.isLogin = true
                vc.phoneNum = self.txtPhone.text
                vc.countryCode = self.countryCodeNum
                vc.isCameFrom = "Login"
                vc.lattitude = self.currentLat
                vc.longitude = self.currentLong
                vc.modalPresentationStyle = .overFullScreen
                vc.LoginWithOtpCallBack = {
                    self.dismiss(animated: true, completion: nil)
//                    if let viewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC {
//                        self.navigationController?.isNavigationBarHidden = true
//                        self.navigationController?.pushViewController(viewController, animated: true)
//                    }
                    DIConfigurator.sharedInst().getRootViewC(.Auth, identifer: HomeVC.className)
                }
                
                vc.incompleteProfileCallBack = {
                    self.dismiss(animated: true, completion: nil)
                    let view = UIStoryboard.init(name: "Auth", bundle: nil)
                    let vc = view.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                self.present(vc, animated: true, completion: nil)
            } else {
                Utils().displayAlert(title: "", message: error?.localizedDescription ?? "", viewController: self)
                
            }
        }
    }
}

extension LoginVC {
    func performLogin(param: [String: String]) {
        firstly {
            service!.login(parameters: param, header: "DeviceToken")
        }.done { (model: LoginDataModel) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
              AppToast.showMessage(message: error.localizedDescription)
            }
        }.finally {
            DispatchQueue.main.async {
         }
        }
    }
    
    func loginWithPassword() {
        let countrycode = self.countryCodeNum?.chopPrefix()
        let deviceToken = UserDefaults.standard.string(forKey: Constants.deviceId)
        var parameter = [String: String]()
        if self.lblCountryCode.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Select Country Code".localized())
        } else if self.txtPhone.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter Mobile Number".localized())
        } else if !Utils.shared.isValidPhone(phone: self.txtPhone.text ?? "") {
            AppToast.showMessage(message: "Please Enter Correct Mobile Number".localized())
        } else if self.txtPwd.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter your password".localized())
        } else if !Utils.shared.isValidPassword(passString: txtPwd.text ?? "") {
            AppToast.showMessage(message: "Please Enter Valid Password".localized())
        } else {
            let password = txtPwd.text ?? ""
            let mobile = txtPhone.text ?? ""
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            parameter = ["language_type": code,
                         "country_code": countrycode ?? "",
                         "mobile": mobile,
                         "latitude": self.currentLat,
                         "longitude": self.currentLong,
                         "password": password,
                         "device_type": "ios",
                         "device_token": "\(deviceToken ?? "")"]
            performLogin(param: parameter)
        }
    }
    
    func handleResponse(model: LoginDataModel) {
        if model.status == "SUCCESS" {
            guard let token = model.login?.token else { return }
            let id = model.login?.id
            let name = model.login?.name
            guard let number = model.login?.mobile else { return }
            guard let countryCode = model.login?.countryCode else {return}
            guard let password = txtPwd.text else {return}
            let isLogin = true
            UserDefaults.standard.set(token, forKey: Constants.accessToken)
            UserDefaults.standard.set(id, forKey: Constants.userId)
            UserDefaults.standard.set(name, forKey: Constants.userName)
            UserDefaults.standard.set(number, forKey: Constants.mobileNo)
            UserDefaults.standard.set(password, forKey: Constants.password)
            UserDefaults.standard.set(countryCode, forKey: Constants.countryCode)
            UserDefaults.standard.set(id, forKey: Constants.userId)
            UserDefaults.standard.set(isLogin, forKey: Constants.accountStatus)
            UserDefaults.standard.set(model.login?.image ?? "", forKey: Constants.userImage)
            performLangaugeChange()
            let login = true
            UserDefaults.standard.set(login, forKey: "login")
            let dictionary = [".": "_", " ": "_"]
            DIConfigurator.sharedInst().getRootViewC(.Auth, identifer: HomeVC.className)
        } else {
            if model.message == "Your profile is incomplete, Please complete your profile!" || model.message == "আপনার প্রোফাইল কমপ্লিট হয়নি, দয়া করে প্রোফাইল কমপ্লিট করুন।" {
                let isLogin = true
                print("ligiun id \(model.login?.id ?? "")")
                UserDefaults.standard.set(model.login?.id ?? "", forKey: Constants.userId)
                UserDefaults.standard.set(model.login?.token, forKey: Constants.accessToken)
                let view = UIStoryboard.init(name: "Auth", bundle: nil)
                let vc = view.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
