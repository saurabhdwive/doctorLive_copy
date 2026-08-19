//
//  PushNotification.swift
//  E-RX
//
//  Created by SinhaAirBook on 11/07/20.
//  Copyright © 2020 macbook. All rights reserved.
//
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import KYDrawerController

enum NotificationRedirection : String {
    case addbooking = "addbooking"
    case payment = "payment"
    case chat = "chat"
    case cancelled = "cancelled"
    case DashboardAccessRequest = "dashboardAccReq"
    case AccessRequestRejected = "dashboardAccRej"
    case AccessRequestAccepted = "dashboardAccAcc"
    case AcceptedAppointment = "appAccept"
    case RejectedAppointment = "appCancel"
    case CompletedAppointment = "appComplete"
}

struct PUSHUD {
    
    //MESSAGE
    
    static let sender              =      "sender"
    static let reciever            =      "reciever"
    static let senderProfilePic    =      "senderProfilePic"
    static let reciverProfilePic   =      "reciverProfilePic"
    static let chatType            =      "chatType"
    static let senderProfileName   =      "senderProfileName"
    static let reciverProfileName  =      "reciverProfileName"
    static let roomId              =      "roomId"
    static let comeFromPush        =      "comeFromPush"
    static let chatNotification    =      "chatNotification"
    static let patientName         =      "patientName"
    
}

class PushNotification:NSObject, UNUserNotificationCenterDelegate,MessagingDelegate {
    var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: UIScreen.main.bounds.width - 75)
    var window: UIWindow?
    public init(application:UIApplication) {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(
            options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            print("Notification granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.clearNotification()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("User Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func userNotification(message: String, title: String, count: Int){
        //creating the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = ""
        content.body = message
        content.badge = count as NSNumber
        //getting the notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func clearNotification(){
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        let notifications =  UNUserNotificationCenter.current()
        notifications.removeAllPendingNotificationRequests()
        notifications.removeAllDeliveredNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String:Any] {
            print(userInfo)
            
            if let apsDict = userInfo["aps"] as?NSDictionary {
                let badge = apsDict.value(forKey: "badge") as? Int ?? 0
                if (userInfo["type"] ?? EMPTY) as! String == "chat"{
                    if USER_DEFAULTS.bool(forKey: PUSHUD.chatNotification){
                        completionHandler([])
                    }else{
                        completionHandler([.alert, .badge, .sound])
                    }
                    
                }else{
                    UIApplication.shared.applicationIconBadgeNumber = badge
                    NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("RefreshScreen"), object: nil)
                    completionHandler([.alert,.badge,.sound])
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        if let userInfo = response.notification.request.content.userInfo as? [String:Any] {
            if (userInfo["aps"] as?NSDictionary) != nil {
                let badge = userInfo["badge"] as? Int ?? 0
                UIApplication.shared.applicationIconBadgeNumber = badge
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                if userInfo["type"] as? String == "chat" {
                    USER_DEFAULTS.set(userInfo["sender_id"] as! String, forKey: PUSHUD.reciever)
                    USER_DEFAULTS.set(userInfo["room_id"] as! String, forKey: PUSHUD.roomId)
                    USER_DEFAULTS.set(userInfo["image"] as! String, forKey: PUSHUD.reciverProfilePic)
                    USER_DEFAULTS.set(userInfo["userName"] as! String, forKey: PUSHUD.reciverProfileName)
                    USER_DEFAULTS.set(userInfo["type"] as! String, forKey: PUSHUD.chatType)
                    USER_DEFAULTS.set(true, forKey: PUSHUD.comeFromPush)
                    DIConfigurator.sharedInst().getRootViewC(.Auth, identifer: ChatViewC.className)
                }else if let type = userInfo["notification_type"] as? String {
                    self.notificationTapped(notificationType: type)
                }else if let type = userInfo["type"] as? String{
                    self.notificationTapped(notificationType: type)
                }
                completionHandler()
            }

        }
    }
    
    func notificationTapped(notificationType: String) {
        if notificationType.lowercased() == "doctor" {
            let viewC = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc1 = viewC.instantiateViewController(withIdentifier: "MyEarningViewController") as! MyEarningViewController
            let navigationController = UINavigationController(rootViewController: drawerController)
            navigationController.viewControllers.append(vc1)
            navigationController.navigationBar.isHidden = true
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            _ = appDel.initHome()
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.set(fcmToken, forKey: Constants.deviceId)
    }
    
    func paymentAccepted() {
        let viewC = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc1 = viewC.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
        vc1.isCameScreen = "Payment"
        let navigationController = UINavigationController(rootViewController: drawerController)
        navigationController.viewControllers.append(vc1)
        navigationController.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func bookingCancel() {
        let viewC = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc1 = viewC.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
        vc1.isCameScreen = "ChatScreen"
        let navigationController = UINavigationController(rootViewController: drawerController)
        navigationController.viewControllers.append(vc1)
        navigationController.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func bookingRecieved() {
        let viewC = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc1 = viewC.instantiateViewController(withIdentifier: "UpcomingBookingVC") as! UpcomingBookingVC
        vc1.isCameScreen = "Booking"
        let navigationController = UINavigationController(rootViewController: drawerController)
        navigationController.viewControllers.append(vc1)
        navigationController.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
