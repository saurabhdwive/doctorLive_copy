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
    
    var currentPage = 1
    var isLastPage = false
    var isFetching = false
    
    lazy var bottomLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 44)
        return loader
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        notificationTitle.text = "Notifications".localized()
        self.performNotification(isRefresh: true)
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
        if myNotificationArray[indexPath.row].notificationStatus == "0" {
            cell.notificationReadImage.image = UIImage(named: "noun_doubleBlue")
        } else {
            cell.notificationReadImage.image = UIImage(named: "noun_double check_-1")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.notificationId = myNotificationArray[indexPath.row].id ?? ""
        let type = myNotificationArray[indexPath.row].type
        let title = myNotificationArray[indexPath.row].title
        
        if type == "payment" {
//            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
//            vc.isCameScreen = "Payment"
//            self.navigationController?.pushViewController(vc, animated: true)
            let appDel = UIApplication.shared.delegate as! AppDelegate
             _ = appDel.initHome()
        } else if type == "addbooking" {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            _ = appDel.initHome()
        } else if type == "cancel" {
//            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
//            vc.isCameScreen = "ChatScreen"
//            self.navigationController?.pushViewController(vc, animated: true)
            let appDel = UIApplication.shared.delegate as! AppDelegate
             _ = appDel.initHome()
        } else if type == "NotificationPush" && title == "Payout update" {
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "MyEarningViewController") as! MyEarningViewController
            let vc = EarningViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let appDel = UIApplication.shared.delegate as! AppDelegate
             _ = appDel.initHome()
        }
        performNotificationRead()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.myNotificationArray.count - 1 && !isLastPage && !isFetching {
            self.currentPage += 1
            self.performNotification(isRefresh: false)
        }
    }
}

extension NotificationViewController {
    func myWidhraw(param: [String: String]){
        if currentPage == 1 {
            LoaderController.sharedInstance.showLoader(view: self.view)
        } else {
            self.tableView.tableFooterView = self.bottomLoader
            self.bottomLoader.startAnimating()
        }
        
        firstly {
            service!.NotificationList(parameters: param, header: "DeviceToken")
        }.done { (model: NotificationListModel) in
            self.myWidhrawResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
                self.isFetching = false
                self.bottomLoader.stopAnimating()
                self.tableView.tableFooterView = nil
            }
            
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
                self.isFetching = false
                self.bottomLoader.stopAnimating()
                self.tableView.tableFooterView = nil
            }
        }
    }
    
    func performNotification(isRefresh: Bool = false) {
        if isRefresh {
            currentPage = 1
            isLastPage = false
        }
        
        if isFetching { return }
        isFetching = true
        
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "page": "\(currentPage)"]
         myWidhraw(param: parameter)
    }
    
    func myWidhrawResponse(model: NotificationListModel) {
        if model.status == "SUCCESS" {
            let newItems = model.mynotification ?? [Mynotification]()
            
            if currentPage == 1 {
                self.myNotificationArray = newItems
            } else {
                self.myNotificationArray.append(contentsOf: newItems)
            }
            
            self.isLastPage = newItems.isEmpty
            self.tableView.reloadData()
        }
        
        LoaderController.sharedInstance.removeLoader()
        self.isFetching = false
        self.bottomLoader.stopAnimating()
        self.tableView.tableFooterView = nil
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
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "id": self.notificationId,
                     "token": token]
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
