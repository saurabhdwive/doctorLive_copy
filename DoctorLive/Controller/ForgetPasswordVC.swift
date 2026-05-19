//
//  ForgetPasswordVC.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import DropDown
import Firebase
import FirebaseAuth
import ADCountryPicker

class ForgetPasswordVC: UIViewController, ADCountryPickerDelegate, UITextFieldDelegate  {
    
    //MARK:- Outlets
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnSendOTP : UIButton!
    @IBOutlet weak var btnCounrtyCode : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var lblSubHeading : UILabel!
    @IBOutlet weak var lblCountryCode : UITextField!
    @IBOutlet weak var txtPhoneNo : UITextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var phoneView: UIView!
    var picker = ADCountryPicker()
    private var countryCodeNum: String? = "+91"
    
    private let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!
        lblHeading.text = "Forgot Password".localized()
        lblSubHeading.text = "Please enter your register Phone number below and verify it to reset your password".localized()
        txtPhoneNo.placeholder = "Phone Number".localized()
        btnSendOTP.setTitle("Send OTP".localized(), for: .normal)
        countryCodeView.dropShadow(scale: true)
        phoneView.dropShadow(scale: true)
        lblCountryCode.delegate = self
        picker.delegate = self
        picker.defaultCountryCode = "+254"
        picker.showFlags = true
        picker.searchBarBackgroundColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func btnSendOTPPressed(_ sender: UIButton){
        performPhoneAuthentication()
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton){
        //navigationController?.popToRootViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCountryCodePressed(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = ["+91", "+880"]
        dropDown.anchorView = sender as? AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
        
       
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            // (sender as AnyObject).setTitle(item, for: .normal)
            self?.lblCountryCode.text = item
            self?.countryCodeNum = item
        }
    }
    
    func performPhoneAuthentication() {
        if self.lblCountryCode.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Select Country Code".localized())
        } else if self.txtPhoneNo.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter Mobile Number".localized())
        } else if !Utils.shared.isValidPhone(phone: self.txtPhoneNo.text ?? "") {
            AppToast.showMessage(message: "Please Enter Correct Mobile Number".localized())
        }else {
        guard let numbers = self.txtPhoneNo.text else { return }
        guard let country = self.countryCodeNum else { return }
        let number = "\(country)\(numbers)"
        let defaults = UserDefaults.standard
        defaults.set(country, forKey: Constants.countryCode)
        defaults.set(numbers, forKey: Constants.mobileNo)
        defaults.synchronize()
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(number , uiDelegate: nil, completion: {verificationId, error in
            guard let verification = verificationId else { return }
            UserDefaults.standard.setValue(verification, forKey: "verificationId")
                if (error == nil){
                     let view = UIStoryboard.init(name: "Auth", bundle: nil)
                     let vc = view.instantiateViewController(withIdentifier: "OTPPopUp") as! OTPPopUp
                     vc.forgetPass = true
                     vc.phoneNum = self.txtPhoneNo.text
                     vc.countryCode = self.countryCodeNum
                     vc.isCameFrom = "ForgetPasswordVC"
                     vc.modalPresentationStyle = .overFullScreen
                     vc.OtpCallBack = {
                         self.dismiss(animated: true, completion: nil)
                         let view = UIStoryboard.init(name: "Auth", bundle: nil)
                         let vc = view.instantiateViewController(withIdentifier: "ResetPaaswordVC") as! ResetPaaswordVC
                         vc.mobile = self.txtPhoneNo.text
                         vc.countryCode = self.countryCodeNum
                         self.navigationController?.pushViewController(vc, animated: true)
                     }
                     self.present(vc, animated: true, completion: nil)
                }else {
                    Utils().displayAlert(title: "", message: error?.localizedDescription ?? "", viewController: self)
                }
            })
        }
    }
}
extension ForgetPasswordVC {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == lblCountryCode {
            let pickerNavigationController = UINavigationController(rootViewController: picker)
            pickerNavigationController.modalTransitionStyle = .crossDissolve
            pickerNavigationController.modalPresentationStyle = .fullScreen
            self.present(pickerNavigationController, animated: true, completion: nil)
        }
        return true
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        lblCountryCode.text = dialCode
        self.countryCodeNum = dialCode
        dismiss(animated: true, completion: nil)
    }
}
