//
//  MyArticleViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import Foundation
import UIKit

extension MyArticleViewC{
    func myArticleApi(){
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        let passDic = ["token": token]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.myArticleApi(url: APIEndpoint.myArticles, passDict: passDic)
        closureSetUp()
    }
    
    func articleDeleteApi(id: String){
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        let passDic = ["token": token,
                       "articleId":id]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.articleDeleteApi(url: APIEndpoint.deleteArticle + id, passDic: passDic)
        closureSetUp()
    }
    
    private func setUpMyArticle(){
        self.articleTblVw.reloadData()
    }
    
    private func setUpArticleDelete(){
        self.myArticleApi()
        self.showToast(message: "Delete Successfully")
    }
    
    fileprivate func closureSetUp(){
        //For Success
        viewmodel.success = {[weak self](message) in
            DispatchQueue.main.async{
                LoaderController.sharedInstance.removeLoader()
                if message == "My Article"{
                    print(message)
                    self?.setUpMyArticle()
                }else if message == "Article Deleted"{
                    print(message)
                    self?.setUpArticleDelete()
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
                self?.articleTblVw.reloadData()
                AppToast.showMessage(message: message)
            }
        }
    }
}
