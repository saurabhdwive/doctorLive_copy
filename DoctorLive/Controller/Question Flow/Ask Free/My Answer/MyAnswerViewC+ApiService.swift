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
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        let passDic = ["token": token]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
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
                LoaderController.sharedInstance.removeLoader()
                if message == "Answer List"{
                    print(message)
                    self?.setUpMyAnswer()
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
                self?.answerTblVw.reloadData()
                AppToast.showMessage(message: message)
            }
        }
    }
}
