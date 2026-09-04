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
        if isFetching { return }
        isFetching = true
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        let passDic: [String: Any] = ["token": token,"page":currentPage]
        print(passDic)
        if currentPage == 1 {
            LoaderController.sharedInstance.showLoader(view: self.view)
        } else {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.articleTblVw.bounds.width, height: CGFloat(44))
            self.articleTblVw.tableFooterView = spinner
        }
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
                guard let self = self else { return }
                self.isFetching = false
                if self.currentPage == 1 {
                    LoaderController.sharedInstance.removeLoader()
                } else {
                    self.articleTblVw.tableFooterView = nil
                }
                if message == "My Article"{
                    print(message)
                    if let newData = self.viewmodel.myArticleData.first?.articles {
                        if newData.isEmpty {
                            self.isLastPage = true
                        }
                        if self.currentPage == 1 {
                            self.dataList = newData
                            self.isLastPage = newData.isEmpty
                        } else {
                            self.dataList.append(contentsOf: newData)
                        }
                    } else {
                        self.isLastPage = true
                    }
                    self.setUpMyArticle()
                }else if message == "Article Deleted"{
                    print(message)
                    self.setUpArticleDelete()
                }else{
                    print(message)
                    AppToast.showMessage(message: message)
                }
            }
        }
        
        // MARK:- For Error Message
        viewmodel.errorMessage = {[weak self](message) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isFetching = false
                if self.currentPage == 1 {
                    LoaderController.sharedInstance.removeLoader()
                } else {
                    self.articleTblVw.tableFooterView = nil
                    self.isLastPage = true
                }
                print(message)
                self.articleTblVw.reloadData()
                if self.currentPage == 1 {
                    AppToast.showMessage(message: message)
                }
            }
        }
    }
}
