//
//  CustomStruct+Extension.swift
//  DoctorLive
//
//  Created by Kv on 06/09/24.
//

import Foundation
import UIKit

let EMPTY  = ""
let INTZERO = 0

class AppConfig: NSObject {
    class func appVersion() -> String {
        return MAIN_BUNDLE.object(forInfoDictionaryKey: "CFBundleShortVersionString")as! String
    }
    
}

extension NSObject{
    class var className : String {
        return String(describing: self)
    }
}


struct ForceUpdateAppVersion{
    static let shared = ForceUpdateAppVersion()
    func appUpdateAvailable() -> (Bool,String?) {
        guard let info = Bundle.main.infoDictionary,
              let identifier = info["CFBundleIdentifier"] as? String else {
            return (false,nil)
        }
        //                let storeInfoURL: String = "http://itunes.apple.com/lookupbundleId=\(identifier)&country=IN"
        let storeInfoURL:String = "https://itunes.apple.com/IN/lookup?bundleId=\(identifier)"
        var upgradeAvailable = false
        var versionAvailable = ""
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            let urlOnAppStore = NSURL(string: storeInfoURL)
            if let dataInJSON = NSData(contentsOf: urlOnAppStore! as URL) {
                if let dict: NSDictionary = try? JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
                    if let results:NSArray = dict["results"] as? NSArray {
                        if let version = (results[0] as! [String:Any])["version"] as? String {
                            let currentVersion = AppConfig.appVersion()
                            print("\(version)")
                            if version > currentVersion {
                                upgradeAvailable = true
                                versionAvailable = version
                            }
                        }
                    }
                }
            }
        }
        return (upgradeAvailable,versionAvailable)
    }
}

extension Notification.Name {
    
    static let didReceiveData = Notification.Name("didReceiveData")
    static let refereshCallData = Notification.Name("refereshCallData")
    
    //DOCTOR
    static let refereshDoctorData = Notification.Name("refereshDoctorData")
}

import QuartzCore

var CORNER_DIRECTION_LEFT: CACornerMask = .layerMinXMinYCorner
var CORNER_DIRECTION_RIGHT: CACornerMask = .layerMaxXMinYCorner
var CORNER_DIRECTION_BOTTOM_LEFT: CACornerMask = .layerMinXMaxYCorner
var CORNER_DIRECTION_BOTTOM_RIGHT: CACornerMask = .layerMaxXMaxYCorner
