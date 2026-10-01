//
//  AppDelegate.swift
//  DoctorLive
//
//  Created by User on 10/08/21.
//

import UIKit
import KYDrawerController

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var pushNotification: PushNotification?
    let gcmMessageIDKey = "DRLive_Doctor.message"
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: UIScreen.main.bounds.width - 75)
    var nvc : UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BookingTimerManager.shared.fetchTimers()
        self.keys()
        self.setUpViews()
        application.registerForRemoteNotifications()
        pushNotification = PushNotification(application: application)
        USER_DEFAULTS.set(false, forKey: PUSHUD.chatNotification)
        Thread.sleep(forTimeInterval: 3)
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
}
