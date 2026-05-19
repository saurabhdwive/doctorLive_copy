//
//  SignUpVc.swift
//  DoctorLive
//
//  Created by User on 18/08/21.
//

import UIKit
import DropDown
import Firebase
import AuthenticationServices
import FirebaseAuth
import PromiseKit
import Alamofire
import RSSelectionMenu
import ADCountryPicker
class SignUpVc: ParentViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MyDataSendingDelegateProtocol, ADCountryPickerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var nameView : UIView!
    @IBOutlet weak var emailView : UIView!
    @IBOutlet weak var countryCodeView : UIView!
    @IBOutlet weak var phoneView : UIView!
    @IBOutlet weak var dobView : UIView!
    @IBOutlet weak var genderView : UIView!
    @IBOutlet weak var passportNoView : UIView!
    @IBOutlet weak var BDMCView : UIView!
    @IBOutlet weak var addressPinView : UIView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var passwordView : UIView!
    @IBOutlet weak var confirmPasswordView : UIView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnSignUp : UIButton!
    @IBOutlet weak var btnUploadPhotoPassport : UIButton!
    @IBOutlet weak var btnUploadPhotoBDMC : UIButton!
     @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var lblTermsAndConition : UILabel!
    @IBOutlet weak var btnCheck : UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountryCode : UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtGender : UITextField!
    @IBOutlet weak var txtPassportNo : UITextField!
    @IBOutlet weak var txtBDMC : UITextField!
    @IBOutlet weak var txtAddressPin : UITextField!
    @IBOutlet weak var uploadPassportImage: UILabel!
    @IBOutlet weak var uploadBmdcImage: UILabel!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var btnEye1: UIButton!
    @IBOutlet weak var btnEye2: UIButton!
    @IBOutlet weak var passPortCamImage: UIImageView!
    @IBOutlet weak var bmdcImage: UIImageView!
    @IBOutlet weak var passportImage: UIImageView!
    @IBOutlet weak var bmdcCameraImage: UIImageView!
    @IBOutlet weak var editPassBtn: UIButton!
    @IBOutlet weak var editBMDCimage: UIButton!
    var gender = String()
    var passportImageUrl: String?
    var documentImageUrl: String?
    private var countryCodeNum: String? = ""
    let datePicker = UIDatePicker()
    var sessionDataTask: URLSessionDataTask?
    var checkBtn: Bool? = false
    var adressText: String?
    var latitude: String?
    var longitude: String?
    var flag = false
    var passportImageData: UIImage?
    var bmdcImageData: UIImage?
    var picker = ADCountryPicker()
    private let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDob.delegate = self
        txtCountryCode.delegate = self
        picker.delegate = self
        picker.defaultCountryCode = "+254"
        picker.showFlags = true
        picker.searchBarBackgroundColor = UIColor.white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editBMDCimage.isHidden = true
        editPassBtn.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func dobButtonTapped(_ sender: Any) {
        openDatePicker()
    }
    
    @IBAction func tapEyePwd(sender: AnyObject) {
        btnEye1.isSelected = !btnEye1.isSelected
        if btnEye1.isSelected{
            self.txtPassword.isSecureTextEntry = false
        }else{
            self.txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func tapEyeCurrentPWD(sender: AnyObject) {
        btnEye2.isSelected = !btnEye2.isSelected
        if btnEye2.isSelected{
            self.txtConfirmPassword.isSecureTextEntry = false
        }else{
            self.txtConfirmPassword.isSecureTextEntry = true
        }
    }
    
    func sendDataToFirstViewController(lat: String) {
        self.latitude = lat
        print(lat)
    }
    
    func sendDataToFirstViewController(long: String) {
        self.longitude = long
        print(long)
    }
    
    func sendDataToFirstViewController(adress: String) {
        self.adressText = adress
        print(adress)
        txtAddressPin.text = adress
    }
    
    //MARK:- SetUp UI/UX
    fileprivate func setupUI() {
        DropDown.appearance().backgroundColor = UIColor(named: "BackGround")
        DropDown.appearance().textColor = UIColor(named: "TextColour")!
        setupLable(["Doctor Registration".localized()], [lblHeading], [.center], [.Medium], [17])
        txtName.placeholder = "Title & Full Name".localized()
        txtEmail.placeholder = "Email Id".localized()
        txtPhoneNo.placeholder = "Phone Number".localized()
        txtGender.placeholder = "Gender".localized()
        txtPassportNo.placeholder = "NID/Passport No.".localized()
        uploadBmdcImage.text = "+ Upload Photo".localized()
        uploadPassportImage.text = "+ Upload Photo".localized()
        txtBDMC.placeholder = "BMDC Reg. No.".localized()
        txtAddressPin.placeholder = "Address".localized()
        txtPassword.placeholder = "Password".localized()
        txtConfirmPassword.placeholder = "Confirm Password".localized()
        //lblTermsAndConition.text = "I hereby declare that provided information comply with BM & DC policy and accepted the Terms & conditions & Privacy Policy of Dr. Live".localized()
        btnSignUp.setTitle("Sign Up".localized(), for: .normal)
        txtGender.textColor = UIColor(named: "TextColour")
        
        btnSignUp.titleLabel?.font =  AppFont.Medium.size(AppFontName.poppins, size: 17)
        //btnUploadPhotoPassport.setTitle("+ Upload Photo".localized(), for: .normal)
        btnUploadPhotoPassport.titleLabel?.font =  AppFont.Regular.size(AppFontName.poppins, size: 14)
        //btnUploadPhotoBDMC.setTitle("+ Upload Photo".localized(), for: .normal)
        btnUploadPhotoBDMC.titleLabel?.font =  AppFont.Regular.size(AppFontName.poppins, size: 14)
        nameView.dropShadow(scale: true)
        emailView.dropShadow(scale: true)
        countryCodeView.dropShadow(scale: true)
        phoneView.dropShadow(scale: true)
        dobView.dropShadow(scale: true)
        genderView.dropShadow(scale: true)
        passportNoView.dropShadow(scale: true)
        BDMCView.dropShadow(scale: true)
        addressPinView.dropShadow(scale: true)
        // addressDetailView.dropShadow(scale: true)
        passwordView.dropShadow(scale: true)
        confirmPasswordView.dropShadow(scale: true)
        self.lblTermsAndConition.isUserInteractionEnabled = true
        let tapgesturePrivacy = UITapGestureRecognizer.init(target: self, action: #selector(privacyPolicyTapLabel(_:)))
        tapgesturePrivacy.numberOfTapsRequired = 1
        self.lblTermsAndConition.addGestureRecognizer(tapgesturePrivacy)
        self.privacyPolicy()
    }

    private func privacyPolicy() {
        let termsAndConditionString = "I hereby declare that provided information comply with BM & DC policy and accepted the Terms and conditions & Privacy Policy of Dr. Live."
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: termsAndConditionString, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 18.0)!])
      myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Utils.shared.hexStringToUIColor(hex: "#1C75BC"), range: NSRange(location: 87, length: 20))
        self.lblTermsAndConition.attributedText = myMutableString
      myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Utils.shared.hexStringToUIColor(hex: "#1C75BC"), range: NSRange(location: 110, length: 14))
        self.lblTermsAndConition.attributedText = myMutableString

    }

    @objc func privacyPolicyTapLabel(_ gesture: UITapGestureRecognizer) {
       let text = self.lblTermsAndConition.text  ?? ""
        let privacyRange = (text as NSString).range(of: "Terms and conditions")
        let termsRange = (text as NSString).range(of: "Privacy Policy")
        if gesture.didTapAttributedTextInLabel(label: self.lblTermsAndConition, inRange: privacyRange) {
            let faqs = TermsAndConditionViewController(nibName: "TermsAndConditionViewController", bundle: nil)
            faqs.urlString = "https://doctorlivebd.com/api/user/terms"
            faqs.title = "Terms and conditions"
            faqs.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(faqs, animated: true)
        } else if  gesture.didTapAttributedTextInLabel(label: self.lblTermsAndConition, inRange: termsRange) {
            let faqs = TermsAndConditionViewController(nibName: "TermsAndConditionViewController", bundle: nil)
            faqs.title = "Privacy Policy"
            faqs.urlString = "https://doctorlivebd.com/api/user/privacy"
            faqs.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(faqs, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        validations()
    }
    
    @IBAction func btnUploadPhotoPassportPressed(_ sender: UIButton) {
       ImagePickerManager().pickImage(self) { image in
           self.passportImageData = image
                self.passPortCamImage.isHidden = true
                self.editPassBtn.isHidden = false
                self.uploadPassportImage.isHidden = true
                self.passportImage.image = image
                self.passportImage.contentMode = .scaleAspectFill

        }
    }
    
//    @IBAction func locationButtonTapped(_ sender: Any) {
//        let location = LocationViewController()
//        location.delegate = self
//        self.navigationController?.pushViewController(location, animated: true)
//    }
    
    @IBAction func btnUploadPhotoBDMCPressed(_ sender: UIButton) {
      ImagePickerManager().pickImage(self) { image in
           self.bmdcImageData = image
                self.bmdcCameraImage.isHidden = true
                self.editBMDCimage.isHidden = false
                self.uploadBmdcImage.isHidden = true
                self.bmdcImage.image = image
                self.bmdcImage.contentMode = .scaleAspectFill
        }
    }
    
    @IBAction func editPassTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { image in
            self.passportImageData = image
                 self.passPortCamImage.isHidden = true
                 self.editPassBtn.isHidden = false
                 self.uploadPassportImage.isHidden = true
                 self.passportImage.image = image
                 self.passportImage.contentMode = .scaleAspectFill

         }
    }
    
    @IBAction func editBMDCTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { image in
             self.bmdcImageData = image
                  self.bmdcCameraImage.isHidden = true
                  self.editBMDCimage.isHidden = false
                  self.uploadBmdcImage.isHidden = true
                  self.bmdcImage.image = image
                  self.bmdcImage.contentMode = .scaleAspectFill
          }
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
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
            self?.txtCountryCode.text = item
            self?.countryCodeNum = item
        }
    }
       
    @IBAction func btnCheck(_ sender: Any) {
        if flag == false {
            btnCheck.setImage(#imageLiteral(resourceName: "checke"), for: .normal)
            flag = true
        }else{
            btnCheck.setImage(#imageLiteral(resourceName: "Rectangle 701"), for: .normal)
            flag = false
        }
    }
    
    @IBAction func genderButtonTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = ["Male", "Female", "Others"]
        dropDown.anchorView = sender as? AnchorView
      
        
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        dropDown.show()
        
        //self.dropDownButton.isHidden = true
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            if item == "Male" {
                self?.gender = "m"
                self?.txtGender.text = item
            } else if item == "Female" {
                self?.gender = "f"
                self?.txtGender.text = item
            } else {
                self?.gender = "o"
                self?.txtGender.text = item
            }
         }
     }
 }

extension SignUpVc {
    func performPhoneAuthentication() {
        guard let numbers = self.txtPhoneNo.text else { return }
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
                vc.isSignup = true
                vc.name = self.txtName.text
                vc.email = self.txtEmail.text
                vc.dob = self.txtDob.text
                vc.gender = self.gender
                vc.passportNum = self.txtPassportNo.text
                vc.documentNum = self.txtBDMC.text
                vc.passportImage = self.passportImageData
                vc.documnetImage = self.bmdcImageData
                vc.adress = self.txtAddressPin.text ?? ""
                vc.adressLat = self.latitude
                vc.adressLong = self.longitude
                vc.phoneNum = self.txtPhoneNo.text
                vc.countryCode = self.countryCodeNum
                vc.password = self.txtPassword.text
                vc.confirmPass = self.txtConfirmPassword.text
                vc.isCameFrom = "SignUpVc"
                vc.modalPresentationStyle = .overFullScreen
                vc.Otp1CallBack = {
                self.dismiss(animated: true, completion: nil)
                let view = UIStoryboard.init(name: "Auth", bundle: nil)
                let vc = view.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
                let completeProfile = true
                UserDefaults.standard.set(completeProfile, forKey: Constants.isSignup)
                self.navigationController?.pushViewController(vc, animated: true)
                }
                self.present(vc, animated: true, completion: nil)
            } else {
                Utils().displayAlert(title: "", message: error?.localizedDescription ?? "", viewController: self)
               
            }
        }
    }
 }

extension SignUpVc {
    func performSignUpValidate(param: [String: String]) {
        firstly {
            service!.checkemail(parameters: param, header: "DeviceToken")
        }.done { (model: CheckMailModel) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
        }
            
        }.finally {
            DispatchQueue.main.async {
               
            }
        }
    }
    
    func validations() {
        var parameter = [String: String]()
        let number = "\(txtPhoneNo.text ?? "")"
        if self.txtName.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter Your Name".localized())
        } else if self.txtEmail.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter Email".localized())
        } else if !Utils.shared.isValidEmailString(emailString: txtEmail.text ?? "") {
           AppToast.showMessage(message: "Please Enter Correct Email".localized())
        } else if self.txtCountryCode.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Select Country Code".localized())
        } else if self.txtPhoneNo.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter Mobile Number".localized())
        } else if !Utils.shared.isValidPhone(phone: self.txtPhoneNo.text ?? ""){
            AppToast.showMessage(message: "Please Enter Correct Mobile Number".localized())
        } else if self.txtDob.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Select Date of Birth".localized())
        } else if self.txtGender.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Select your Gender".localized())
        } else if self.txtPassportNo.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter NID/passport number".localized())
        } else if self.passportImageData == nil {
            AppToast.showMessage(message: "Please Upload your passport image".localized())
        } else if self.txtBDMC.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter BMDC Number".localized())
        } else if self.bmdcImageData == nil  {
            AppToast.showMessage(message: "Please Upload your BMDC image".localized())
        } else if self.txtAddressPin.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter Your Address".localized())
        } else if self.txtPassword.text?.isEmpty ?? false {
            AppToast.showMessage(message: "Please Enter your password".localized())
        } else if !Utils.shared.isValidPassword(passString: txtPassword.text ?? "") { AppToast.showMessage(message: "Please Enter Valid Password".localized())
        } else if self.txtConfirmPassword.text?.isEmpty ?? false{
            AppToast.showMessage(message: "Please confirm Your Password".localized())
        } else if !Utils.shared.isValidPassword(passString: txtConfirmPassword.text ?? "") {
            AppToast.showMessage(message: "Please Enter Valid Password".localized())
        } else if self.txtPassword.text != self.txtConfirmPassword.text {
            AppToast.showMessage(message: "Your password not match".localized())
        } else if flag == false {
            AppToast.showMessage(message: "Please accept term & condition".localized())
        } else {
            guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
            parameter = ["language_type": code,
                         "email": txtEmail.text ?? "",
                         "mobile": number]
            performSignUpValidate(param: parameter)
        }
    }
    
    func handleResponse(model: CheckMailModel) {
        if model.status == "SUCCESS" {
            print(model)
            self.performPhoneAuthentication()
        } else {
            AppToast.showMessage1(message: model.message ?? "", self)
        }
     }
 }

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
extension SignUpVc {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCountryCode {
            let pickerNavigationController = UINavigationController(rootViewController: picker)
            pickerNavigationController.modalTransitionStyle = .crossDissolve
            pickerNavigationController.modalPresentationStyle = .fullScreen
            self.present(pickerNavigationController, animated: true, completion: nil)
        }
            return true
        }
 
func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
     txtCountryCode.text = dialCode
      self.countryCodeNum = dialCode
    dismiss(animated: true, completion: nil)
}
}
