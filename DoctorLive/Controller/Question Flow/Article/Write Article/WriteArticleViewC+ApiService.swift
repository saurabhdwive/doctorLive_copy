//
//  WriteArticleViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import Foundation
import PromiseKit
import UIKit

extension WriteArticleViewC{
    func postArticleApi(){
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        var image = ""
        self.photoUri.forEach { Str in
            image = image + "," + Str
        }
        let passDic = ["token": token,
                       "title": self.titleTxt.text ?? EMPTY,
                       "description": self.descriptionTxt.text ?? EMPTY,
                       "status_check": "1",
                       "speciality": self.specialityLbl.text ?? EMPTY,
                       "images": String(image.dropFirst())]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.postArticleApi(url: APIEndpoint.postArticle, passDict: passDic)
        closureSetUp()
    }
    
    func editArticleApi(id: String){
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        var image = ""
        self.photoUri.forEach { Str in
            image = image + "," + Str
        }
        let passDic = ["token": token,
                       "title": self.titleTxt.text ?? EMPTY,
                       "description": self.descriptionTxt.text ?? EMPTY,
                       "status_check": "1",
                       "speciality": self.specialityLbl.text ?? EMPTY,
                       "article_image_paths": String(image.dropFirst())]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.editPostArticleApi(url: APIEndpoint.updateArticle + id, passDict: passDic)
        closureSetUp()
    }
    
    private func setUpPostArticle(){
        self.addDelegate?.writeArticle()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpEditPostArticle(){
        self.editDelegate?.editWriteArticle()
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func closureSetUp(){
        //For Success
        viewmodel.success = {[weak self](message) in
            DispatchQueue.main.async{
                LoaderController.sharedInstance.removeLoader()
                if message == "Post Article"{
                    print(message)
                    self?.setUpPostArticle()
                }else if message == "Edit Article"{
                    print(message)
                    self?.setUpEditPostArticle()
                }else{
                    print(message)
                    AppToast.showMessage(message: message)
                }
            }
        }
        
        // MARK:- For Error Message
        viewmodel.errorMessage = {[weak self](message) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
                print(message)
                AppToast.showMessage(message: message)
            }
        }
    }
}

extension WriteArticleViewC {
    func fullProfile(param: [String: String]){
        firstly {
            service!.fullCompleteProfile(parameters: param, header: "DeviceToken")
        }.done { (model: FullProfileDetailModel) in
            self.handleResponse(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
        }.finally {
            DispatchQueue.main.async {
            }
        }
    }
    
    func validations() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        fullProfile(param: parameter)
    }
    
    func handleResponse(model: FullProfileDetailModel) {
        if model.status == "SUCCESS" {
            self.specialityLbl.text = model.professionaldetail?.specialty
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
