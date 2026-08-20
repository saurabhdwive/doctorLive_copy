
//
//  HomeVC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 06/09/24.
//

import Foundation
import PromiseKit
import PIPKit
import UIKit

//MARK: - AVAILABILITY
extension HomeVC {
    func doctorAvilability(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.doctorAvilability(parameters: param, header: "DeviceToken")
        }.done { (model: PendingBookingModel) in
            self.handleDoctorResponse(model: model)
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
    
    func performDoctorAvilability(avilability: String) {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "status": "\(avilability)"]
        doctorAvilability(param: parameter)
    }
    
    func handleDoctorResponse(model: PendingBookingModel) {
        if model.status == "SUCCESS" {
            LoaderController.sharedInstance.removeLoader()
            UserDefaults.standard.set(self.switchButton.isOn, forKey: "switchState")
            UserDefaults.standard.synchronize()
        } else {
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

//MARK: - PENDING
/*
extension HomeVC {
    func pendingBooking(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.pendingBooking(parameters: param, header: "DeviceToken")
        }.done { (model: PendingBookingModel) in
            self.handleResponse(model: model)
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
    
    func performPendingBooking() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        self.pendingBooking(param: parameter)
    }
    
    func handleResponse(model: PendingBookingModel) {
        if model.status == "SUCCESS" {
            self.pendingBookingData.Pending?.removeAll()
            self.pendingBookingData.Accepted?.removeAll()
            model.pendingbooking?.call?.forEach({ Pending in
                if Pending.bookingStatusName ?? EMPTY == "Pending"{
                    if Pending.memberName == "Me" {
                        self.pendingBookingData.Pending?.append(PendingBooking(patientName: Pending.name ?? EMPTY, gender: Pending.memberGender ?? EMPTY, age: Pending.memberDob ?? EMPTY, bookingId: Pending.id ?? EMPTY, Date: "\(Pending.scheduleDate ?? EMPTY), \(Pending.scheduleTime ?? EMPTY)", reasonForCall: Pending.reasonVisit ?? EMPTY))
                    } else{
                        self.pendingBookingData.Pending?.append(PendingBooking(patientName: Pending.memberName ?? EMPTY, gender: Pending.memberGender ?? EMPTY, age: Pending.memberDob ?? EMPTY, bookingId: Pending.id ?? EMPTY, Date: "\(Pending.scheduleDate ?? EMPTY), \(Pending.scheduleTime ?? EMPTY)", reasonForCall: Pending.reasonVisit ?? EMPTY))
                    }
                }else{
                    if Pending.memberName == "Me" {
                        self.pendingBookingData.Accepted?.append(AcceptedBooking(patientName: Pending.name ?? EMPTY, gender: Pending.memberGender ?? EMPTY, age: Pending.memberDob ?? EMPTY, bookingId: Pending.id ?? EMPTY, Date: "\(Pending.scheduleDate ?? EMPTY), \(Pending.scheduleTime ?? EMPTY)", reasonForCall: Pending.reasonVisit ?? EMPTY))
                    } else{
                        self.pendingBookingData.Accepted?.append(AcceptedBooking(patientName: Pending.memberName ?? EMPTY, gender: Pending.memberGender ?? EMPTY, age: Pending.memberDob ?? EMPTY, bookingId: Pending.id ?? EMPTY, Date: "\(Pending.scheduleDate ?? EMPTY), \(Pending.scheduleTime ?? EMPTY)", reasonForCall: Pending.reasonVisit ?? EMPTY))
                    }
                }
            })
            self.bookingTblVw.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}
*/

//MARK: - UPCOMING
/*
extension HomeVC {
    func upcomingBooking(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.upcomingBooking(parameters: param, header: "DeviceToken")
        }.done { (model: UpcomingBookingModel) in
            self.handleUpcomingResponse(model: model)
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
    
    func performUpcomingBooking() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        self.upcomingBooking(param: parameter)
    }
    
    func handleUpcomingResponse(model: UpcomingBookingModel){
        if model.status == "SUCCESS" {
            print(model)
            self.upcomingBookingData.removeAll()
            model.upcomingbooking?.call?.forEach({ UpcomingCall in
                if UpcomingCall.memberName == "Me" {
                    self.upcomingBookingData.append(UpcomingBooking(patientName: UpcomingCall.name ?? EMPTY, mobile: UpcomingCall.mobile ?? EMPTY, gender: UpcomingCall.memberGender ?? EMPTY, age: UpcomingCall.memberDob ?? EMPTY, bookingId: UpcomingCall.id ?? EMPTY, date: "\(UpcomingCall.scheduleDate ?? EMPTY), \(UpcomingCall.scheduleTime ?? EMPTY)", reasonForCall: UpcomingCall.reasonVisit ?? EMPTY, sinchId: UpcomingCall.devicetoken ?? EMPTY, userId: UpcomingCall.userId ?? EMPTY, chatCount: UpcomingCall.chatcount ?? EMPTY))
                }else{
                    self.upcomingBookingData.append(UpcomingBooking(patientName: UpcomingCall.memberName ?? EMPTY, mobile: UpcomingCall.mobile ?? EMPTY, gender: UpcomingCall.memberGender ?? EMPTY, age: UpcomingCall.memberDob ?? EMPTY, bookingId: UpcomingCall.id ?? EMPTY, date: "\(UpcomingCall.scheduleDate ?? EMPTY), \(UpcomingCall.scheduleTime ?? EMPTY)", reasonForCall: UpcomingCall.reasonVisit ?? EMPTY, sinchId: UpcomingCall.devicetoken ?? EMPTY, userId: UpcomingCall.userId ?? EMPTY, chatCount: UpcomingCall.chatcount ?? EMPTY))
                }
            })
            self.bookingTblVw.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            // AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}
*/

//MARK: - PREVIOUS
/*
extension HomeVC {
    func pastBooking(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.pastBooking(parameters: param, header: "DeviceToken")
        }.done { (model: PastBookingModel) in
            self.handlePastResponse(model: model)
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
    
    func performPastBooking() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        self.pastBooking(param: parameter)
    }
    
    func handlePastResponse(model: PastBookingModel) {
        if model.status == "SUCCESS" {
            print(model)
            self.previousBookingData.FollowUp?.removeAll()
            self.previousBookingData.Previous?.removeAll()
            model.pastbooking?.call?.forEach({ Past in
                if Past.followup_date ?? EMPTY != ""{
                    if Past.memberName == "Me" {
                        self.previousBookingData.FollowUp?.append(FollowUpBooking(patientName: Past.name ?? EMPTY, gender: Past.memberGender ?? EMPTY, age: Past.memberDob ?? EMPTY, bookingId: Past.id ?? EMPTY, date: "\(Past.scheduleDate ?? EMPTY), \(Past.scheduleTime ?? EMPTY)", reasonForCall: Past.reasonVisit ?? EMPTY, price: Past.amount ?? EMPTY, followUpDate: Past.followup_date ?? EMPTY, sinchKey: Past.devicetoken ?? EMPTY, prescription: Past.filePdf ?? EMPTY, chatCount: Past.chat_count ?? EMPTY, mobile: Past.mobile ?? EMPTY, chatMode: Past.chatMode ?? EMPTY, rating: Past.rating ?? EMPTY, bookingStatus: Past.bookingStatusName ?? EMPTY, userId: Past.userId ?? EMPTY))
                    } else {
                        self.previousBookingData.FollowUp?.append(FollowUpBooking(patientName: Past.memberName ?? EMPTY, gender: Past.memberGender ?? EMPTY, age: Past.memberDob ?? EMPTY, bookingId: Past.id ?? EMPTY, date: "\(Past.scheduleDate ?? EMPTY), \(Past.scheduleTime ?? EMPTY)", reasonForCall: Past.reasonVisit ?? EMPTY, price: Past.amount ?? EMPTY, followUpDate: Past.followup_date ?? EMPTY, sinchKey: Past.devicetoken ?? EMPTY, prescription: Past.filePdf ?? EMPTY, chatCount: Past.chat_count ?? EMPTY, mobile: Past.mobile ?? EMPTY, chatMode: Past.chatMode ?? EMPTY, rating: Past.rating ?? EMPTY, bookingStatus: Past.bookingStatusName ?? EMPTY, userId: Past.userId ?? EMPTY))
                    }
                }else{
                    if Past.memberName == "Me" {
                        self.previousBookingData.Previous?.append(PreviousBooking(patientName: Past.name ?? EMPTY, gender: Past.memberGender ?? EMPTY, age: Past.memberDob ?? EMPTY, bookingId: Past.id ?? EMPTY, date: "\(Past.scheduleDate ?? EMPTY), \(Past.scheduleTime ?? EMPTY)", reasonForCall: Past.reasonVisit ?? EMPTY, price: Past.amount ?? EMPTY, followUpDate: Past.followup_date ?? EMPTY, sinchKey: Past.devicetoken ?? EMPTY, prescription: Past.filePdf ?? EMPTY, chatCount: Past.chat_count ?? EMPTY, mobile: Past.mobile ?? EMPTY, chatMode: Past.chatMode ?? EMPTY, rating: Past.rating ?? EMPTY, bookingStatus: Past.bookingStatusName ?? EMPTY, userId: Past.userId ?? EMPTY))
                    } else {
                        self.previousBookingData.Previous?.append(PreviousBooking(patientName: Past.memberName ?? EMPTY, gender: Past.memberGender ?? EMPTY, age: Past.memberDob ?? EMPTY, bookingId: Past.id ?? EMPTY, date: "\(Past.scheduleDate ?? EMPTY), \(Past.scheduleTime ?? EMPTY)", reasonForCall: Past.reasonVisit ?? EMPTY, price: Past.amount ?? EMPTY, followUpDate: Past.followup_date ?? EMPTY, sinchKey: Past.devicetoken ?? EMPTY, prescription: Past.filePdf ?? EMPTY, chatCount: Past.chat_count ?? EMPTY, mobile: Past.mobile ?? EMPTY, chatMode: Past.chatMode ?? EMPTY, rating: Past.rating ?? EMPTY, bookingStatus: Past.bookingStatusName ?? EMPTY, userId: Past.userId ?? EMPTY))
                    }
                }
            })
            self.bookingTblVw.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}
*/

//MARK: - ALL BOOKING
extension HomeVC {
    func allBooking(param: [String: String], showLoader: Bool = true){
        if showLoader {
            LoaderController.sharedInstance.showLoader(view: self.view)
        }
        firstly {
            service!.allBooking(parameters: param, header: "DeviceToken")
        }.done { (model: PastBookingModel) in
            self.handleAllBookingResponse(model: model, hideLoader: showLoader)
        }.catch { (error) in
            DispatchQueue.main.async {
                if showLoader {
                    LoaderController.sharedInstance.removeLoader()
                }
            }
        }.finally {
            DispatchQueue.main.async {
                if showLoader {
                    LoaderController.sharedInstance.removeLoader()
                }
            }
        }
    }
    
    func performAllBooking(isRefresh: Bool = true) {
        if isRefresh {
            self.currentPage = 1
            self.isLastPage = false
        }
        
        if self.isLoadingList { return }
        self.isLoadingList = true
        
        var showMainLoader = false
        if !isRefresh {
            self.bottomLoader.startAnimating()
            self.bookingTblVw.tableFooterView = self.bottomLoader
        } else if !self.refreshControl.isRefreshing {
            showMainLoader = true
        }
        
        if !InternetConnection.internetshared.isConnectedToNetwork() {
            self.noInternetView.isHidden = false
            self.refreshControl.endRefreshing()
            self.bottomLoader.stopAnimating()
            if showMainLoader {
                LoaderController.sharedInstance.removeLoader()
            }
            self.isLoadingList = false
            return
        }
        self.noInternetView.isHidden = true
        
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "page": "\(self.currentPage)"]
        
        if let searchText = self.searchTxt.text, !searchText.isEmpty {
            parameter["search"] = searchText
        }
        
        self.allBooking(param: parameter, showLoader: showMainLoader)
    }
    
    func handleAllBookingResponse(model: PastBookingModel, hideLoader: Bool = true) {
        self.isDataFetched = true
        self.isLoadingList = false
        self.refreshControl.endRefreshing()
        self.bottomLoader.stopAnimating()
        self.bookingTblVw.tableFooterView = nil
        print(model)
        if model.status == "SUCCESS" {
            if self.currentPage == 1 {
                self.allBookingData.removeAll()
            }
            if let calls = model.pastbooking?.call {
                if calls.count == 0 {
                    self.isLastPage = true
                } else {
                    self.allBookingData.append(contentsOf: calls)
                }
            } else {
                self.isLastPage = true
            }
            self.bookingTblVw.reloadData()
            if hideLoader { LoaderController.sharedInstance.removeLoader() }
        }else if model.message == "Your credentials are logged in on another device! Please login again."{
            if hideLoader { LoaderController.sharedInstance.removeLoader() }
        } else {
            AppToast.showMessage(message: model.message ?? "")
            if hideLoader { LoaderController.sharedInstance.removeLoader() }
        }
    }
}

//MARK: - CONFIRM BOOKING
extension HomeVC {
    func confirmBooking(param: [String: String]){
        firstly {
            service!.bookingStatus(parameters: param, header: "DeviceToken")
        }.done { (model: BookingStatusModel) in
            self.confirmBoking(model: model)
        }.catch { (error) in
            DispatchQueue.main.async {
            }
            
        }.finally {
            DispatchQueue.main.async {
                // Loader.hide()
            }
        }
    }
    
    func performConfirmBooking(bookingId: String) {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "booking_id": bookingId,
                     "status": "1",
                     "reason": ""]
        confirmBooking(param: parameter)
        
    }
    
    func confirmBoking(model: BookingStatusModel){
        if model.status == "SUCCESS" {
            self.performAllBooking(isRefresh: true)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

//MARK: - REJECT BOOKING
extension HomeVC {
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
        print(model)
        if model.status == "SUCCESS" {
            self.performAllBooking(isRefresh: true)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension HomeVC {
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
    
    func generateAndSendPush() {
        let passDic = ["user_id": self.userId ?? EMPTY,
                       "channel": self.sinchToken ?? EMPTY,
                       "token": self.rtcAgoroToken ?? EMPTY,
                       "doctor_id": self.doctorId ?? EMPTY]
        print(passDic)
        self.generateAndSendPushApi(param: passDic)
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
}

extension HomeVC {
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
    
    func getToken() {
        let passDic = ["isPublisher": "true",
                       "channel": self.sinchToken ?? EMPTY]
        print(passDic)
        self.getTokenApi(param: passDic)
    }
    
    func getTokenModel(model: TokenRoot){
        if model.status == "SUCCESS" {
            self.rtcAgoroToken = model.token ?? EMPTY
            self.generateAndSendPush()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
