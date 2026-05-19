//  BaseViewController.swift
//
//  Created by Sandeep Vishwakarma on 4/16/18.
//  Copyright © 2018 Sandeep. All rights reserved.
//

import Foundation
import UIKit
//import RealmSwift
import MapKit
import CoreLocation


struct Constant {
    
    static let checkInternet = NSLocalizedString("Please check your Internet connection", comment: "")
    static let enterUsername = NSLocalizedString("Please enter your login and Display Name.", comment: "")
    static let shouldContainAlphanumeric = NSLocalizedString("Field should contain alphanumeric characters only in a range 3 to 20. The first character must be a letter.", comment: "")
    static let password = NSLocalizedString("Field should contain alphanumeric characters only in a range 8 to 15, without space. The first character must be a letter.", comment: "")
    static let countryCode = NSLocalizedString("Please select your Country Code.", comment: "")
    static let phoneNo = NSLocalizedString("Please enter your valid Phone Number.", comment: "")
    static let logoutMessage = NSLocalizedString("Do you really want to logout!", comment: "")
    static let tokenExpire = NSLocalizedString("This credential is logged in through other device", comment: "")
}

struct RegularExtentionName {
    
    static let user = "^[^_][\\w\\u00C0-\\u1FFF\\u2C00-\\uD7FF\\s]{2,19}$"
    static let passord = "^[a-zA-Z][a-zA-Z0-9]{7,14}$"
    static let mobile = "^[0-9]{10}$"
}

enum UINaming:Int {
    
    case countryCode
    case phoneNo
    case password
    case rememberMe
    case forgotPass
    case login
    case createAcc
    case PleaseEnterRegMNO
    case sendOtp
    case otp
    case enterOtpEnd
    case submit
    case resendOtp
    case clearAll
    case onGoing
    case past
    case short
    case OFD
    case CWP
    case CWDB
    case ServiceName
    case Date
    case Time
    case Paymentmethod
    case ServiceProviderDetails
    case Invoice
    case Profile
    case Payment
    case name
    case email
    case address
    case EYN
    case EYMNO
    case EYEID
    case EditProfile
    case AddNalMobNo
    case NotAvialable
    case Gender
    case ATC
    case support
    case contactUs
    case aboutUs
    case pushNoti
    case TOS
    case privacyPolicy
    case Pickup
    case WantDelivery
    case providerChange
    case paymentIssue
    case changeMind
    case otherReason
    case proceed
    case changeLanguage
    var name:String{
        
        switch self {
        case .countryCode:
            return "+91"
        case .phoneNo:
            return comClass.createString(Str: "Phone Number")
        case .password:
            return comClass.createString(Str: "Password")
        case .rememberMe:
            return comClass.createString(Str: "Remember me")
        case .forgotPass:
            return comClass.createString(Str: "Forgot Password")
        case .login:
            return comClass.createString(Str: "Login")
        case .createAcc:
            return comClass.createString(Str: "Create Account")
        case .PleaseEnterRegMNO:
            return comClass.createString(Str: "Please enter your registered Email Id")
        case .sendOtp:
            return comClass.createString(Str: "Send OTP")
        case .otp:
            return comClass.createString(Str: "OTP")
        case .enterOtpEnd:
            return comClass.createString(Str: "Enter the OTP received on mobile number ending with ******8765")
        case .submit:
            return comClass.createString(Str: "Submit")
        case .resendOtp:
            return comClass.createString(Str: "Resend Another OTP")
        case .clearAll:
            return comClass.createString(Str: "Clear All")
        case .onGoing:
            return comClass.createString(Str: "On Going")
        case .past:
            return comClass.createString(Str: "Past")
        case .short:
            return comClass.createString(Str: " Short")
        case .OFD:
            return comClass.createString(Str: "Out for Delivery")
        case .CWP:
            return comClass.createString(Str: "Chat with Provider")
        case .CWDB:
            return comClass.createString(Str: "Chat with Delivery Boy")
        case .ServiceName:
            return comClass.createString(Str: "Service Name")
        case .Date:
            return comClass.createString(Str: "Date")
        case .Time:
            return comClass.createString(Str: "Time")
        case .Paymentmethod:
            return comClass.createString(Str: "Payment method")
        case .ServiceProviderDetails:
            return comClass.createString(Str: "Service Provider Details")
        case .Invoice:
            return comClass.createString(Str: "  Invoice")
        case .Profile:
            return comClass.createString(Str: "Profile")
        case .Payment:
            return comClass.createString(Str: "Payment")
        case .name:
            return comClass.createString(Str: "Name")
        case .email:
            return comClass.createString(Str: "Email Id")
        case .address:
            return comClass.createString(Str: "Address")
        case .EYN:
            return comClass.createString(Str: "Enter your name")
        case .EYMNO:
            return comClass.createString(Str: "Enter your mobile number")
        case .EYEID:
            return comClass.createString(Str: "Enter your email id")
        case .EditProfile:
            return comClass.createString(Str: "Edit Profile")
        case .AddNalMobNo:
            return comClass.createString(Str: "Additional Mobile Number")
        case .NotAvialable:
            return comClass.createString(Str: "Not Available")
        case .Gender:
            return comClass.createString(Str: "Gender")
        case .ATC:
            return comClass.createString(Str: "Accept Terms & Conditions")
        case .aboutUs:
            return comClass.createString(Str: "About Us")
        case .support:
            return comClass.createString(Str: "Support")
        case .contactUs:
            return comClass.createString(Str: "Contact Us")
        case .pushNoti:
            return comClass.createString(Str: "Push Notifications")
        case .TOS:
            return comClass.createString(Str: "Terms of Service")
        case .privacyPolicy:
            return comClass.createString(Str: "Privacy Policy")
        case .Pickup:
            return comClass.createString(Str: "I'll Pickup")
        case .WantDelivery:
            return comClass.createString(Str: "I want Delivery")
        case .providerChange:
            return comClass.createString(Str: "  \("Not all the medications are available".localized())")
        case .paymentIssue:
            return comClass.createString(Str: "  \("Provider is so far away".localized())")
        case .changeMind:
            return comClass.createString(Str: "  \("Change Mind".localized())")
        case .otherReason:
            return comClass.createString(Str: "  \("Other".localized())")
        case .proceed:
            return comClass.createString(Str: "Proceed")
        case .changeLanguage:
            return comClass.createString(Str: "Change Language")
        }
        
    }
}

enum UINavigationBarButtonType: Int {
    case back
    case cross
    case done
    case add
    case location
    case show
    case logout
    case menu
    case cart
    case search
    
    
    var iconImage: UIImage? {
        switch self {
        case .back:  return UIImage(named: "back1")
        case .cross: return UIImage(named: "icBackW")
        case .done: return UIImage(named: "icDone")
        case .add: return UIImage(named: "")
        case .location: return UIImage(named: "icAddLocation")
        case .show: return UIImage(named: "icShowSave")
        case .logout: return UIImage(named: "logout")
        case .menu: return UIImage(named: "menu")
        case .cart: return UIImage(named: "cart")
        case .search: return UIImage(named: "search")
            
        }
    }
}

protocol BaseViewControllerDelegate {
    func navigationBarButtonDidTapped(_ buttonType: UINavigationBarButtonType)
}

class ParentViewController: UIViewController, CLLocationManagerDelegate {
    
    var baseDelegate: BaseViewControllerDelegate?
    private let navButtonWidth = 40.0
    private let edgeInset = CGFloat(10.0)
    private var subControllerName = String()
    internal var GradinetView = UIView()
    internal var  statusbarView = UIView()
    let AlertObj = UIAlertController()
    
    var delagateSearch : serachTapDelegate?
//    var viewModel = ViewModel()
    //    let realm = try! Realm()
    //Maps Variables
    //    private var infoWindow = WarningMessageView()
    //    var delegateWarningMessageView :LoadWarningMessageView?
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    let backgroundView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
         if touch?.view == self.view {
            backgroundView.resignFirstResponder()
        }
    }
    var refreshDelegate: RefreshDelegate?
    var locationManager = CLLocationManager()
    var lat = String()
    var long = String()
    var CountryCode = String()
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = AppColor.appColor
        return refreshControl
    }
    
    private var infoText = "" {
        didSet {
            
            alertWithHandler(message: infoText == kTokenExpireMessage ? Constant.tokenExpire: infoText) {
                
                if self.infoText == kTokenExpireMessage {
                    
                    //                    let realm = try! Realm()
                    
                    //                    try! realm.write {
                    
                    //                        let deletedNotifications = realm.objects(UserDataModel.self)
                    //                        realm.delete(deletedNotifications)
                    //                        kAppDelegate.navigator = ApplicationNavigator(window: kAppDelegate.window)
                    //                    }
                    
                }else if self.infoText == Constant.checkInternet || self.infoText == "URLSessionTask failed with error: The network connection was lost."{
                    // self.delegateWarningMessageView?.loadWarinigView()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.cornerRadius = 15
        //self.infoWindow = loadWarningNiB()
        //
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.baseDelegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Setup
    /*
    func defaultConfiguration() {
        
        //MARK: - Reachability
        let updateLoginInfo: ((_ status: NetworkConnectionStatus) -> Void)? = { [weak self] status in
            let notConnection = status == .notConnection
            if notConnection{
                self?.infoText = Constant.checkInternet
                // notConnection = false
            }
        }
        
        Reachability.instance.networkStatusBlock = { status in
            updateLoginInfo?(status)
        }
        updateLoginInfo?(Reachability.instance.networkConnectionStatus())
        
    }
    */
    //MARK:- Refresh handler
    
    @objc func handleRefresh(){
        self.refreshDelegate?.refresh()
    }
    
    // MARK: - Handle errors
    func handleError(_ error: String?) {
        guard let error = error else {
            return
        }
        var infoText = error
        if error.contains("The Internet connection appears to be offline.")  {
            infoText = Constant.checkInternet
        }
        
        self.infoText = infoText
    }
    
    //MARK: - Validation helpers
    func isValid(userName: String?,regulerExp:String) -> Bool {
        
        let characterSet = CharacterSet.whitespaces
        let trimmedText = userName?.trimmingCharacters(in: characterSet)
        let regularExtension = regulerExp
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExtension)
        let isValid = predicate.evaluate(with: trimmedText)
        return isValid
        
    }
    
    // MARK: UI/UX Functions
    func setupBackgroundView() {
        view.backgroundColor = .clear
        view.insertSubview(backgroundView, at: 0)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
    }
    
    // Show Activity Indicator
    func showActivityIndicator(view:UIView) {
        
        DispatchQueue.main.async {
            
            Indicator.shared.showProgressView(view)
        }
    }
    
    // Hide Activity Indicator
    func hideActivityIndicator() {
        
        DispatchQueue.main.async {
            
            Indicator.shared.hideProgressView()
        }
    }
    
    // MARK: Drag dismiss function
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            
            viewTranslation = sender.translation(in: view)
            if viewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
        case .ended:
            if viewTranslation.y < 100 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc func actionContinue() {
        print("No one can stop me.")
    }
    
    func backViewController() -> UIViewController {
        let numberOfViewControllers: Int = self.navigationController!.viewControllers.count
        if numberOfViewControllers >= 2 {
            return self.navigationController!.viewControllers[numberOfViewControllers - 2]
        }
        return self.navigationController!.viewControllers[numberOfViewControllers-1]
    }
    
    func setupNavigationBarTitle(_ title: String, leftBarButtonsType: [UINavigationBarButtonType], rightBarButtonsType: [UINavigationBarButtonType], titleViewFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 44)) {
        
        self.title = comClass.createString(Str: title) 
        var rightBarButtonItems = [UIBarButtonItem]()
        for rightButtonType in rightBarButtonsType {
            let rightButtonItem = getBarButtonItem(for: rightButtonType, isLeftBarButtonItem: false)
            rightBarButtonItems.append(rightButtonItem)
        }
        if rightBarButtonItems.count > 0 {
            self.navigationItem.rightBarButtonItems = rightBarButtonItems
        }
        var leftBarButtonItems = [UIBarButtonItem]()
        for leftButtonType in leftBarButtonsType {
            let leftButtonItem = getBarButtonItem(for: leftButtonType, isLeftBarButtonItem: true)
            leftBarButtonItems.append(leftButtonItem)
        }
        if leftBarButtonItems.count > 0 {
            self.navigationItem.leftBarButtonItems = leftBarButtonItems
        }
        
        
    }
    
    //MARK:-Show and Hide UiElements
    
    func showHideView(view:[UIView],hide:Bool){
        
        for view in view{
            
            view.isHidden = hide
        }
        
    }
    
    func addDoneButtonOnKeyboard(txtFld : [UITextField])
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        done.tintColor = AppColor.whiteColor
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        doneToolbar.backgroundColor = AppColor.appColor
        //self.textView.inputAccessoryView = doneToolbar
        
        for txtfld in txtFld{
            
            txtfld.inputAccessoryView = doneToolbar
        }
        
    }
    
    @objc func doneButtonAction()
    {
        view.endEditing(true)
        // self.textViewDescription.resignFirstResponder()
    }
    
    func getBarButtonItem(for type: UINavigationBarButtonType, isLeftBarButtonItem: Bool) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Int(navButtonWidth), height: NAVIGATION_BAR_DEFAULT_HEIGHT))
        button.setTitleColor(.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.init(name: "Kefa Regular", size: 10)
        button.titleLabel?.textAlignment = .right
        button.tag = type.rawValue
        button.contentHorizontalAlignment = .leading
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: isLeftBarButtonItem ? edgeInset : -edgeInset)
        if let iconImage = type.iconImage {
            if type == .back{
                button.setImage(Localize.currentLanguage() == "en" ? UIImage(named: "back1") : UIImage(named: "back1"), for: UIControl.State())
            }else{
                button.setImage(iconImage, for: UIControl.State())
            }
        }
        button.addTarget(self, action: #selector(ParentViewController.navigationButtonTapped(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    func addColorToNavigationBarAndSafeArea(color:CAGradientLayer,className:String){
        
//        subControllerName = className
//        ScreeNNameClass.shareScreenInstance.screenName = subControllerName
        
        
    }
    
    func fontAndColor(lbl:[UILabel],text:[String])  {
        
        for i in 0..<lbl.count{
            lbl[i].font = AppFont.Regular.size(AppFontName.poppins, size: 17)
            lbl[i].textColor = AppColor.textColor
            lbl[i].text = text[i]
            lbl[i].textAlignment =  Localize.currentLanguage() == "ar" ? .right : .left
        }
        
    }
    
    func transparentNavigation(){
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: #colorLiteral(red: 0.1411764706, green: 0.6941176471, blue: 0.7490196078, alpha: 1)), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage(color: #colorLiteral(red: 0.1411764706, green: 0.6941176471, blue: 0.7490196078, alpha: 1))
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func nontransparentNavigation(){
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: #colorLiteral(red: 0.1411764706, green: 0.6941176471, blue: 0.7490196078, alpha: 1)), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage(color: #colorLiteral(red: 0.1411764706, green: 0.6941176471, blue: 0.7490196078, alpha: 1))
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func navigationButtonTapped(_ sender: AnyObject) {
        guard let buttonType = UINavigationBarButtonType(rawValue: sender.tag) else { return }
        switch buttonType {
        case .back: backButtonTapped()
        case .cross: crossButtonTapped()
        case .done: doneButtonTapped()
        case .add:addButtonTapped()
        case .location:locationButtonTapped()
        case .show: showButtonTapped()
        case .logout: logoutTapped()
        case .menu: menuTapped()
        case .cart: searchTapped()
        case .search: searchTapped()
            
        }
        //self.baseDelegate?.navigationBarButtonDidTapped(buttonType)
    }
    
    func backButtonTapped() {
        
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func crossButtonTapped() {
        self.backButtonTapped()
    }
    
    func menuTapped() {
        //   kAppDelegate.openDrawer1()
    }
    
    func searchTapped() {
        
        self.delagateSearch?.serachTap()
        
    }
    
    // =====  TextField Padding ======
    func configureView(txtFld:[UITextField]){
        
        for txtFld in txtFld{
            let paddingPhoneNumber = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: txtFld.frame.height))
            if Localize.currentLanguage() == "en" {
                txtFld.leftView = paddingPhoneNumber
                txtFld.leftViewMode = UITextField.ViewMode.always
            }else{
                txtFld.rightView = paddingPhoneNumber
                txtFld.rightViewMode = UITextField.ViewMode.always
            }
            
        }
        
    }
    
    // =====TextField Font Size Color =====
    
    func txtFldFontSizeConfig(txtFld:[UITextField],placeHolderText:[UINaming]){
        
        for i in 0..<txtFld.count{
            
            txtFld[i].placeholder = placeHolderText[i].name
            txtFld[i].font = AppFont.Regular.size(AppFontName.poppins, size: 17)
            txtFld[i].textColor = AppColor.textColor
            Localize.currentLanguage() == "en" ? (txtFld[i].textAlignment = .left) : (txtFld[i].textAlignment = .right)
        }
        
    }
    
    // ===== Lable Font Size Color =====
    
    open func setupLable(_ title: [String],_ lbl: [UILabel],_ aliment: [NSTextAlignment],_ font: [AppFont],_ size: [CGFloat]){
        
        for i in 0..<lbl.count{
            lbl[i].text = comClass.createString(Str: title[i])
            lbl[i].textAlignment = aliment[i]
            
            lbl[i].font = font[i].with(fontName: .poppins, size[i])
            
            //lbl[i].font = (font[i] == AppFont.Regular.rawValue) ? AppFont.Regular.size(AppFontName.SFPro, size: size[i]):AppFont.Bold.size(AppFontName.SFPro, size: size[i])
        }
    }
    
    open func setupTxtFld(_ title: [String],_ txt: [UITextField],_ aliment: [NSTextAlignment],_ font: [AppFont],_ size: [CGFloat]){
        
        for i in 0..<txt.count{
            txt[i].placeholder = comClass.createString(Str: title[i])
            txt[i].textAlignment = aliment[i]
            txt[i].font = font[i].with(fontName: .poppins, size[i])
            //txt[i].font = (font[i] == AppFont.Regular.rawValue) ? AppFont.Regular.size(AppFontName.SFPro, size: size[i]):AppFont.Bold.size(AppFontName.SFPro, size: size[i])
        }
    }
    
    
    
    open func provideAttributedTextToControlLeftAllignCenter(_ title:String, _ subtitle:String,_ titleFont:UIFont,_ subtitleFont:UIFont,_ titleColor:UIColor,_ subtitleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor,.font:subtitleFont])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    // func for attribute string muti value
    open func strAtributeString(_ title:[String], _ subtitle:[String],_ titleFont:UIFont,_ subtitleFont:UIFont,_ titleColor:UIColor,_ subtitleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor,.font:subtitleFont])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    
    // ====== Button Font Size Color =====
    
    func setDataOnButton(btn:[UIButton],text:[UINaming],textcolor:[UIColor]){
        
        for i in 0..<btn.count{
            
            btn[i].setTitle(text[i].name, for: .normal)
            btn[i].setTitleColor(textcolor[i], for: .normal)
            if text[i] == .forgotPass{
                btn[i].titleLabel?.font = AppFont.Regular.size(AppFontName.poppins, size: 17)
            }else if text[i] == .CWDB || text[i] == .CWP{
                
                btn[i].titleLabel?.font = AppFont.Bold.size(AppFontName.poppins, size: 14)
            }else if text[i] == .paymentIssue || text[i] == .providerChange || text[i] == .otherReason || text[i] == .changeMind {
                btn[i].titleLabel?.font = AppFont.Regular.size(AppFontName.poppins, size: 16)
                
            } else{
                btn[i].titleLabel?.font = AppFont.Bold.size(AppFontName.poppins, size: 17)
            }
            btn[i].contentHorizontalAlignment = .center
        }
        
    }
    
    func doneButtonTapped() {
        
    }
    
    func addButtonTapped() {
        
    }
    
    func locationButtonTapped() {
        
    }
    
    func showButtonTapped() {
        
    }
    
    func unFavouriteTapped() {
        
    }
    
    func favouriteTapped() {
        
    }
    
    func logoutTapped() {
        
        self.delagateSearch?.serachTap()
    }
    
    @available(iOS, deprecated: 9.0)
    func hideStatusBar(_ hide: Bool) {
        UIApplication.shared.setStatusBarHidden(hide, with: .none)
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.isHidden = hide
    }
    
    func hideNavigationBar(_ hide: Bool) {
        self.navigationController?.setNavigationBarHidden(hide, animated: false)
    }
    
    func goBackToIndex(_ backIndex: Int) {
        //self.goBackToIndex(backIndex, animated: true)
        
        //kAppDelegate.openDrawer()
    }
    
    func goBackToIndex(_ backIndex: Int, animated animate: Bool) {
        if (self.navigationController!.viewControllers.count - backIndex) > 0 {
            let controller: ParentViewController = (self.navigationController!.viewControllers[(self.navigationController!.viewControllers.count - 1 - backIndex)] as! ParentViewController)
            self.navigationController!.popToViewController(controller, animated: animate)
        }
    }
    
    //Get indexpath for tableview
    func getIndexPathFor(sender : AnyObject, tblView : UITableView) -> NSIndexPath? {
        let rect : CGRect = sender.convert(sender.bounds, to: tblView)
        if let indexPath  = tblView.indexPathForRow(at: rect.origin) {
            return indexPath as NSIndexPath?;
        }
        return nil
    }
    
    func addDoneButtonOnKeyboard( textfield : UITextField) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: MAIN_SCREEN_WIDTH, height: 50))
        let doneToolbar: UIToolbar = UIToolbar(frame: rect)
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title:"Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(tapDone(sender:)))
        doneToolbar.items = [done , flexSpace]
        doneToolbar.sizeToFit()
        textfield.inputAccessoryView = doneToolbar
    }
    
    @objc func tapDone(sender : UIButton) {
        view.endEditing(true)
    }
    
    //    func getInfoById() -> UserDataModel {
    //        let realm = try! Realm()
    //        let scope = realm.objects(UserDataModel.self)
    //        return scope.first!
    //    }
    //
    
    
    
    
    
    func addSwipGesture(view:UIView){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                self.dismiss(animated: true, completion: nil)
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func alert(message : String)
    {
        let  alert = UIAlertController(title: CommonClass.sharedInstance.createString(Str: "QuizLock"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonClass.sharedInstance.createString(Str: "OK"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertWithHandler(message : String , block:  @escaping ()->Void ){
        
        let  alert = UIAlertController(title: CommonClass.sharedInstance.createString(Str: "QuizLock"), message: CommonClass.sharedInstance.createString(Str: message), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: CommonClass.sharedInstance.createString(Str: "OK"), style: .default, handler: {(action : UIAlertAction) in
            
            block()
            
        }))
        alert.view.backgroundColor = .clear
        self.present(alert, animated: true, completion: nil)
        
    }
    func alertWithHandler2(message : String,block_Yes:  @escaping ()->Void){
        
        let alertController = UIAlertController(title:CommonClass.sharedInstance.createString(Str: "QuizLock"), message: message, preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: comClass.createString(Str: "Yes"), style: .default) { (action:UIAlertAction!) in
            
            
            block_Yes()
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: comClass.createString(Str: "No"), style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // alertController.view.backgroundColor = AppColor.appColor
        // Present Dialog message
        
        self.present(alertController, animated: true, completion:nil)
    }
    //    func showWarningMessageView(_ view:UIView? = nil,_ message:String? = nil) -> WarningMessageView{
    //
    //        self.infoWindow.removeFromSuperview()
    //        self.infoWindow = loadWarningNiB()
    //        self.infoWindow.message = message
    //        // Configure UI properties of info window
    //        infoWindow.tranView.alpha = 0.7
    //        infoWindow.layer.cornerRadius = 20
    //        infoWindow.layer.borderWidth = 2
    //        infoWindow.shadowRadius = 20
    //        infoWindow.shadowOffset = CGSize(width: 60, height: 60)
    //        infoWindow.shadowColor = .black
    //        infoWindow.shadowOpacity = 0.6
    //
    //        //Configure Offset
    //        infoWindow.center = view?.center ?? CGPoint()
    //        view?.addSubview(infoWindow)
    //        return infoWindow
    //    }
    //
    //    // MARK: Needed to create the custom info window (this is optional)
    //    func loadWarningNiB() -> WarningMessageView{
    //        let infoWindow = WarningMessageView.instanceFromNib() as! WarningMessageView
    //        return infoWindow
    //    }
    
    //MARK:- Add Blur View
    @available(iOS 13.0, *)
    func blurView(){
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        blurView.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: view.bounds.height)
    }
    func addBlurOnView(view:UIView){
        
        //        if #available(iOS 13.0, *) {
        //            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
        //            let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //            blurEffectView.frame = view.bounds
        //            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //            view.insertSubview(blurEffectView, at: 0)
        //        } else {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        //  }
        
    }
    func transparentView(){
        let view = UIView(frame: CGRect(x: 0, y: 40, width: self.view.bounds.width, height: self.view.bounds.height))
        view.backgroundColor = .black
        view.alpha = 0.5
        view.layer.cornerRadius = 20
        self.view.insertSubview(view, at: 0)
    }
}

//MARK: - Screen sizes
extension UIDevice {
    var iPhoneX: Bool {
        //  UIScreen.main.nativeBounds.height == 2436
        return true
    }
    var iPhone: Bool {
        // UIDevice.current.userInterfaceIdiom == .phone
        return true
    }
    
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        default:
            return .unknown
        }
    }
    
}


protocol serachTapDelegate {
    
    func serachTap()
    
}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
//MARK:- Current Lcoation
//MARK:-

extension ParentViewController{
    
    func initializeTheLocationManager()
    {        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        
        self.lat = location?.latitude.description ?? ""
        self.long = location?.longitude.description ?? ""
        if self.CountryCode == ""{
            self.printAddress(location?.latitude ?? 0.0, location?.longitude ?? 0.0)
        }
        //self.printAddress(location?.latitude ?? 0.0, location?.longitude ?? 0.0)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func printAddress(_ lat:Double,_  long:Double) {
        //      if let lat = Double(30.710489), lat != 0.0, let long = Double(76.852386), long != 0.0 {
        // Create Location
        let location = CLLocation(latitude: lat, longitude: long)
        // Geocode Location
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        // }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        var address = ""
        if let error = error {
            address = "Unable to Reverse Geocode Location (\(error))"
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                address = placemark.compactAddress ?? ""
            } else {
                address = "No address found"
            }
        }
        self.CountryCode = address
        print(address)
    }
}
extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = ""
            
//            if let street = thoroughfare {
//                result += ", \(street)"
//            }
//            if let city = locality {
//                result += ", \(city)"
//            }
//            if let postalCode = postalCode {
//                result += ", \(postalCode)"
//            }
//            if let country = country {
//                result += ", \(country)"
//            }
            if let countryCode = isoCountryCode {
                result += "\(countryCode)"
            }
            return result
        }
        
        return nil
    }
}
