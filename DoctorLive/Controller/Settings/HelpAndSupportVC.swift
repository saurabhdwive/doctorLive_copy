//
//  HelpAndSupportVC.swift
//  DoctorLive
//
//  Created by cst on 08/10/21.
//

import UIKit
import MessageUI
import Mobilisten
import SideMenu

class HelpAndSupportVC: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var helpCenterTxt: UILabel!
    @IBOutlet weak var chatWithAdmin: UILabel!
    @IBOutlet weak var helpTxt: UILabel!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var helpCenter: UIStackView!
    @IBOutlet weak var notificationCountTxt: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    let count = UserDefaults.standard.integer(forKey: "notificationCount")
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        writeButton.layer.cornerRadius = 15
        callButton.layer.cornerRadius = 15
        callButton.isHidden = true
        writeButton.isHidden = true
        mainViewHeight.constant = 60
        stackHeight.constant = 60
        chatWithAdmin.dropShadow(scale: true)
        mainView.dropShadow(scale: true)
        chatView.dropShadow(scale: true)
        helpCenterTxt.text = "Help Center".localized()
        chatWithAdmin.text = "Chat With Admin".localized()
        helpTxt.text = "Help & Support".localized()
        callButton.setTitle("Call Us".localized(), for: .normal)
        writeButton.setTitle("Write Us".localized(), for: .normal)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationCountTxt.text = String(count)
        ZohoSalesIQ.showLauncher(false)
    }
    @IBAction func chatWithAdmin(_ sender: Any) {
        let vc = ChatWithAdminVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        guard let number = URL(string: "tel://" + "+8801765750808") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func helpCenterTaped(_ sender: Any) {
        mainButton.isSelected = !mainButton.isSelected
        if mainButton.isSelected{
            mainViewHeight.constant = 130
            stackHeight.constant = 130
            callButton.isHidden = false
            writeButton.isHidden = false
        }else{
            mainViewHeight.constant = 60
            stackHeight.constant = 60
            callButton.isHidden = true
            writeButton.isHidden = true
        }
    }
    
    @IBAction func writeButtonTapped(_ sender: Any) {
        let email = "care@incubex.ltd"
        let appURL = URL(string: "mailto:\(email)")!
         if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL)
        }
    }
    

    
    
    @IBAction func menuButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
       // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationButton(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["care@incubex.ltd"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
           
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
}
