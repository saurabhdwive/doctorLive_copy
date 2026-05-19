//
//  MyRatingViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 14/11/24.
//

import Foundation
import UIKit

extension MyRatingViewC {
    func myRatingListApi(){
        let doctorId = USER_DEFAULTS.string(forKey: Constants.userId) ?? EMPTY
        let passDic = ["doctor_id": doctorId]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.myRatingListApi(url: APIEndpoint.myRating, passDict: passDic)
        closureSetUp()
    }

    private func setUpRating(){
        self.ratingTblVw.reloadData()
    }

    fileprivate func closureSetUp(){
        //For Success
        viewmodel.success = {[weak self](message) in
            DispatchQueue.main.async{
                LoaderController.sharedInstance.removeLoader()
                if message == "My Rating"{
                    print(message)
                    self?.setUpRating()
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
                self?.ratingTblVw.reloadData()
                AppToast.showMessage(message: message)
            }
        }
    }
}
