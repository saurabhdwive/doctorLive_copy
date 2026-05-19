//
//  ProfileEditExtension.swift
//  DoctorLive
//
//  Created by call soft on 13/09/21.
//

import Foundation
import UIKit

extension PersonalProfileEditVC {
    func openDatePicker(){
        let size:CGFloat =  390
        // ...........BaseView Setup..............//
        var baseview: UIView!
        baseview = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-size, width: self.view.frame.size.width, height: size))
        // baseview.backgroundColor = UIColor(red:0.75, green:0.44, blue:0.99, alpha:1.0)
        baseview.backgroundColor = UIColor(named: "BackGround")
        baseview.tag = 668
        self.view.addSubview(baseview)
        self.view.bringSubviewToFront(baseview)
        self.view.endEditing(true)
        
        let viewGreen = UIView(frame: CGRect(x: 0, y: 0, width: baseview.frame.size.width, height: 50))
        viewGreen.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        baseview.addSubview(viewGreen)
        
        //............Button Setup............//
        //(x: baseview.frame.size.width-100, y: 0, width: 100, height: 50)
        let doneButton: UIButton = UIButton(frame: CGRect(x: baseview.frame.size.width-100, y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        //  doneButton.titleLabel?.font = AppFont.Bold.size(.SFPro, size: 17)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.backgroundColor = UIColor.clear
        doneButton.tag = 1
        doneButton.addTarget(self, action: #selector(doneButtonActionFordatePicker), for: .touchUpInside)
        baseview.addSubview(doneButton)
        
        let cancelButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        cancelButton.setTitle("Cancel", for: .normal)
        //cancelButton.titleLabel?.font = AppFont.Bold.size(.SFPro, size: 17)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = UIColor.clear
       
        cancelButton.addTarget(self, action: #selector(cancelButtonActionFordatePicker), for: .touchUpInside)
        baseview.addSubview(cancelButton)
        
        // ...............Date Picker Setup..................//
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = 0
        
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        //components.year = 100
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        var datePickerView: UIDatePicker!
        datePickerView = UIDatePicker(frame: CGRect(x:25, y: 50, width: baseview.frame.width, height:baseview.frame.height - 50))
        datePickerView.datePickerMode = .date
        datePickerView.backgroundColor = UIColor(named: "BackGround")
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                datePickerView.preferredDatePickerStyle =  .inline
            } else {
                // Fallback on earlier versions
                datePickerView.preferredDatePickerStyle = .wheels
            }
        }
        datePickerView.tag = 5454
        // datePickerView.minimumDate = minDate // Change for current date
        datePickerView.maximumDate = maxDate
        baseview.addSubview(datePickerView)
        
    }


    @objc func doneButtonActionFordatePicker(_ sender:UIButton)
    {
        if let baseViewTag = self.view.viewWithTag(668)
        {
            if let datePicker = self.view.viewWithTag(5454) as? UIDatePicker
            {
                let dateFormatter = DateFormatter()
                
                if sender.tag == 1{ // Date
                    dateFormatter.dateFormat = "dd-MM-YYYY"
                    let date = dateFormatter.string(from: datePicker.date)
                    dobText.text = date
                    
                }
                
                baseViewTag.removeFromSuperview()
            }
        }
    }

    @objc func cancelButtonActionFordatePicker()
    {
        if let baseViewTag = self.view.viewWithTag(668)
        {
            baseViewTag.removeFromSuperview()
        }
    }
    }
