//
//  SettingViewController.swift
//  DoctorLive
//
//  Created by cst on 07/10/21.
//

import UIKit
import SideMenu

class SettingViewController: UIViewController {
    @IBOutlet weak var changePassTxt: UILabel!
    @IBOutlet weak var settingVc: UILabel!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var privacyPilicy: UIView!
    @IBOutlet weak var changeLanguage: UIView!
    @IBOutlet weak var termAndCondition, aboutUsLable: UILabel!
    @IBOutlet weak var privacyPolicy: UILabel!
    @IBOutlet weak var chnageLng: UILabel!
    @IBOutlet weak var aboutUs: UIView!
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        changePassTxt.text = "Change Password".localized()
        termAndCondition.text = "Terms & Conditions".localized()
        privacyPolicy.text = "Privacy Policy".localized()
        aboutUsLable.text = "About Us".localized()
        chnageLng.text = "Change Language".localized()
        settingVc.text = "Settings".localized()
        changeLanguage.isHidden = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func setupUi() {
        changePasswordView.dropShadow(scale: true)
        termsView.dropShadow(scale: true)
        privacyPilicy.dropShadow(scale: true)
        aboutUs.dropShadow(scale: true)
        changeLanguage.dropShadow(scale: true)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func termsButton(_ sender: Any) {
        let vc = TermsAndConditionViewController()
        vc.urlString = "https://doctorlivebd.com/api/user/terms"
        vc.titleTxt = "Terms And Conditions".localized()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
        let vc = TermsAndConditionViewController()
        vc.urlString = "https://doctorlivebd.com/api/user/privacy"
        vc.titleTxt = "Privacy Policy".localized()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func faqsTapped(_ sender: Any) {
        let vc = TermsAndConditionViewController()
        vc.urlString = "https://doctorlivebd.com/api/doctor/aboutus"
        vc.titleTxt = "About Us".localized()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func langaugeTapped(_ sender: Any) {
        let view = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = view.instantiateViewController(withIdentifier: "SelectLanguageVC") as! SelectLanguageVC
        vc.languageChange = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
       // self.navigationController?.popViewController(animated: true)
    }
}
