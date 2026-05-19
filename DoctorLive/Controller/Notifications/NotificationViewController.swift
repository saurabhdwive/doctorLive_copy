//
//  NotificationViewController.swift
//  DoctorLive
//
//  Created by cst on 29/10/21.
//

import UIKit
import PromiseKit
import SideMenu

class NotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var notificationTitle: UILabel!
    var myNotificationArray:[Mynotification] = []
    var notificationId = String()
    var notificationRead: Bool?
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        notificationTitle.text = "Notifications".localized()
        self.performNotification()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "SideMenuNavigationController")
                 show(secondVC, sender: self)
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
 }

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNotificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.messageTxt.text = myNotificationArray[indexPath.row].message
        cell.dateTxt.text = myNotificationArray[indexPath.row].date
        cell.timeTxt.text = myNotificationArray[indexPath.row].time
        if notificationRead == true {
            cell.notificationReadImage.image = UIImage(named: "noun_doubleBlue")
        } else {
            cell.notificationReadImage.image = UIImage(named: "noun_double check_-1")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.notificationId = myNotificationArray[indexPath.row].id ?? ""
        if myNotificationArray[indexPath.row].type == "payment" {
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
            vc.isCameScreen = "Payment"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if myNotificationArray[indexPath.row].type == "addbooking" {
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if myNotificationArray[indexPath.row].type == "cancel" {
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
            vc.isCameScreen = "ChatScreen"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let appDel = UIApplication.shared.delegate as! AppDelegate
             _ = appDel.initHome()
        }
        performNotificationRead()
    }
}

extension NotificationViewController {
    func myWidhraw(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.NotificationList(parameters: param, header: "DeviceToken")
        }.done { (model: NotificationListModel) in
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
    
    func performNotification() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
         myWidhraw(param: parameter)
    }
    
    func myWidhrawResponse(model: NotificationListModel) {
        if model.status == "SUCCESS" {
            self.myNotificationArray = model.mynotification ?? [Mynotification]()
            self.tableView.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension NotificationViewController {
    func notificationRead(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.notificationRead(parameters: param, header: "DeviceToken")
        }.done { (model: NotificationListModel) in
            self.notificationReadStatus(model: model)
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
    
    func performNotificationRead() {
        var parameter = [String: String]()
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "id": self.notificationId]
        notificationRead(param: parameter)
    }
    
    func notificationReadStatus(model: NotificationListModel) {
        if model.status == "SUCCESS" {
            self.notificationRead = true
          LoaderController.sharedInstance.removeLoader()
        } else {
            LoaderController.sharedInstance.removeLoader()
        }
    }
}
