//
//  MyAnswerViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import UIKit

extension MyAnswerViewC{
    func myAnswerListApi(){
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
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.answerTblVw.bounds.width, height: CGFloat(44))
            self.answerTblVw.tableFooterView = spinner
        }
        viewmodel.controller = self
        viewmodel.myAnswerListApi(url: APIEndpoint.myAnswerList, passDict: passDic)
        closureSetUp()
    }

    private func setUpMyAnswer(){
        self.answerTblVw.reloadData()
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
                    self.answerTblVw.tableFooterView = nil
                }
                
                if message == "Answer List"{
                    print(message)
                    if let newData = self.viewmodel.myAnswerListData.first?.data {
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
                    self.setUpMyAnswer()
                }else{
                    print(message)
//                    AppToast.showMessage(message: message)
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
                    self.answerTblVw.tableFooterView = nil
                    self.isLastPage = true
                }
                print(message)
                self.answerTblVw.reloadData()
                if self.currentPage == 1 {
                    AppToast.showMessage(message: message)
                }
            }
        }
    }
}
