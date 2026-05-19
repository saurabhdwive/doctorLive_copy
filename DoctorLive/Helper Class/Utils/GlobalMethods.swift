
//
//  GlobalMethod.swift
//  Helper Class
//
//  Created by Krishanvir on 29/03/22.
//

import Foundation
import UIKit

//extension UIViewController {
//    func show_Alert(message: String, title: String = APP_NAME) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(OKAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
//    func alertWithHandler(message : String , block:  @escaping ()->Void ){
//        
//        let  alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action : UIAlertAction) in
//            
//            block()
//            
//        }))
//        
//        
//        self.present(alert, animated: true, completion: nil)
//        
//    }
//    
//    
//    func show_Alert_PushToAnotherVC_Action(message: String, title: String, VC_Identifier: String) {
//        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//            print("Handle Ok logic here")
//            let storyBrd = UIStoryboard(name: "Home", bundle: nil)
//            
//            let vc = storyBrd.instantiateViewController(withIdentifier: VC_Identifier)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }))
//        
//        present(refreshAlert, animated: true, completion: nil)
//    }
//}

//MARK: -  corner radius methods
class GlobalMethods{
    static let shared = GlobalMethods()
    //TODO: Provide corner radius method implementation
    func provideCornerRadius(view: UIView, cornerRadius: CGFloat, borderColor: CGColor, borderWidth: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor
        view.layer.borderWidth = borderWidth
        view.clipsToBounds = true
    }
    func provideShadow1(view: UIView, shadowColor: CGColor, shadowOpacity: CGFloat, shadowOffset: CGSize, shadowRadius: CGFloat) {
        view.layer.shadowColor = shadowColor
        view.layer.shadowOpacity = Float(shadowOpacity)
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowRadius = shadowRadius
        view.layer.cornerRadius = shadowRadius
        
    }
    //TODO: Provide shadow method implementation
    func provideShadow(view: UIView, shadowColor: CGColor, shadowOpacity: CGFloat, shadowOffset: CGSize , shadowPath: UIBezierPath) {
        view.layer.shadowColor = shadowColor
        view.layer.shadowOpacity = Float(shadowOpacity)
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowPath = shadowPath.cgPath
    }
    //TODO: Provide three corner radius method implementation
    func provideThreeCornerRadius(view:UIView,cornerRadius:CGFloat,cornerArray:CACornerMask) {
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = cornerArray
    }
    
    //TODO: -- Show Alert Message ---
    func alert(title:String, msg:String, target: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            (result: UIAlertAction) -> Void in
        })
        target.present(alert, animated: true, completion: nil)
    }
    
    func provideShadowMultipleView(vw: [UIView], shadowColor: CGColor, shadowOpacity: CGFloat, shadowOffset: CGSize, shadowRadius: CGFloat){
        for view in vw {
            provideShadow1(view: view, shadowColor: shadowColor, shadowOpacity: shadowOpacity, shadowOffset: shadowOffset, shadowRadius: shadowRadius)
        }
    }
    
     func provideCornerRadiusMultipleView(vw: [UIView],cornerRadius: CGFloat, borderColor: CGColor, borderWidth: CGFloat){
        for view in vw {
            GlobalMethods.shared.provideCornerRadius(view: view, cornerRadius: cornerRadius, borderColor: borderColor, borderWidth: borderWidth)
        }
    }
      
    func provideAttributedTextToControlRightAllign(_ title:String, _ subtitle:String,_ titleFont:UIFont,_ subtitleFont:UIFont,_ titleColor:UIColor,_ subtitleColor:UIColor,_ delem:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delem)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor,.font:subtitleFont])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .right
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    func provideAttributedTextToControlLeftAllign(_ title:String, _ subtitle:String,_ titleFont:UIFont,_ subtitleFont:UIFont,_ titleColor:UIColor,_ subtitleColor:UIColor,_ delem:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delem)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor,.font:subtitleFont])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .left
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    func provideAttributedTextToControlLeftAllignCenter(_ title:String, _ subtitle:String,_ titleFont:UIFont,_ subtitleFont:UIFont,_ titleColor:UIColor,_ subtitleColor:UIColor,_ delem:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delem)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor,.font:subtitleFont])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    func provideAttributedTextToControlAllignCenterUnderLine(_ title:String, _ subtitle:String,_ titleFont:UIFont,_ subtitleFont:UIFont,_ titleColor:UIColor,_ subtitleColor:UIColor,_ delem:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delem)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor,.font:subtitleFont])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: myMutableString.length))
        return myMutableString
    }
    
    func provideAttributedTextToControlAllignCenterUnderLine1(_ title:String, _ titleFont:UIFont,_ titleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        
        myMutableString.append(myMutableString1)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: myMutableString.length))
        return myMutableString
    }
    
    
    
    func provideAttributedTextToControlLeftAllign1(_ title:String, _ subtitle:String,_ titleFont:UIFont,_ subtitleFont:UIFont,_ titleColor:UIColor,_ subtitleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor,.font:subtitleFont])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .left
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    func provideAttributedTextToControlLeftAllignForGuideline(_ title1:String, _ subtitle1:String,_ titleFont1:UIFont,_ subtitleFont1:UIFont,_ titleColor1:UIColor,_ subtitleColor1:UIColor,_ title2:String,_ titleFont2:UIFont,_ titleColor2:UIColor,_ delem:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title1)\(delem)", attributes:[ .foregroundColor :titleColor1,.font:titleFont1])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle1)\(delem)\(delem)", attributes:[.foregroundColor :subtitleColor1,.font:subtitleFont1])
        
        let myMutableString3 = NSAttributedString(string: "\(title2)\(delem)", attributes:[ .foregroundColor :titleColor2,.font:titleFont2])
        
        
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        myMutableString.append(myMutableString3)
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    
    
    func provideAttributedTextToControlLeftWithoutFont(_ title:String, _ subtitle:String,_ titleColor:UIColor,_ subtitleColor:UIColor,_ delem:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delem)", attributes:[ .foregroundColor :titleColor])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle)", attributes:[.foregroundColor :subtitleColor])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .left
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    
    
    func provideAttributedTextToControlLeftAllignSingleCenter(_ title:String, _ titleFont:UIFont,_ titleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        
        
        myMutableString.append(myMutableString1)
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    
    func provideAttributedTextToControlLeftAllignSingleCenterItalic(_ title:String, _ titleFont:UIFont,_ titleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        
        
        myMutableString.append(myMutableString1)
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: myMutableString.length))
        
        return myMutableString
    }
    
    
    
    func provideAttributedTextToControlLeftAllignSingle(_ title:String, _ titleFont:UIFont,_ titleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[ .foregroundColor :titleColor,.font:titleFont])
        
        
        
        myMutableString.append(myMutableString1)
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .left
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    
    
    
    func provideAttributedTextToControlLeftAllignForGuideline7(_ title1:String, _ subtitle1:String,_ titleFont1:UIFont,_ subtitleFont1:UIFont,_ titleColor1:UIColor,_ subtitleColor1:UIColor,_ title2:String, _ subtitle3:String, _ subtitle4:String, _ subtitle5:String, _ subtitle6:String,_ titleFont2:UIFont,_ subtitleFont3:UIFont,_ subtitleFont4:UIFont,_ subtitleFont5:UIFont,_ subtitleFont6:UIFont,_ titleColor2:UIColor,_ subtitleColor3:UIColor,_ subtitleColor4:UIColor,_ subtitleColor5:UIColor,_ subtitleColor6:UIColor,_ delem:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title1)\(delem)", attributes:[ .foregroundColor :titleColor1,.font:titleFont1])
        
        let myMutableString2 = NSAttributedString(string: "\(subtitle1)\(delem)\(delem)", attributes:[.foregroundColor :subtitleColor1,.font:subtitleFont1])
        
        let myMutableString4 = NSAttributedString(string: "\(subtitle3)\(delem)\(delem)", attributes:[.foregroundColor :subtitleColor3,.font:subtitleFont3])
        
        let myMutableString5 = NSAttributedString(string: "\(subtitle4)\(delem)\(delem)", attributes:[.foregroundColor :subtitleColor4,.font:subtitleFont4])
        
        let myMutableString6 = NSAttributedString(string: "\(subtitle5)\(delem)\(delem)", attributes:[.foregroundColor :subtitleColor5,.font:subtitleFont5])
        
        let myMutableString7 = NSAttributedString(string: "\(subtitle6)\(delem)\(delem)", attributes:[.foregroundColor :subtitleColor6,.font:subtitleFont6])
        
        let myMutableString3 = NSAttributedString(string: "\(title2)\(delem)", attributes:[ .foregroundColor :titleColor2,.font:titleFont2])
        
        
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        myMutableString.append(myMutableString3)
        myMutableString.append(myMutableString4)
        myMutableString.append(myMutableString5)
        myMutableString.append(myMutableString6)
        myMutableString.append(myMutableString7)
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        paragraphStyle.alignment = .left
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
}

extension UIViewController {
    func showToast(message: String) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 10;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 2
        
        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: toastLabel, attribute: .centerX, relatedBy: .equal, toItem: toastContainer, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
        let lableBottom = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -5)
        let lableTop = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 5)
        toastContainer.addConstraints([centerX, lableBottom, lableTop])
        
        let containerCenterX = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let containerTrailing = NSLayoutConstraint(item: toastContainer, attribute: .width, relatedBy: .equal, toItem: toastLabel, attribute: .width, multiplier: 1.1, constant: 0)
        let containerBottom = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -75)
        self.view.addConstraints([containerCenterX,containerTrailing, containerBottom])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    func alertWithHandler1(message : String , block:  @escaping ()->Void ){
        
        let  alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action : UIAlertAction) in
            
            block()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
