//
//  QuestionDetailViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import UIKit

extension QuestionDetailViewC{
    func questionDetailApi(){
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        let passDic = ["token": token,
                       "question_id": self.questionId ?? EMPTY]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.questionDetailApi(url: APIEndpoint.questionWithAnswer, passDict: passDic)
        closureSetUp()
    }

    private func setUpQuestion(){
        self.questionTblVw.reloadData()
    }

    fileprivate func closureSetUp(){
        //For Success
        viewmodel.success = {[weak self](message) in
            DispatchQueue.main.async{
                LoaderController.sharedInstance.removeLoader()
                if message == "Question List"{
                    print(message)
                    self?.setUpQuestion()
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
                self?.questionTblVw.reloadData()
                AppToast.showMessage(message: message)
            }
        }
    }
}
