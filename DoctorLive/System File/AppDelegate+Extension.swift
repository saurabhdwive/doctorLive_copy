//
//  AppDelegate+Extension.swift
//  DoctorLive
//
//  Created by Kv on 08/11/24.
//

import Foundation
import IQKeyboardManagerSwift
import Mobilisten
import UIKit
import GoogleMaps
import GooglePlaces

import Firebase
import PromiseKit
import FirebaseMessaging
import AVKit
import AVFoundation
import CoreLocation
import KYDrawerController

extension AppDelegate{
    func keys() {
        // AIzaSyCJj8cpjmnNmRVOwwUG2pXw201bN5Mgy0s this key not used
        GMSServices.provideAPIKey(valueForAPIKey(named:""))
        GMSPlacesClient.provideAPIKey(valueForAPIKey(named:""))
        AWSS3Manager.shared.setupAmazonS3(withPoolID: "us-east-2:8fb2a7c1-8bb8-47cb-adc3-826c0e97e43a")
        ZohoSalesIQ.initWithAppKey( "TEYczEZO8RUY7UwUzhzzFnkCGOaH%2Fttfw%2B3i%2FDmVC3tMf0gAKQHxTQ%3D%3D", accessKey:"umKBFEJYNuPwRDMv932IhfzrD7NAldJsd4LghsoSMJuz788tPaNP8xTJBYR6O%2B7B7Hmx%2Fbw%2BwthKaB0VnL%2B0LTB0PCzM9i3yr6grds2WmLIAiI2ZoeY8pEXzlY0C0SzVTHP93%2FhpJcZIrjR7OhZyDRPCANC9LnQa", completion:nil )
//        USER_DEFAULTS.set("pu5FEUcKf8KuI1lKdMZM", forKey: Constants.accessToken)
    }
    
    func setUpViews(){
        USER_DEFAULTS.set(false, forKey: "version_doctor")
        IQKeyboardManager.shared.enable = true
        SocketHelper.shared.connectSocket()
        self.registerNotificationCategories()
        self.cameraAccess()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true, options: [])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        service = Network()
        self.checkAutoLogin()
    }
    
    func registerNotificationCategories() {
        let openBoardAction = UNNotificationAction(identifier: UNNotificationDefaultActionIdentifier, title: "Open Board", options: UNNotificationActionOptions.foreground)
        let contentAddedCategory = UNNotificationCategory(identifier: "content_added_notification", actions: [openBoardAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([contentAddedCategory])
    }
}

extension AppDelegate: AVPictureInPictureControllerDelegate ,CLLocationManagerDelegate{
    func accessLocation(){
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func cameraAccess(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (videoGranted: Bool) -> Void in
            if (videoGranted) {
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (audioGranted: Bool) -> Void in
                    if (audioGranted) {
                        print("Both video & audio granted")
                        self.accessLocation()
                    } else {
                        self.accessLocation()
                    }
                })
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (audioGranted: Bool) -> Void in
                    if (audioGranted) {
                        print("Both video & audio granted")
                        self.accessLocation()
                    } else {
                        self.accessLocation()
                    }
                })
            }
        })
    }
}

extension AppDelegate{
    func checkAutoLogin() {
        let accuntStatus = UserDefaults.standard.bool(forKey: Constants.accountStatus)
        print(accuntStatus)
        if accuntStatus == true {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.initControllerrr(identifer: "HomeVC")
        } else {
            self.setLoginViewController()
        }
    }
    
    func setLoginViewController() {
        let viewC = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = viewC.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func initHome(notifyId: String? = nil) -> AppDelegate {
        let storyboardHome = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let homeVC = storyboardHome.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        homeVC.notifyId = notifyId
        let storyboardProfile = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let menuVC = storyboardProfile.instantiateViewController(withIdentifier: "SideMenuVC")
        let navigationController = UINavigationController(rootViewController: drawerController)
        self.drawerController.mainViewController = homeVC
        self.drawerController.drawerViewController = menuVC
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func initControllerrr(identifer: String) {
        let mainVC = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: identifer)
        let drawerVC = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        
        self.drawerController.mainViewController = mainVC
        if let _ = self.nvc{
            print("navi")
        } else {
            let navigationController = UINavigationController(rootViewController: drawerController)
            self.drawerController.drawerViewController = drawerVC
            self.nvc = navigationController
        }
        drawerController.setDrawerState(.closed, animated: true)
        self.nvc?.isNavigationBarHidden = true
        window?.rootViewController = self.nvc!
        window?.makeKeyAndVisible()
    }
    func pushToHome_VideoCall(identifer: String) -> KYDrawerController {
        drawerController.setDrawerState(.closed, animated: true)
        return self.drawerController
    }
    
//    func initDrawer(storyBoard:String,sendViewController: String) {
//        drawerController.setDrawerState(.opened, animated: true)
//        let mainVC = UIStoryboard.init(name: "\(storyBoard)", bundle: nil).instantiateViewController(withIdentifier: "\(sendViewController)")
//        let drawerVC = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
//        let navigationController = UINavigationController(rootViewController: drawerController)
//        self.drawerController.mainViewController = mainVC
//        self.drawerController.drawerViewController = drawerVC
//        navigationController.isNavigationBarHidden = true
//        self.window?.rootViewController = navigationController
//        self.window?.makeKeyAndVisible()
//    }
}

extension AppDelegate {
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
            let simulaterToken = "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            UserDefaults.standard.set(simulaterToken, forKey: Constants.deviceId)
            print("Error registering notifications: \(error)")
        }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.windows.first?.rootViewController }.first) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
