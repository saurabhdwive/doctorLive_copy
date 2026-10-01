//
//  VideoCallViewC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 05/11/24.
//

import Foundation
import PIPKit
import UIKit

extension VideoCallViewC{
    func cutCallApi(){
        let passDic = ["doctor_id": self.doctorId ?? EMPTY,
                       "user_id": self.userId ?? EMPTY,
                       "booking_id":self.bookingId ?? EMPTY]
        print(passDic)
        LoaderController.sharedInstance.showLoader(view: self.view)
        viewmodel.controller = self
        viewmodel.cutDoctorCallApi(url: APIEndpoint.cutDoctorCall, passDict: passDic)
        closureSetUp()
    }
    
    fileprivate func closureSetUp(){
        //For Success
        viewmodel.success = {[weak self](message) in
            LoaderController.sharedInstance.removeLoader()
            DispatchQueue.main.async{
                if message == "cutDoctorCall"{
                    print(message)
                }else{
                    print(message)
                    AppToast.showMessage(message: message)
                }
            }
        }
        
        // MARK:- For Error Message
        viewmodel.errorMessage = {[weak self](message) in
            LoaderController.sharedInstance.removeLoader()
            DispatchQueue.main.async {
                print(message)
                AppToast.showMessage(message: message)
            }
        }
    }
}
