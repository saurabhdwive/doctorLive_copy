//
//  AnswerAddEditViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import UIKit

extension AnswerAddEditViewC{
    func postAnswerApi(){
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        let passDic = ["token": token,
                       "question_id": self.questionData.questionId ?? EMPTY,
                       "answer": self.answerTxt.text ?? EMPTY]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.postAnswerApi(url: APIEndpoint.postAnswer, passDic: passDic)
        closureSetUp()
    }
    
    func updateAnswerApi(id: String){
        let token = USER_DEFAULTS.string(forKey: Constants.accessToken) ?? EMPTY
        let passDic = ["token": token,
                       "answer": self.answerTxt.text ?? EMPTY]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.updateAnswerApi(url: APIEndpoint.updateAnswer + id, passDic: passDic)
        closureSetUp()
    }

    private func setUpPostAnswer(){
        self.callBack?()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUpdateAnswer(){
        self.answerTxt.isUserInteractionEnabled = false
        self.editStatus = false
        self.postBtn.setTitle("Edit Answer", for: .normal)
        self.showToast(message: "Updated successfully")
    }

    fileprivate func closureSetUp(){
        //For Success
        viewmodel.success = {[weak self](message) in
            DispatchQueue.main.async{
                LoaderController.sharedInstance.removeLoader()
                if message == "Post Answer" {
                    print(message)
                    self?.setUpPostAnswer()
                }else if message == "Update Answer" {
                    print(message)
                    self?.setUpUpdateAnswer()
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
