//
//  NetworkApi.swift
//  Healthcare
//
//  Created by mobulous on 19/05/21.
//

import Foundation
import PromiseKit
var service: ApiInterface?

protocol ApiInterface {
    func signup<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func login<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func forgetPass<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func checkemail<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func speciality<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func qualification<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func experince<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func bankDetails<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func bankList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func completeProfile<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func fullCompleteProfile<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func updateQualification<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func doctorProfile<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func updateExpience<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func updateBank<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func updateProfile<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func deleteQualification<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func deleteExperince<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func clinicList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func AddclinicList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func deleteclinicList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func forgetPasss<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func updateProfessionalDetails<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func pendingBooking<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func bookingStatus<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func suggestedTime<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func upcomingBooking<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func pastBooking<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func chatHistory<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func getAvilabilityList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func getAvilabilityList1<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>

    func setAvilability<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func deleteVisitAvilability<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func myEarning<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func myWidhraw<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func widhrawAmount<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func changePassword<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func changeLanguage<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func editClinic<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func medicineList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func NotificationList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func doctorAvilability<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func drFee<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func drFeeUpdate<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func notificationRead<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func notificationUnRead<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func investigationList<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func deleteClinicVisit<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func validateMobile<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func loginWithOtp<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func appVersionPopup<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    
    
    func generateAndSendPush<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func getToken<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    func allBooking<T: Decodable>(parameters:[ String: Any]?,header:String?) -> Promise<T>
    
}

final class Network: ApiInterface {
    func appVersionPopup<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        appVersionPopUp.requestWithParams(.appVersionPopUp, parameters: parameters,header: header)
    }
    
    func loginWithOtp<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        avilabilityFetchclient.requestWithParams(.loginWithOtp, parameters: parameters,header: header)
    }
    
    func validateMobile<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        avilabilityFetchclient.requestWithParams(.validateNumber, parameters: parameters,header: header)
    }
    
    func deleteClinicVisit<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        avilabilityFetchclient.requestWithParams(.deleteClinicVisit, parameters: parameters,header: header)
    }
    
    func investigationList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.investigationList, parameters: parameters,header: header)
    }
    
    func notificationUnRead<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.notificationUnRead, parameters: parameters,header: header)
    }
    
    func notificationRead<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.notificationRead, parameters: parameters,header: header)
    }
    
    func drFeeUpdate<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.doctorFeeUpdate, parameters: parameters,header: header)
    }
    
    func drFee<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.doctorFee, parameters: parameters,header: header)
    }
    
    func doctorAvilability<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.doctorAvilability, parameters: parameters,header: header)
    }
    
    func NotificationList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.notification, parameters: parameters,header: header)
    }
    
    func medicineList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.medicineList, parameters: parameters,header: header)
    }
    
    func editClinic<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.editClinic, parameters: parameters,header: header)
    }
    
    func changeLanguage<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.changeLanguage, parameters: parameters,header: header)
    }
    
    func changePassword<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.changePass, parameters: parameters,header: header)
    }
    
    func widhrawAmount<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.widhrawRequest, parameters: parameters,header: header)
    }
    
    func myWidhraw<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.myWidhraw, parameters: parameters,header: header)
    }
    
    func myEarning<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.myEarning, parameters: parameters,header: header)
    }
    
    func deleteVisitAvilability<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.deleteAvialability, parameters: parameters,header: header)
    }
    
    func setAvilability<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.setAvilability, parameters: parameters,header: header)
    }
    
    func getAvilabilityList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        avilabilityFetchclient.requestWithParams(.getAvilability, parameters: parameters,header: header)
    }
    func getAvilabilityList1<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        avilabilityFetchclient.requestWithParams(.getAvilability, parameters: parameters,header: header)
    }
    func chatHistory<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.chatHistory, parameters: parameters,header: header)
    }
    
    func pastBooking<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.pastBooking, parameters: parameters,header: header)
    }
    
    func upcomingBooking<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.upcomingBooking, parameters: parameters,header: header)
    }
    
    func bookingStatus<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.bookingStatus, parameters: parameters,header: header)
    }

    func suggestedTime<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.suggestedTime, parameters: parameters,header: header)
    }
    
    func pendingBooking<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.pendingBooking, parameters: parameters,header: header)
    }
    
    func updateProfessionalDetails<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.updateProfessionalDetails, parameters: parameters,header: header)
    }
    
    func forgetPasss<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.forgetPassword, parameters: parameters,header: header)
    }
    
    func deleteclinicList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
      client.requestWithParams(.deleteClinic, parameters: parameters,header: header)
    }
    
    func AddclinicList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.addClinic, parameters: parameters,header: header)
    }
    
    func clinicList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.clinicList, parameters: parameters,header: header)
    }
    
    func deleteExperince<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.deleteExperience, parameters: parameters,header: header)
    }
    
    func deleteQualification<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.deleteQualification, parameters: parameters,header: header)
    }
    
    func updateProfile<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.updateProfile, parameters: parameters,header: header)
    }
    
    func updateBank<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.updateBank, parameters: parameters,header: header)
    }
    
    func updateExpience<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.updateExperince, parameters: parameters,header: header)
    }
    
    func doctorProfile<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.personalProfile, parameters: parameters,header: header)
    }
    
    func updateQualification<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.updateQualification, parameters: parameters,header: header)
    }
    
    func fullCompleteProfile<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.fullProfile, parameters: parameters,header: header)
    }
    
    func completeProfile<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.completeProfile, parameters: parameters,header: header)
    }
    
    func bankList<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.bankList, parameters: parameters,header: header)
    }
    
    func bankDetails<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.bankDetails, parameters: parameters,header: header)
    }
    
    func experince<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.experince, parameters: parameters,header: header)
    }
    
    func qualification<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.qualification, parameters: parameters,header: header)
    }
    
    func speciality<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.speciality, parameters: parameters,header: header)
    }
    func signup<T>(parameters: [String : Any]?,header:String?) -> Promise<T> where T : Decodable {
        client.requestWithParams(.signup, parameters: parameters,header: header)
    }
    
    func checkemail<T>(parameters: [String : Any]?,header:String?) -> Promise<T> where T : Decodable {
        return client.requestWithParams(.validateUser, parameters: parameters,header: header)
    }
    
    func login<T>(parameters: [String : Any]?,header:String?) -> Promise<T> where T : Decodable {
        return client.requestWithParams(.login, parameters: parameters,header: header)
    }
    
    func forgetPass<T>(parameters: [String : Any]?,header:String?) -> Promise<T> where T : Decodable {
        return client.requestWithParams(.forgetPass , parameters: parameters,header: header)
    }
    
    func generateAndSendPush<T>(parameters: [String : Any]?,header:String?) -> Promise<T> where T : Decodable {
        return appVersionPopUp.requestWithParams(.generateAndSendPush , parameters: parameters,header: header)
    }
    
    func getToken<T>(parameters: [String : Any]?,header:String?) -> Promise<T> where T : Decodable {
        return appVersionPopUp.requestWithParams(.getToken , parameters: parameters,header: header)
    }
    
    func allBooking<T>(parameters: [String : Any]?, header: String?) -> Promise<T> where T : Decodable {
        return client.requestWithParams(.allBooking, parameters: parameters, header: header)
    }
    
   
    private let client = RestClient(baseURL: "https://doctorlivebd.com/api/doctor/")
    
    //private let client = RestClient(baseURL: "http://3.129.241.38/api/doctor/")
    private let avilabilityFetchclient = RestClient(baseURL: "https://doctorlivebd.com/api/doctors/")
    private let appVersionPopUp = RestClient(baseURL: "https://doctorlivebd.com/api/")
    
    init() {
        
    }
}
