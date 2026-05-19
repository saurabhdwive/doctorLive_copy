//  NetworkAccess.swift
//  AfriPayChat
//  Created by Ashok kumar on 3/5/21.
//  Copyright © 2020 Apponward Technologies Pvt Ltd. All rights reserved.

import Foundation

struct NetworkAccess {
    struct ProductionServer {
        static var baseURL = "http://mobuloustech.com/drlive/api/doctor/"
    }
    
    struct SubUrl {
        static let registration = ProductionServer.baseURL + "signup"
        static let userName = ProductionServer.baseURL + "v1/user/username"
        static let verifyEmail = ProductionServer.baseURL + "checkemail"
        static let login = ProductionServer.baseURL + "login"
    }
}

struct Constants {
    static var mobileNo = "mobileNo"
    static var amount = "amount"
    static var languageCode = "languageCode"
    static var countryCode = "countryCode"
    static var accountStatus = "accountStatus"
    static let isAvtive = "isAvtive"
    static let bearer = "Bearer"
    static let loading = "Loading..."
    static let accessToken =  "LoginAccessToken"
    static let anonymousid =  "anonymousid"
    static let isLogin = "isLogin"
    static let isSignup = "isSignup"
    static var verificationId = "verificationId"
    static let isSocial = "isSocial"
    static let userType = "userType"
    static let userName = "userName"
    static let artistUser = "artist_user"
    static let password = "password"
    static let email = "email"
    static let loginProvider = "loginProvider"
    static let socialID = "socialID"
    static let isAppleLogin = "isAppleLogin"
    static let transactionId = "transactionId"
    static let userId = "UserId"
    static let deviceId = "deviceId"
    static let text = "text"
    static let error = "Error"
    static var authorization = "Authorization"
    static var cancelled = "cancelled"
    static let textColur = "TextColur"
    static let AWSBUCKETNAME = "healthplus-s3-private"
    static let encryptionKey = "encryptionKey"
    static let bankName = "bankName"
    static let accountNo = "accountNo"
    static let bankId = "bankId"
    static let userImage = "userImage"
   
}

//public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

enum ParametersEncoding {
    case url
    case json
}

enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
    case cancelled
}

enum Result1<Value: Decodable> {
    case success1(Value)
    case failure1(Error)
}
enum NetworkError: Error {
    case badUrl
    case noJSONData
    case nullData
}

enum ApiError: Error {
    
    case clientError
    case serverError
    case noData
    case invalidStatusCode
    case JSONError
    case invalidRequest
    case responseError(error: String)
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        
        switch self {
        case .invalidStatusCode:
            return NSLocalizedString("Invalid Status Code.", comment: "Invalid Status")
        case .clientError:
            return NSLocalizedString("Client Error.", comment: "Client Error")
        case .serverError:
            return NSLocalizedString("Server Error.", comment: "Server Error")
        case .noData:
            return NSLocalizedString("No Data found.", comment: "Data Error")
        case .JSONError:
            return NSLocalizedString("Model Error", comment: "JSON Error")
        case .invalidRequest:
            return NSLocalizedString("Invalid Request", comment: "Invalid Request")
        case .responseError(let error):
            return NSLocalizedString(error, comment: "Response Error")
        }
    }
}
