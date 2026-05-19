//
//  OTPPopUp.swift
//  DoctorLive
//
//  Created by User on 16/08/21.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import PromiseKit
import Alamofire
class OTPPopUp: ParentViewController, UITextFieldDelegate, AnimationProviding {
    
    //MARK:- Outlets
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnVerify : UIButton!
    @IBOutlet weak var btnResend : UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var lblSubHeading : UILabel!
    @IBOutlet weak var timerLable: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var popView: UIView!
    var attachmentType = String()
    var forgetPass: Bool?
    var phoneNum: String?
    var countryCode: String?
    var isLogin = false
    var isCameFrom: String?
    var Otp1CallBack: (() -> ())?
    var OtpCallBack: (() -> ())?
    var LoginWithOtpCallBack: (() -> ())?
    var incompleteProfileCallBack:(() -> ())?
    var style = ToastStyle()
   
    var otpMessageStyle = ToastStyle()
    var timer = Timer()
    var totalSecond = 60
    var tapResend =  true
    var sessionDataTask: URLSessionDataTask?
    var password: String?
    var userName: String?
    var smsPass = -1
    var socialLogin = ""
    var google: String?
    var facebook: String?
    var apple: String?
    var case2: String?
    var mobileNumber: String?
    var name: String?
    var email: String?
    var dob: String?
    var gender: String?
    var passportNum: String?
    var documentNum: String?
    var passportImage: UIImage?
    var documnetImage: UIImage?
    var adress: String?
    var adressLat: String?
    var adressLong: String?
    var confirmPass: String?
    var checkBtn: Bool?
    var isSignup: Bool?
    var completeProfile: Bool?
    var navController: UINavigationController?
    var lattitude = String()
    var longitude = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startTimer()
        self.btnResend.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        popView.addGestureRecognizer(tapGesture)
        mainView.layer.cornerRadius = 25
        setupUI()
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self
        textField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func superViewTapped(sender: UITapGestureRecognizer) {
        if let navController = self.navController{
            navController.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func textFieldDidChange(textField: UITextField){
            let text = textField.text
            if  text?.count == 1 {
                switch textField{
                case textField1:
                    textField2.becomeFirstResponder()
                case textField2:
                    textField3.becomeFirstResponder()
                case textField3:
                    textField4.becomeFirstResponder()
                case textField4:
                    textField5.becomeFirstResponder()
                case textField5:
                    textField6.becomeFirstResponder()
                case textField6:
                    textField6.resignFirstResponder()
                default:
                    break
                }
            }
            if  text?.count == 0 {
                switch textField{
                case textField1:
                    textField1.becomeFirstResponder()
                case textField2:
                    textField1.becomeFirstResponder()
                case textField3:
                    textField2.becomeFirstResponder()
                case textField4:
                    textField3.becomeFirstResponder()
                case textField5:
                    textField4.becomeFirstResponder()
                case textField6:
                    textField5.becomeFirstResponder()
                default:
                    break
                }
            }
            else{
       print("err")
            }
        }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func loaderWithText(massege: String) {
        let alert = UIAlertController(title: nil, message: massege, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- SetUp UI/UX
    fileprivate func setupUI(){
        setupLable(["Verifications".localized(),"Please enter the OTP sent to your mobile number".localized()], [lblHeading,lblSubHeading], [.center,.center], [.Medium,.Regular], [17,14])
        btnVerify.setTitle("Verify".localized(), for: .normal)
        btnVerify.titleLabel?.font =  AppFont.Medium.size(AppFontName.poppins, size: 17)
        btnResend.setTitle("Resend".localized(), for: .normal)
        btnResend.titleLabel?.font =  AppFont.Medium.size(AppFontName.poppins, size: 17)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- IBAction
    @IBAction func btnverifyPressed(_ sender: UIButton) {
        if isCameFrom == "Login" {
            performLoginWithOtp()
        } else {
            validations()
        }
    }
    
    @IBAction func btnResendPressed(_ sender: UIButton) {
        loaderWithText(massege: "Sending OTP...".localized())
        guard let countryCode =  UserDefaults.standard.string(forKey: Constants.countryCode) else {return}
        guard let number =  UserDefaults.standard.string(forKey: Constants.mobileNo) else {return}
        let num = "\(countryCode)\(number)"
        PhoneAuthProvider.provider().verifyPhoneNumber(num, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                LoaderController.sharedInstance.removeLoader()
                self.dismiss(animated: true, completion: nil)
            }
         }
     }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        self.totalSecond -= 1
        self.timerLable.text = self.timeString(time: TimeInterval(self.totalSecond))
        if self.totalSecond == 0 {
            self.timerLable.isHidden = true
            self.btnResend.isHidden = false
            self.timer.invalidate()
        } else {
            self.timerLable.isHidden = false
            self.btnResend.isHidden = true
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

extension OTPPopUp {
    func performSignUp(param: [String: String]) {
        firstly {
            service!.signup(parameters: param, header: "DeviceToken")
        }.done { (model: SignUpModel) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                print(error.localizedDescription)
            }
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func validations() {
        if self.textField1.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField2.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField3.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField4.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField5.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField6.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else {
            performOtpVerification()
        }
    }
    
    func handleResponse(model: SignUpModel){
        if model.status == "SUCCESS" {
            print(model)
            let token = model.signup?.token
            let userId = model.signup?.id
           
            UserDefaults.standard.set(token, forKey: Constants.accessToken)
            UserDefaults.standard.set(userId, forKey: Constants.userId)
           
            //dismiss(animated: true, completion: nil)
            self.Otp1CallBack?()
            //            let appDel = UIApplication.shared.delegate as! AppDelegate
            //            _ = appDel.initHome()
            //            let view = UIStoryboard.init(name: "Auth", bundle: nil)
            //            let vc = view.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
            //            let completeProfile = true
            //            UserDefaults.standard.set(completeProfile, forKey: Constants.isSignup)
            //            self.navigationController?.pushViewController(vc, animated: true)
            // vc.modalPresentationStyle = .overFullScreen
            //self.present(vc, animated: true, completion: nil)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
    
    func performOtpVerification() {
        guard let text1 = textField1.text else { return }
        guard let text2 = textField2.text else { return }
        guard let text3 = textField3.text else { return }
        guard let text4 = textField4.text else { return }
        guard let text5 = textField5.text else { return }
        guard let text6 = textField6.text else { return }
        let fullOTP = "\(text1)\(text2)\(text3)\(text4)\(text5)\(text6)"
        print(fullOTP)
        guard let verificationId = UserDefaults.standard.string(forKey: "verificationId") else { return }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId, verificationCode: fullOTP)
        Auth.auth().signIn(with: credential) { [self] (success, error) in
            if error == nil {
                if forgetPass == true {
                    self.OtpCallBack?()
                } else {
                    updatePractitionerServices()
//                    var parameter = [String: String]()
//                    guard let mobileNumber = phoneNum else { return }
//                    guard let countryCode = countryCode?.chopPrefix() else { return }
//                    guard let name = name else { return }
//                    guard let email = email else { return }
//                    guard let password = password else { return }
//                    guard let confirmPassword = confirmPass else { return }
//                    guard let dob = dob else { return }
//                    guard let gender = gender else { return }
//                    guard let address = adress else { return }
//                    guard let addressLatitude = adressLat else { return }
//                    guard let addressLongitude = adressLong else { return }
//                    let deviceToken = UserDefaults.standard.string(forKey: Constants.deviceId)
//                    guard let passportNum = passportNum else { return }
//                    guard let passportImage = passportImage else { return }
//                    guard let registrationNum = documentNum else { return }
//                    guard let registrationImage = documnetImage else {return}
//                    guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
//                    parameter = ["language_type": code,
//                                 "signup_type": "normal",
//                                 "name": name,
//                                 "email": email,
//                                 "country_code": countryCode,
//                                 "mobile": mobileNumber,
//                                 "password": password,
//                                 "confirm_password": confirmPassword,
//                                 "dob":dob,
//                                 "gender": gender,
//                                 "address": address,
//                                 "latitude": addressLatitude,
//                                 "longitude": addressLongitude,
//                                 "device_type": "ios",
//                                 "device_token": "\(deviceToken ?? "")",
//                                 "passport_num": passportNum,
//                                 "passport_image": "\(passportImage)",
//                                 "registration_num": registrationNum,
//                                 "registration_image":"\(registrationImage)"]
//                    performSignUp(param: parameter)
                  //  print("User sign in.....\(parameter)")
                }
            } else {
                Utils().displayAlert(title: "", message: "Please enter a valid Otp".localized(), viewController: self)
            }
        }
    }
    
    func updatePractitionerServices(){
        var parameter = [String: String]()
        guard let mobileNumber = phoneNum else { return }
        guard let countryCode = countryCode?.chopPrefix() else { return }
        guard let name = name else { return }
        guard let email = email else { return }
        guard let password = password else { return }
        guard let confirmPassword = confirmPass else { return }
        guard let dob = dob else { return }
        guard let gender = gender else { return }
        guard let address = adress else { return }
        guard let addressLatitude = adressLat else { return }
        guard let addressLongitude = adressLong else { return }
        let deviceToken = UserDefaults.standard.string(forKey: Constants.deviceId)
        guard let passportNum = passportNum else { return }
        guard let passportImage = passportImage else { return }
        guard let registrationNum = documentNum else { return }
        guard let registrationImage = documnetImage else {return}
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
       
        parameter = ["language_type": code,
                     "signup_type": "normal",
                     "name": name,
                     "email": email,
                     "country_code": countryCode,
                     "mobile": mobileNumber,
                     "password": password,
                     "confirm_password": confirmPassword,
                     "dob":dob,
                     "gender": gender,
                     "address": address,
                     "latitude": addressLatitude,
                     "longitude": addressLongitude,
                     "device_type": "ios",
                     "device_token": "\(deviceToken ?? "")",
                     "passport_num": passportNum,
                     "registration_num": registrationNum]
       
       
        //let header = AppNetworking.getFinalHeaders(header : [:])
        
        var imageNames : [String] = []
        var imageDataArr : [NSData] = []
        var fileName : [String] = []
        for i in 0..<2 {
            if i == 0 {
                if let imageData = passportImage.jpegData(compressionQuality: 0.5) as NSData?{
                imageDataArr.append(imageData)
                imageNames.append("passport_image")
                fileName.append("image_img.png")
              }
            } else if i == 1 {
                if let imageData = documnetImage?.jpegData(compressionQuality: 0.5) as NSData?{
                imageDataArr.append(imageData)
                imageNames.append("registration_image")
                fileName.append("image_img.png")
              }
            }
         
        }
        let url = "https://doctorlivebd.com/api/doctor/signup"
        Indicator.shared.showProgressView(view)
        APICaller.shared.updateProfileService(method: .post, imageData: imageDataArr, fileName: fileName ,imageparams: imageNames, url: url, params: parameter, dataType: self.attachmentType) { (result) in
            Indicator.shared.hideProgressView()

            switch result{

            case .success(let data):
                print(data)
                 if let jsonModel = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("jsonModel.....\(jsonModel)")
                }
                if let jsonData = try? JSONDecoder().decode(SignUpModel.self, from: data) {
                    print(".......\(jsonData)")
                    let token = jsonData.signup?.token
                    let userId = jsonData.signup?.id
                    UserDefaults.standard.set(token, forKey: Constants.accessToken)
                    UserDefaults.standard.set(userId, forKey: Constants.userId)
                   self.Otp1CallBack?()
                }
                break

            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}

extension OTPPopUp {
    func performLoginWithOtp(param: [String: String]) {
        firstly {
            service!.loginWithOtp(parameters: param, header: "DeviceToken")
        }.done { (model: LoginDataModel) in
            self.handleLoginWithOtpResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                print(error.localizedDescription)
            }
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performLoginWithOtp() {
        if self.textField1.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField2.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField3.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField4.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField5.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else if self.textField6.text?.isEmpty ?? false {
            AppToast.showMessage1(message: "Please Enter OTP First".localized(), self)
        } else {
            performLoginWithOtpVerification()
        }
    }
    
    func handleLoginWithOtpResponse(model: LoginDataModel){
        if model.status == "SUCCESS" {
            print(model)
            let token = model.login?.token
            let userId = model.login?.id
            let name = model.login?.name
            guard let number = model.login?.mobile else { return }
            guard let countryCode = model.login?.countryCode else {return}
            let isLogin = true
            UserDefaults.standard.set(token, forKey: Constants.accessToken)
            UserDefaults.standard.set(userId, forKey: Constants.userId)
            UserDefaults.standard.set(name, forKey: Constants.userName)
            UserDefaults.standard.set(number, forKey: Constants.mobileNo)
            UserDefaults.standard.set(countryCode, forKey: Constants.countryCode)
            UserDefaults.standard.set(isLogin, forKey: Constants.accountStatus)
            self.LoginWithOtpCallBack?()
           
        } else {
            if model.message == "Your profile is incomplete, Please complete your profile!" {
                let isLogin = true
                print("ligiun id \(model.login?.id ?? "")")
                
                UserDefaults.standard.set(model.login?.id ?? "", forKey: Constants.userId)
                UserDefaults.standard.set(model.login?.token, forKey: Constants.accessToken)
                self.incompleteProfileCallBack?()
//                let view = UIStoryboard.init(name: "Auth", bundle: nil)
//                let vc = view.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.dismiss(animated: true, completion: nil)
            AppToast.showMessage(message: model.message ?? "")
        }
    }
    
    func performLoginWithOtpVerification() {
        guard let text1 = textField1.text else { return }
        guard let text2 = textField2.text else { return }
        guard let text3 = textField3.text else { return }
        guard let text4 = textField4.text else { return }
        guard let text5 = textField5.text else { return }
        guard let text6 = textField6.text else { return }
        let fullOTP = "\(text1)\(text2)\(text3)\(text4)\(text5)\(text6)"
        print(fullOTP)
        guard let verificationId = UserDefaults.standard.string(forKey: "verificationId") else { return }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId, verificationCode: fullOTP)
        Auth.auth().signIn(with: credential) { [self] (success, error) in
            if error == nil {
                if forgetPass == true {
                    self.OtpCallBack?()
                } else {
                    var parameter = [String: String]()
                    guard let mobileNumber = phoneNum else { return }
                    guard let countryCode = countryCode?.chopPrefix() else { return }
                    
                    let deviceToken = UserDefaults.standard.string(forKey: Constants.deviceId)
                   
                    guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
                    parameter = ["language_type": code,
                                 "country_code": countryCode,
                                 "mobile": mobileNumber,
                                 "device_token": deviceToken ?? "",
                                 "device_type": "ios",
                                 "latitude": "\(lattitude)",
                                 "longitude": "\(longitude)"]
                    performLoginWithOtp(param: parameter)
                    print("User sign in.....\(parameter)")
                }
            } else {
                Utils().displayAlert(title: "", message: "\(error?.localizedDescription ?? "")", viewController: self)
            }
        }
    }
}
