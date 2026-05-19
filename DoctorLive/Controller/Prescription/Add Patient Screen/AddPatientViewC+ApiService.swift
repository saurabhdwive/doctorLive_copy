//
//  AddPatientViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 06/11/24.
//

import Foundation
import UIKit

//extension AddPatientViewC {
//    func addMember() {
//        Indicator.shared.showProgressView(view)
//        let selectedLanguage = UserDefaults.standard.value(forKey: "selectedLanguage") ?? ""
//        print(UserDefaults.standard.value(forKey: "token") ?? "")
//        var  gender :String?
//        var genderValue = genderTxt.text ?? ""
//        if genderValue == "Male".localized() {
//            gender = "m"
//        }else if genderValue == "Female".localized(){
//            gender = "f"
//        }else{
//            gender = "o"
//        }
//        print(gender)
//        let passDict =  ["token": UserDefaults.standard.value(forKey: "token") ?? "" ,
//                         "name": nameTxt.text ?? "",
//                         "dob": ageTxt.text ?? "",
//                         "gender": gender ?? "",
//                         "relationship": relationShipTxt.text  ?? "",
//                         "language_type": selectedLanguage] as [String : Any]
//        print(passDict)
//        var arrimg = [Data]()
//        print(arrimg)
//        viewmodel.AddMemberProfileApi(url: APIEndpoint.addmember, passDict: passDict, profileKey: "profile", imageData: arrimg)
//        closureSetUp()
//    }
//    
//    func closureSetUp() {
//        // MARK:- For success
//        viewmodel.success = {[weak self] (message) in
//            DispatchQueue.main.async {
//                Indicator.shared.hideProgressView()
//                if message == "User member added Successfully"{
//                    self?.addPatientCallBack?(message)
//                    self?.dismiss(animated: true)
//                }else{
//                    print(message)
//                    self?.show_Alert(message: message)
//                }
//            }
//        }
//        
//        // MARK:- For Error Message
//        viewmodel.errorMessage = {[weak self] (message) in
//            DispatchQueue.main.async {
//                Indicator.shared.hideProgressView()
//                self?.show_Alert(message: message)
//            }
//        }
//        viewmodel.invalidToken = {[weak self] (message) in
//            DispatchQueue.main.async {
//                Indicator.shared.hideProgressView()
//                self?.alertWithHandler(message: message, block: {
//                })
//            }
//        }
//    }
//}
