//
//  Utils.swift
//  AfriPayChat
//  Created by Ashok kumar on 3/5/21.
//  Copyright © 2020 Apponward Technologies Pvt Ltd. All rights reserved.
//

import UIKit

import Foundation

class Utils: UIViewController{
    static let shared = Utils()
    var switchMode: UISwitch!
    var dateFormat = DateFormatter()
    var sessionDataTask: URLSessionDataTask?
    
    func displayAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    func isValidUserNameString(emailString: String) -> Bool {
            if emailString == ""{
            }
            let emailRegularExpression = "^[a-zA-Z0-9]([@._-](?![@._-])|[a-zA-Z0-9]){2,14}[a-zA-Z0-9]$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegularExpression)
            let validEmail = emailPredicate.evaluate(with: emailString)
            return validEmail
    }
    
    func stringChangeTocolor(que: String) -> NSMutableAttributedString {
        
        let count = que.count
        
        let termsAndConditionString =  " \(que) "
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: termsAndConditionString, attributes: [NSAttributedString.Key.font: UIFont(name: "SF Pro Display", size: 25.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Utils.shared.hexStringToUIColor(hex: "#009EE2"), range: NSRange(location: 1, length: count))
        
        return myMutableString
    }
    
    func stringChangeToColorWith(que: String)-> NSMutableAttributedString {
        let count = que.count
        
        let termsAndConditionString =  " \(que) "
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: termsAndConditionString, attributes: [NSAttributedString.Key.font: UIFont(name: "SF Pro Display", size: 20.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Utils.shared.hexStringToUIColor(hex: "#FFFFFF"), range: NSRange(location: 1, length: count))
        myMutableString.addAttribute(NSAttributedString.Key.backgroundColor, value: Utils.shared.hexStringToUIColor(hex: "#009EE2"), range: NSRange(location: 1, length: 1))
        return myMutableString
    }
    
    func lightToDark(_ sender: UISwitch) {
        let name = Notification.Name("darkModeHasChanged")
        UserDefaults.standard.set(switchMode.isOn, forKey: "isDarkMode")
        NotificationCenter.default.post(name: name, object: nil)
        if !sender.isOn {
            switchMode.isOn = false
            struct Color {
                static let grey616161 = Utils.shared.hexStringToUIColor(hex: "#616161")
                static let grey7C7C7C = Utils.shared.hexStringToUIColor(hex: "#7C7C7C")
                static let skyblue009EE2 = Utils.shared.hexStringToUIColor(hex: "#009EE2")
                static let mainViewF2F2F2 = Utils.shared.hexStringToUIColor(hex: "#F2F2F2")
                static let nextButton0B9DE1 = Utils.shared.hexStringToUIColor(hex: "#0B9DE1")
                static let titleColur = Utils.shared.hexStringToUIColor(hex: "#000000CC")
                static let lineView = Utils.shared.hexStringToUIColor(hex: "#d5d5d5")
            }
            
        } else {
            struct Color {
                static let grey616161 = Utils.shared.hexStringToUIColor(hex: "#616161")
                static let grey7C7C7C = Utils.shared.hexStringToUIColor(hex: "#7C7C7C")
                static let skyblue009EE2 = Utils.shared.hexStringToUIColor(hex: "#009EE2")
                static let mainViewF2F2F2 = Utils.shared.hexStringToUIColor(hex: "#F2F2F2")
                static let nextButton0B9DE1 = Utils.shared.hexStringToUIColor(hex: "#0B9DE1")
                static let titleColur = Utils.shared.hexStringToUIColor(hex: "#000000CC")
                static let lineView = Utils.shared.hexStringToUIColor(hex: "#d5d5d5")
            }
        }
    }
    
    func isValidEmailString(emailString: String) -> Bool {
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegularExpression)
        let validEmail = emailPredicate.evaluate(with: emailString)
        return validEmail
        
    }
    
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
    }
    
    public func isValidPassword(passString: String) -> Bool {
        var validPass: Bool
                if passString.count >= 6 && passString.count <= 16 {
                    validPass = true
                }else{
                    validPass = false
                }
                return validPass
    }
       // let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
//        let passwordRegex = "^[A-Z]{1,10}{6,16}$"
//        let passPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        let validPass = passPredicate.evaluate(with: passString)
      //  return validPass
    
    
    func isValidDate(date: String) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if dateFormatter.date(from: date) != nil {
            return true
        } else {
            return false
        }
    }
    
    func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    func roundCorners(corners: UIRectCorner, radius: Int = 8, button: UIButton) {
        let maskPath1 = UIBezierPath(roundedRect: button.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = button.bounds
        maskLayer1.path = maskPath1.cgPath
        button.layer.mask = maskLayer1
    }

    func cheackSpecalCharacter(_ text: String) -> Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format: "SELF MATCHES %@", regex)
        return testString.evaluate(with: text)
    }
    
    func checkUpperCase(_ text: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Za-z0-9].*"
        let textString = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return textString.evaluate(with: text)
    }
    
    // MARK: - validation date of Birth
    func checkDateIsValid(year: String, month: String, day: String) -> Bool? {
        let finalDate = "\(year)-\(month)-\(day)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: finalDate) {
            print(date)
            return  true
        } else {
            return false
        }
    }
    // MARK: - validation TextFiled
   func getCountriesModels()->CountriesModel?{
        
        let path = Bundle.main.path(forResource: "countries-code", ofType: "json")
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            do {
                let countriesModel = try JSONDecoder().decode(CountriesModel.self, from: data)
                return countriesModel
            } catch {
                
            }
        } catch {
            // handle error
        }
        
        return nil
    }
    
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}
struct CountriesModel: Codable {
    let countries: [CountryModel]?
}
struct CountryModel: Codable {
    let name: String?
    let dialCode: String?
    let code: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }}

extension Int {
    func toString() -> String {
        let myString = String(self)
        return myString
        
    }
}

extension String {
    func toInt() -> Int {
        guard let myInt = Int(self) else { return 0 }
        return myInt
    }
}
