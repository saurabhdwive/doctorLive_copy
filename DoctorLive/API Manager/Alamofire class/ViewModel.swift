//
//  ViewModel.swift
//  Helper Class
//
//  Created by Krishanvir on 29/03/22.
//

import UIKit
import Foundation

class ViewModel: NSObject {
    
    // Closure use for notifi
    let apiHandle : ApiHandler = ApiHandler()
    var reloadList = {() -> () in }
    var success = {(message :String) -> () in }
    var successCount = {(count :Int) -> () in }
    
    var errorMessage = {(message : String) -> () in }
    var invalidToken = {(message : String) -> () in }
    var controller : UIViewController?

    
    //MARK: - 
    var myArticleData = [MyArticlesRoot]()
    func myArticleApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if self.myArticleData.count > 0 {
                        self.myArticleData.removeAll()
                    }
                    if status == "SUCCESS" {
                        self.myArticleData.append(MyArticlesRoot(data))
                        self.success("My Article")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }

    var questionListData = [QuestionListRoot]()
    func questionListApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if self.questionListData.count > 0 {
                        self.questionListData.removeAll()
                    }
                    if status == "SUCCESS" {
                        self.questionListData.append(QuestionListRoot(data))
                        self.success("Question List")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }

    var myRatingListData = [MyRatingRoot]()
    func myRatingListApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if self.myRatingListData.count > 0 {
                        self.myRatingListData.removeAll()
                    }
                    if status == "SUCCESS" {
                        self.myRatingListData.append(MyRatingRoot(data))
                        self.success("My Rating")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }

    var questionDetailData = [QuestionDetailRoot]()
    func questionDetailApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if self.questionDetailData.count > 0 {
                        self.questionDetailData.removeAll()
                    }
                    if status == "SUCCESS" {
                        self.questionDetailData.append(QuestionDetailRoot(data))
                        self.success("Question List")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }

    var myAnswerListData = [MyAnswerRoot]()
    func myAnswerListApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if self.myAnswerListData.count > 0 {
                        self.myAnswerListData.removeAll()
                    }
                    if status == "SUCCESS" {
                        self.myAnswerListData.append(MyAnswerRoot(data))
                        self.success("Answer List")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }

    func articleDeleteApi(url endurl: String, passDic: [String: String]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDic, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if status == "SUCCESS" {
                        self.success("Article Deleted")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }
    
    func postAnswerApi(url endurl: String, passDic: [String: String]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDic, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if status == "SUCCESS" {
                        self.success("Post Answer")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }

    func updateAnswerApi(url endurl: String, passDic: [String: String]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDic, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if status == "SUCCESS" {
                        self.success("Update Answer")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }
    
    func postArticleApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if status == "SUCCESS" {
                        self.success("Post Article")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }

    func editPostArticleApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseDoctorUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    let message = data["message"].string ?? ""
                    if status == "SUCCESS" {
                        self.success("Edit Article")
                    } else {
                        self.errorMessage(message)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }
    
    func cutDoctorCallApi(url endurl: String, passDict: [String:Any]){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseUrl().appending(endurl), passDict: passDict, header: nil) { (result) in
                switch result{
                case .success(let data):
                    print(data)
                    let status = data["status"].string ?? ""
                    if status == "SUCCESS" {
                        self.success("cutDoctorCall")
                    } else {
                        self.errorMessage(status)
                    }
                    break
                case .failure(let error):
                    self.errorMessage(error.localizedDescription)
                }
            }
        }else{
            print("error network")
        }
    }
    
    var doctorChatData = [DoctorchathistoryModal]()
    func chatHistryApi(url endUrl :String, passDict:[String:Any]) {
        apiHandle.fetchApiHeaderService(method: .post, url: Domain.baseUrl().appending(endUrl), passDict: passDict) {  (result) in
            switch result {
            case .success(let data):
                print(data)
                let message = data["message"].string ?? ""
                let status = data["status"].string ?? ""
                if status == "SUCCESS" {
                    if self.doctorChatData.count > 0 {
                        self.doctorChatData.removeAll()
                    }
                    self.doctorChatData.append(DoctorchathistoryModal(data))
                    self.success("Chat History")
                }else{
                    self.errorMessage(message)
                }
                break
            case .failure(let error):
                self.errorMessage(error.localizedDescription)
            }
        }
    }
}
