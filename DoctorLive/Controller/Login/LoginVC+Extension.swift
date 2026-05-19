//
//  LoginVC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 05/09/24.
//

import Foundation
import ADCountryPicker
import UIKit

extension LoginVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == lblCountryCode {
            let pickerNavigationController = UINavigationController(rootViewController: picker)
            pickerNavigationController.modalTransitionStyle = .crossDissolve
            pickerNavigationController.modalPresentationStyle = .fullScreen
            self.present(pickerNavigationController, animated: true, completion: nil)
        }
            return true
        }
 
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        lblCountryCode.text = dialCode
        self.countryCodeNum = dialCode
        dismiss(animated: true, completion: nil)
    }
}

extension String{
    func replace(_ dictionary: [String: String]) -> String{
        var result = String()
        var i = -1
        for (of , with): (String, String)in dictionary{
            i += 1
            if i<1{
                result = self.replacingOccurrences(of: of, with: with)
            }else{
                result = result.replacingOccurrences(of: of, with: with)
            }
        }
        return result
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.cornerRadius = 10
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}



extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return count>self.count ? self : String(self[index(self.startIndex, offsetBy: count)...])
    }
}
