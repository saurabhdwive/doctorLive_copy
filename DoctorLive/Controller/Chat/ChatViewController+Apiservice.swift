//
//  ChatViewController+Apiservice.swift
//  DoctorLive
//
//  Created by Kv on 21/11/24.
//

import Foundation
import PromiseKit
import PIPKit
import UIKit

extension ChatViewController{
    
    func generateAndSendPush() {
        let passDic = ["user_id": self.userId ?? EMPTY,
                       "channel": self.sinchToken ?? EMPTY,
                       "token": self.rtcAgoroToken ?? EMPTY,
                       "doctor_id": self.doctorId ?? EMPTY]
        print(passDic)
        self.generateAndSendPushApi(param: passDic)
    }
    
    func getToken() {
        let passDic = ["isPublisher": "true",
                       "channel": self.sinchToken ?? EMPTY]
        print(passDic)
        self.getTokenApi(param: passDic)
    }
    
    func getTokenApi(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.getToken(parameters: param, header: "DeviceToken")
        }.done { (model: TokenRoot) in
            self.getTokenModel(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    
    func generateAndSendPushApi(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.generateAndSendPush(parameters: param, header: "DeviceToken")
        }.done { (model: PushNotificationRoot) in
            self.generateAndSendPushModel(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }.finally {
            DispatchQueue.main.async {
                LoaderController.sharedInstance.removeLoader()
            }
        }
    }
    
    
    func getTokenModel(model: TokenRoot){
        if model.status == "SUCCESS" {
            self.rtcAgoroToken = model.token ?? EMPTY
            self.generateAndSendPush()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
    
    
    func generateAndSendPushModel(model: PushNotificationRoot){
        if model.status == "SUCCESS" {
            if let _ = self.findVideoCallController() {
                AppToast.showMessage(message: "Video call is already in progress")
            }else{
                let viewC = DIConfigurator.sharedInst().getVideoCallViewC()
                viewC.channelId = self.sinchToken ?? EMPTY
                viewC.rtcAgoroToken = self.rtcAgoroToken ?? EMPTY
                viewC.patientName = self.patientName ?? EMPTY
                viewC.userId = self.userId ?? EMPTY
                viewC.doctorId = self.doctorId ?? EMPTY
                viewC.bookingId = self.bookingId ?? EMPTY
                viewC.delegate = self
//                PIPKit.show(with: viewC)
                DIConfigurator.sharedInst().setVideoCallAsRoot(viewC: viewC)
            }
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
    
    func endVisitBooking(param: [String: String]){
        firstly {
            service!.bookingStatus(parameters: param, header: "DeviceToken")
        }.done { (model: BookingStatusModel) in
            self.endBooking(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
                
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performEndCall(bookingId: String, reason: String) {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "booking_id": bookingId,
                     "status": "4",
                     "reason": reason]
        endVisitBooking(param: parameter)
    }
    
    func endBooking(model: BookingStatusModel){
        if model.status == "SUCCESS" {
//            self.performUpcomingBooking()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension ChatViewController: VideoCallData{
    func videoCallData(patientName: String, bookingId: String, callDuration: String) {
        self.performEndCall(bookingId: bookingId, reason: EMPTY)
    }
}
