//
//  AppMacro.swift
//  JustBite
//
//  Created by Aman on 04/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

let NOTIFICATION_CENTER = NotificationCenter.default
let FILE_MANAGER = FileManager.default
let MAIN_BUNDLE = Bundle.main
let MAIN_THREAD = Thread.main
let MAIN_SCREEN = UIScreen.main
let MAIN_SCREEN_WIDTH = UIScreen.main.bounds.width
let MAIN_SCREEN_HEIGHT = UIScreen.main.bounds.height
let USER_DEFAULTS = UserDefaults.standard
let APPLICATION = UIApplication.shared
let CURRENT_DEVICE = UIDevice.current
let MAIN_RUN_LOOP = RunLoop.main
let GENERAL_PASTEBOARD = UIPasteboard.general
let CURRENT_LANGUAGE = NSLocale.current.languageCode
//let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

let STATUS_BAR_DEFAULT_HEIGHT = 20
let NAVIGATION_BAR_DEFAULT_HEIGHT = 44
let TOOLBAR_DEFAULT_HEIGHT = 44
let TABBAR_DEFAULT_HEIGHT = 49
let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
let comClass = CommonClass.sharedInstance
// Network
let kNoInterNet = "No internet"
let kTokenExpireMessage = "Invalid Token"
let NETWORK_ACTIVITY = APPLICATION.isNetworkActivityIndicatorVisible

// Application informations

let APP_BUNDLE_NAME = MAIN_BUNDLE.infoDictionary?[kCFBundleNameKey as String]
let APP_NAME = "OWIN"
let APP_VERSION = MAIN_BUNDLE.object(forInfoDictionaryKey: "CFBundleVersion")

let IS_NEW_CODE = false
let gradientLayer = CAGradientLayer()
let _AUTO_SCROLL_ENABLED : Bool = false

