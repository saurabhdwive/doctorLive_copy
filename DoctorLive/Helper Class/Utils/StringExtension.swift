//
//  StringExtension.swift
//  Quizlok
//
//  Created by Inshad Ansari on 15/01/21.
//

import Foundation
extension String {
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    var isEmail:Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    var isBlank : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    ///Is Strong Password
    var isStrongPassword : Bool{
        let pattern = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$" //"^(?=.[a-z])(?=.[A-Z])(?=.[!\"#$%&'()+,-./:;<=>?@\\[\\\\\\]^`{|}~])(?=.\\d)[A-Za-z0-9 !\"#$%&'()+,-./:;<=>?@\\[\\\\\\]^`{|}~]{8,20}"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return passwordPredicate.evaluate(with: self)
    }
   
    func isContainEmoji() -> Bool {
        let isContain = unicodeScalars.first(where: { $0.isEmoji }) != nil
        return isContain
    }
    
    
    ///Removes all spaces from the string
    var removeSpaces:String{
        return self.replacingOccurrences(of: " ", with: "")
    }

    ///Removes all HTML Tags from the string
    var removeHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    ///Returns a localized string
//    var localized:String {
//        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//    }
    
    ///Removes leading and trailing white spaces from the string
    var byRemovingLeadingTrailingWhiteSpaces:String {
        
        let spaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: spaceSet)
    }
    
    public func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    ///Returns 'true' if the string is any (file, directory or remote etc) url otherwise returns 'false'
    var isAnyUrl:Bool{
        return (URL(string:self) != nil)
    }
    
    ///Returns the json object if the string can be converted into it, otherwise returns 'nil'
    var jsonObject:Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    ///Returns the base64Encoded string
    var base64Encoded:String {
        
        return Data(self.utf8).base64EncodedString()
    }
    
    ///Returns the string decoded from base64Encoded string
    var base64Decoded:String? {
        
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }


    
    ///Returns 'true' if string contains the substring, otherwise returns 'false'
    func contains(s: String) -> Bool
    {
        return self.range(of: s) != nil ? true : false
    }
    
    ///Replaces occurances of a string with the given another string
    func replace(string: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: string, with: withString, options: String.CompareOptions.literal, range: nil)
    }
    
    ///Converts the string into 'Date' if possible, based on the given date format and timezone. otherwise returns nil
    func toDate(dateFormat:String,timeZone:TimeZone = TimeZone.current)->Date?{
        
        let frmtr = DateFormatter()
//        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = dateFormat
//        frmtr.timeZone = timeZone
        return frmtr.date(from: self)
    }

//    func toDateText(inputDateFormat: String, outputDateFormat: String, timeZone: TimeZone = TimeZone.current) -> String{
//
//        if let date = self.toDate(dateFormat: inputDateFormat, timeZone: timeZone) {
//            return date.toString(dateFormat: outputDateFormat, timeZone: timeZone)
//        } else {
//            return ""
//        }
//    }

    func checkIfValid(_ validityExression : ValidityExression) -> Bool {
        
        let regEx = validityExression.rawValue
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return test.evaluate(with: self)
    }
    
    func checkIfInvalid(_ validityExression : ValidityExression) -> Bool {
        
        return !self.checkIfValid(validityExression)
    }
    
    ///Capitalize the very first letter of the sentence.
    var capitalizedFirst: String {
        guard !isEmpty else { return self }
        var result = self
        let substr1 = String(self[startIndex]).uppercased()
        result.replaceSubrange(...startIndex, with: substr1)
        return result
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}

//extension String {
//    
//    var html2AttributedString: NSAttributedString? {
//        return Data(utf8).html2AttributedString
//    }
//    var html2String: String {
//        return html2AttributedString?.string ?? self.removeHTMLTags
//    }
//}

enum ValidityExression : String {
    
    case userName = "^[a-zA-z]{1,}+[a-zA-z0-9!@#$%&*]{2,15}"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,}"
    case mobileNumber = "^[0-9]{6,20}$"
    case password = "^[a-zA-Z0-9!@#$%&*]{6,}"
    case name = "^[a-zA-Z]{2,15}"
    case webUrl = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
}



extension UnicodeScalar {
    
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F,
             0x1F300...0x1F5FF,
             0x1F680...0x1F6FF,
             0x1F1E6...0x1F1FF,
             0x2600...0x26FF,
             0x2700...0x27BF,
             0xFE00...0xFE0F,
             0x1F900...0x1F9FF,
             65024...65039,
             8400...8447,
             9100...9300,
             127000...127600:
            return true
        default:
            return false
        }
    }
}
