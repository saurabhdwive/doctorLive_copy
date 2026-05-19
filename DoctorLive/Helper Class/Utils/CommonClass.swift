
//  CommonClass.swift
//  E-RX
//
//  Created by macbook on 28/05/20.
//  Copyright © 2020 macbook. All rights reserved.


import Foundation
import UIKit
class CommonClass {

    static let sharedInstance = CommonClass()
    let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    let kScreenHeight = UIScreen.main.bounds.height
    let kScreenWidth = UIScreen.main.bounds.width
    let kUserDefaults = UserDefaults.standard

     let regularfontSize = 16 as CGFloat
     let semiBoldfontSize = 16 as CGFloat
     let BoldfontSize = 18 as CGFloat
     let appName = "E-RX"
     let textDarkGray = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
     let AppColorMost = #colorLiteral(red: 0.1411764706, green: 0.6941176471, blue: 0.7490196078, alpha: 1)
     let textLightGray = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
     let MediumFont = "Lato-Black"
     let BoldFont = "Lato-Bold"
     let RegularFont = "Lato-Regular"
     let LightFont = "Lato-Light"


    func createString(Str: String) -> String
    {
        return Str.localized()
    }

    func LblFontSizeName(name: String,lbl:UILabel,textColor:UIColor,fontName:String,fontSize:CGFloat){

        lbl.text = createString(Str: name)
        lbl.font = UIFont(name: fontName, size: fontSize)
        lbl.textColor = textColor

        if lbl.textAlignment != .center{
            lbl.textAlignment =  Localize.currentLanguage() == "ar" ? .right : .left
        }

    }

    func txtFldFontSizeConfig(txtFld:UITextField,placeHolderText:String,fontName:String,fontSize:CGFloat,textColor:UIColor){

        txtFld.placeholder = placeHolderText
        txtFld.font = UIFont(name: fontName, size: fontSize)
        txtFld.textColor = textColor
        txtFld.textAlignment =  Localize.currentLanguage() == "ar" ? .right : .left

    }

    open func setupLable(_ title: [String],_ lbl: [UILabel],_ aliment: [NSTextAlignment],_ font: [String],_ size: [CGFloat],_ textColor: [UIColor]){

        for i in 0..<lbl.count{
            lbl[i].text = comClass.createString(Str: title[i])
            lbl[i].textAlignment = aliment[i]
            lbl[i].textColor = textColor[i]
            lbl[i].font = (font[i] == AppFont.Regular.rawValue) ? AppFont.Regular.size(AppFontName.poppins, size: size[i]):AppFont.Bold.size(AppFontName.poppins, size: size[i])
        }
    }

    func setDataOnButton(btn:UIButton,text:String,font:String,size:CGFloat,textcolor:UIColor,image:UIImage,backGroundColor:UIColor,aliment:UIControl.ContentHorizontalAlignment){

       // btn.backgroundColor = backGroundColor
        btn.setTitle(CommonClass.sharedInstance.createString(Str: text), for: .normal)
        btn.setTitleColor(textcolor, for: .normal)
        btn.titleLabel?.font = UIFont(name: font, size: size)
        btn.setImage(image, for: .normal)
        //btn.layer.cornerRadius = CGFloat(CommonClass.sharedInstance.commonHeight/2)
        btn.contentHorizontalAlignment = aliment
    }

    // =====  TextField Padding ======
    func configureView(txtFld:UITextField){

        let paddingPhoneNumber = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: txtFld.frame.height))
            txtFld.leftView = paddingPhoneNumber
            txtFld.leftViewMode = UITextField.ViewMode.always


    }

    func openCamera(imagePicker:UIImagePickerController,vc:UIViewController) {

        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            vc.present(imagePicker, animated: true, completion: nil)
        }else {

            let alert = UIAlertController(title: createString(Str: "E-RX"), message: createString(Str: "You don't have camera"), preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: createString(Str: "OK"), style: UIAlertAction.Style.default, handler: nil))
            //alert.view.backgroundColor = AppColor.appColor
            vc.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery(imagePicker:UIImagePickerController,vc:UIViewController) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        vc.present(imagePicker, animated: true, completion: nil)

    }

    func attributedText(string:String,font:String,color:UIColor,size:CGFloat) -> NSMutableAttributedString{

        let str = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font : UIFont(name: font, size: size) ?? AppFont.Regular.size(AppFontName.poppins, size: 18),NSAttributedString.Key.foregroundColor:color])
        return str
    }

    func dateTimeConversion(createdAt:String) -> String{


        var newTimeZone = String()
        newTimeZone = newTimeZone.timeDateConversion(formateDate:String(createdAt.prefix(19)))
        let start = String.Index(utf16Offset: 11, in: newTimeZone)
        let end = String.Index(utf16Offset: 18, in: newTimeZone)
        let substring = String(newTimeZone[start...end])

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: "\(newTimeZone.prefix(10))")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var timeT = String()
        timeT = timeT.timeConversion12(time24: "\(substring.prefix(5))")
       // ("\(dateFormatter.string(from: dateObj!))",timeT)
        return "\(dateFormatter.string(from: dateObj!)) " + " \(timeT)"
    }

    func timeConversion(createdAt:String) -> String{

          var newTimeZone = String()
          newTimeZone = newTimeZone.timeDateConversion(formateDate:String(createdAt.prefix(19)))
          let start = String.Index(utf16Offset: 11, in: newTimeZone)
          let end = String.Index(utf16Offset: 18, in: newTimeZone)
          let substring = String(newTimeZone[start...end])

          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          dateFormatter.locale = Locale.init(identifier: "en_GB")

          var timeT = String()
          timeT = timeT.timeConversion12(time24: "\(substring.prefix(5))")

          return timeT
      }
}
//MARK:- Time Conversion
//MARK:-
extension String{

    func timeDateConversion(formateDate:String) -> String{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: formateDate == "" ? "2020-02-28T13:30:15" : formateDate)// create   date from string

        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date ?? Date())

        return timeStamp
    }

    func timeDateConversion1(formateDate:String) -> String{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //"yyyy-MM-dd'T'HH:mm:ssZ"
//        let timeZone = TimeZone.current.identifier
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")//TimeZone(name: "UTC")
        let date = dateFormatter.date(from: formateDate == "" ? "" : formateDate)// create   date from string

        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let timeStamp = dateFormatter.string(from: date ?? Date())

        return timeStamp
    }

    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm "

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"
        df.amSymbol = "am"
        df.pmSymbol = "pm"

        let time12 = df.string(from: date!)
        return time12
    }


    func convertStringToDate(_ dateStr : String) ->  Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: dateStr)
        debugPrint(date)
        debugPrint("***** \(dateFormatter.date(from: dateStr))")



        return date
    }
}
