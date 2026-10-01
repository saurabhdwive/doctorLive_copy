//
//  UpcomingBookingVC+ApiService.swift
//  DoctorLive
//
//  Created by Kv on 06/09/24.
//

import Foundation
import PromiseKit
import UIKit

extension UpcomingBookingVC {
    
    func fullProfile(param: [String: String]) {
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
    
    func validations() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        fullProfile(param: parameter)
    }
    
    func handleResponse(model: PendingBookingModel) {
        if model.status == "SUCCESS" {
            self.bookingOnCallArray = model.pendingbooking?.call ?? [Call]()
            self.bookingOnVisit = model.pendingbooking?.visit ?? [Visit]()
            self.tableView1.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension UpcomingBookingVC {
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
        upcomingBooking(param: parameter)
    }
    
    func handleUpcomingResponse(model: UpcomingBookingModel){
        if model.status == "SUCCESS" {
            print(model)
            self.upcomingOnCall = model.upcomingbooking?.call ?? [UpComingCall]()
            self.upcomingVisit = model.upcomingbooking?.visit ?? [UpComingVisit]()
            self.upcomingTableView.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            // AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension UpcomingBookingVC {
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
        pastBooking(param: parameter)
    }
    
    func handlePastResponse(model: PastBookingModel) {
        if model.status == "SUCCESS" {
            print(model)
            self.pastOnCall = model.pastbooking?.call ?? [PastCall]()
            self.pastVisit = model.pastbooking?.visit ?? [PastVisit]()
            self.pastBookingTableView.reloadData()
            LoaderController.sharedInstance.removeLoader()
        } else {
            AppToast.showMessage(message: model.message ?? "")
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

extension UpcomingBookingVC {
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
    
    func performConfirmBooking() {
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
            self.validations()
            self.dismiss(animated: true, completion: nil)
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}

extension UpcomingBookingVC {
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
    
    func performEndCall() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token,
                     "booking_id": self.endCallId,
                     "status": "6",
                     "reason": ""]
        endVisitBooking(param: parameter)
    }
    
    func endBooking(model: BookingStatusModel){
        if model.status == "SUCCESS" {
            self.validations()
        } else {
            AppToast.showMessage(message: model.message ?? "")
        }
    }
}
extension UpcomingBookingVC {
    func myWidhraw(param: [String: String]){
        LoaderController.sharedInstance.showLoader(view: self.view)
        firstly {
            service!.notificationUnRead(parameters: param, header: "DeviceToken")
        }.done { (model: NotificationUnreadModel) in
            self.myWidhrawResponse(model: model)
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
    
    func performNotificationUnread() {
        var parameter = [String: String]()
        guard let token = UserDefaults.standard.string(forKey: Constants.accessToken) else { return }
        guard let code = UserDefaults.standard.string(forKey: Constants.languageCode) else { return }
        parameter = ["language_type": code,
                     "token": token]
        myWidhraw(param: parameter)
    }
    
    func myWidhrawResponse(model: NotificationUnreadModel) {
        if model.status == "SUCCESS" {
            notificationCountTxt.text = String(model.notificationunread ?? 0)
            LoaderController.sharedInstance.removeLoader()
        } else {
            LoaderController.sharedInstance.removeLoader()
        }
    }
}

