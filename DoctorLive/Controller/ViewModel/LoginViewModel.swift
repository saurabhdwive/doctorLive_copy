//
//  LoginViewModel.swift
//  DoctorLive
//
//  Created by call soft on 06/09/21.
//

import Foundation
import UIKit
//class ViewModel: NSObject {
//
//    // Closure use for notifi
//    let apiHandle : ApiHandler = ApiHandler()
//    var reloadList = {() -> () in }
//    var success = {(message :String) -> () in }
//    var successCount = {(count :Int) -> () in }
//
//    var errorMessage = {(message : String) -> () in }
//    var invalidToken = {(message : String) -> () in }
//
//    //MARK:- Check User Mobile API
//    func CheckUserMobile(url endUrl :String, passDict:[String:Any]) {
//
//
//        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(endUrl), passDict: passDict) {  (result) in
//
//            switch result {
//
//            case .success(let data):
//                print(data)
//                let message = data["message"].string ?? ""
//                let checkemail = data["checkemail"].string ?? ""
//                let status = data["status"].string ?? ""
//                if data["status"].string == "SUCCESS" {
//                    self.success(checkemail)
//
//                }
//
//                else
//                {
//                    self.errorMessage(message)
//                }
//                break
//            case .failure(let error):
//                self.errorMessage(error.localizedDescription)
//            }
//        }
//    }
//
//    var signupDataModel = [SignupDataModel]()
//    func SignUp(url endUrl :String, passDict:[String:Any]) {
//
//     //   let header = ["Content-Type" : "application/json"]
//
//        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(endUrl), passDict: passDict) {  (result) in
//
//            switch result {
//
//            case .success(let data):
//                print(data)
//                let message = data["message"].string ?? ""
//                let status = data["status"].string ?? ""
//
//                if status == "SUCCESS" {
//                    if self.signupDataModel.count > 0 {
//                    self.signupDataModel.removeAll()
//                    }
//                    self.signupDataModel.append(SignupDataModel(data))
//                    UserDefaults.standard.setData(self.signupDataModel.first?.login)
//                    self.success("Signup successfull")
//
//                }
//                else
//                {
//                    self.errorMessage(message)
//                }
//                break
//            case .failure(let error):
//                self.errorMessage(error.localizedDescription)
//            }
//        }
//    }
//    var loginDataModel = [LoginDataModel]()
//    func LoginApi(url endUrl :String, passDict:[String:Any]) {
//
//       // let header = ["Content-Type" : "application/json"]
//
//        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(endUrl), passDict: passDict) {  (result) in
//
//            switch result {
//
//            case .success(let data):
//                print(data)
//                let message = data["message"].string ?? ""
//
//                let status = data["status"].string ?? ""
//                if status == "SUCCESS" {
//                    if self.loginDataModel.count > 0 {
//                        self.loginDataModel.removeAll()
//                    }
//                    self.loginDataModel.append(LoginDataModel(data))
//                    UserDefaults.standard.setData(self.loginDataModel.first?.login)
//                    self.success("Login Response")
//
//                }
//
//                else
//                {
//                    self.errorMessage(message)
//                }
//                break
//            case .failure(let error):
//                self.errorMessage(error.localizedDescription)
//            }
//        }
//    }
//}
