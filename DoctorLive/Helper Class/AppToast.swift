//
//  AppToast.swift
//  Capsula
//
//  Created by Admin on 23/12/20.
//

import Foundation
import UIKit

class AppToast {
       
    static func showMessage(title: String =  "", message:String, completion: (() -> ())? = nil) {
       
        //AppDelegate.shared.window?.rootViewController{
        if let rootVC = AppDelegate.shared.window?.rootViewController {
            var style = ToastStyle()
            style.messageFont = AppFont.Regular.size(AppFontName.poppins, size: 14)
            style.messageColor = UIColor.white
            style.messageAlignment = .center
            style.backgroundColor = UIColor.black
            rootVC.view.makeToast(message, duration: 3.0, position: .bottom,style : style)
        }
    }
    
    static func showMessage1(title: String =  "", message:String,_ vc:UIViewController, completion: (() -> ())? = nil) {
        
        var style = ToastStyle()
        style.messageFont = AppFont.Regular.size(AppFontName.poppins, size: 14)
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor.black
        vc.view.makeToast(message, duration: 3.0, position: .bottom,style : style)
   
    }
}

