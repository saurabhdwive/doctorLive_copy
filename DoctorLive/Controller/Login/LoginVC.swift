//
//  LoginVC.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import Firebase
import AuthenticationServices
import FirebaseAuth
import DropDown
import Mobilisten
import SideMenu
import MapKit
import ADCountryPicker

class LoginVC: ParentViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ADCountryPickerDelegate {
    
    @IBOutlet weak var btnLogin : UIButton!
    @IBOutlet weak var btnSignUp : UIButton!
    @IBOutlet weak var lblWelcomeMess : UILabel!
    @IBOutlet weak var lblCountryCode : UITextField!
    @IBOutlet weak var txtPhone : UITextField!
    @IBOutlet weak var txtPwd : UITextField!
    @IBOutlet weak var CountryCodeView : UIView!
    @IBOutlet weak var btnEye1: UIButton!
    @IBOutlet weak var PhoneView : UIView!
    @IBOutlet weak var PwdView : UIView!
    @IBOutlet weak var lblTermsAndConition : UILabel!
    @IBOutlet weak var termsconditionLbl: UILabel!
    @IBOutlet weak var privacyPolicyLbl: UILabel!
    
    @IBOutlet weak var andLbl: UILabel!
    
    @IBOutlet weak var privacyContraint: NSLayoutConstraint!
   
    @IBOutlet weak var languageControler: UISegmentedControl!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var loginWithPassBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    
    var languageCode = String()
    var countryCodeNum: String? = "+880"
    var isAlreadyLogin: Bool?
    let code = "en"
    var flag = false
    var picker = ADCountryPicker()
    
    var sessionDataTask: URLSessionDataTask?
    var isLogin = false
    var completeProfile: Bool?
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentLat = String()
    var currentLong = String()
    
    let userDefault = UserDefaults.standard
    override func viewDidLoad(){
        super.viewDidLoad()
        UserDefaults.standard.set(code, forKey: Constants.languageCode)
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!
        if isAlreadyLogin == true {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.initControllerrr(identifer: "HomeVC")
        }
        locManager.requestWhenInUseAuthorization()
        self.termsconditionLbl.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(termsConditionPolicy))
        termsconditionLbl.addGestureRecognizer(tap)
        tap.delegate = self
        
        self.privacyPolicyLbl.isUserInteractionEnabled = true
        let privacytap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(privacyPolicyTapLabe))
        
        privacyPolicyLbl.addGestureRecognizer(privacytap)
        privacytap.delegate = self
       
        lblCountryCode.delegate = self
        picker.delegate = self
        picker.defaultCountryCode = "+254"
        picker.showFlags = true
        picker.searchBarBackgroundColor = UIColor.white
        
        ZohoSalesIQ.showLauncher(false)
        loginWithPassBtn.setTitle("Login With Password", for: .normal)
        passwordConstraint.constant = 0
        forgetPasswordBtn.isHidden = true
        passwordView.isHidden = true
        CountryCodeView.dropShadow(scale: true)
        PhoneView.dropShadow(scale: true)
        PwdView.dropShadow(scale: true)
        getCurrentLocation()
       
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func getCurrentLocation() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
    }
    
    func changeLanguage() {
        lblWelcomeMess.text = "Welcome Practitioners!".localized()
        forgetPasswordBtn.setTitle("Forgot your password?".localized(), for: .normal)
        btnLogin.setTitle("Login".localized(), for: .normal)
        btnSignUp.setTitle("Register".localized(), for: .normal)
        txtPhone.placeholder = "Phone Number".localized()
        txtPwd.placeholder = "Password".localized()
        termsconditionLbl.text = "Privacy Policy".localized()
        privacyPolicyLbl.text = "Terms and conditions".localized()
        lblTermsAndConition.text = "By Login you Agreed to our".localized()
        andLbl.text = "&".localized()
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton){
        self.validatePhoneNumber()
    }
    
    @IBAction func passwordTapped(_ sender: Any) {
        self.btnEye1.isSelected = !btnEye1.isSelected
        if btnEye1.isSelected{
            self.txtPwd.isSecureTextEntry = false
        }else{
            self.txtPwd.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginWithPassword(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.loginWithPassBtn.titleLabel?.text == "Login With OTP" || self.loginWithPassBtn.titleLabel?.text == "দিয়ে লগইন করুন" {
                self.loginWithPassBtn.setTitle("Login With Password".localized(), for: .normal)
                self.passwordConstraint.constant = 0
                self.forgetPasswordBtn.isHidden = true
                self.passwordView.isHidden = true
            } else if self.loginWithPassBtn.titleLabel?.text == "Login With Password" || self.loginWithPassBtn.titleLabel?.text == "পাসওয়ার্ড দিয়ে লগইন করুন" {
                self.loginWithPassBtn.setTitle("Login With OTP".localized(), for: .normal)
                self.passwordConstraint.constant = 30
                self.forgetPasswordBtn.isHidden = false
                self.passwordView.isHidden = false
            }
        }
    }
    
    @IBAction func langaugeSegmentController(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            let code = "en"
            UserDefaults.standard.set(code, forKey: Constants.languageCode)
            Localize.setCurrentLanguage(language: code)
            privacyContraint.constant = -25
            if loginWithPassBtn.titleLabel?.text == "Login With Password" || loginWithPassBtn.titleLabel?.text == "পাসওয়ার্ড দিয়ে লগইন করুন" {
                loginWithPassBtn.setTitle("Login With Password".localized(), for: .normal)
            } else if loginWithPassBtn.titleLabel?.text == "Login With OTP" || loginWithPassBtn.titleLabel?.text == "দিয়ে লগইন করুন" {
                loginWithPassBtn.setTitle("Login With OTP".localized(), for: .normal)
            } else {
                
            }
            changeLanguage()
            
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
            let code = "bn"
            UserDefaults.standard.set(code, forKey: Constants.languageCode)
            Localize.setCurrentLanguage(language: code)
            privacyContraint.constant = 100
            if loginWithPassBtn.titleLabel?.text == "Login With Password" || loginWithPassBtn.titleLabel?.text == "পাসওয়ার্ড দিয়ে লগইন করুন"{
                loginWithPassBtn.setTitle("Login With Password".localized(), for: .normal)
            } else if loginWithPassBtn.titleLabel?.text == "Login With OTP" || loginWithPassBtn.titleLabel?.text == "দিয়ে লগইন করুন"{
                loginWithPassBtn.setTitle("Login With OTP".localized(), for: .normal)
            } else {
                
            }
            changeLanguage()
        }
    }
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "SignUpVc") as! SignUpVc
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnForgetPwdPressed(_ sender: UIButton) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func privacyPolicyTapLabe(sender: UITapGestureRecognizer) {
        let faqs = TermsAndConditionViewController(nibName: "TermsAndConditionViewController", bundle: nil)
        faqs.title = "Privacy Policy"
        faqs.urlString = "https://doctorlivebd.com/api/user/privacy"
        faqs.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(faqs, animated: true)
    }
    
   @objc func termsConditionPolicy(sender: UITapGestureRecognizer){
       let faqs = TermsAndConditionViewController(nibName: "TermsAndConditionViewController", bundle: nil)
       faqs.urlString = "https://doctorlivebd.com/api/user/terms"
       faqs.title = "Terms and conditions"
       faqs.modalPresentationStyle = .fullScreen
       self.navigationController?.pushViewController(faqs, animated: true)
    }
}
