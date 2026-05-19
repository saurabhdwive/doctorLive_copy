//
//  Constants.swift
//  SampleProject
//
//  Created by Admin on 17/03/21.
//
import  UIKit

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let kScreenHeight = UIScreen.main.bounds.height
let kScreenWidth = UIScreen.main.bounds.width
let kUserDefaults = UserDefaults.standard
let kAdUnitID = "ca-app-pub-3940256099942544/2934735716"


let kAppName                    = "Dr.Live"
let kIsTutorialAlreadyShown     = "isTutorialAlreadyShown"
let kIsUserLoggedIn             = "isUserLoggedIn"
let kLoggedInAccessToken        = "access_token"
let kLoggedInUserDetails        = "loggedInUserDetails"
let kLoggedInUserId             = "loggedInUserId"
let kLatitude                   = "latitude"
let kLongitude                  = "longitude"
let kIsOtpVerified              = "is_mobile_verified"
let kIsProfileCreated           = "is_profile_create"
let kIs_Active                  = "is_active"
let kIs_Notification            = "is_notification"
let kIsAppInstalled             = "isAppInstalled"
let kAccessToken                = "access_token"
let kDeviceToken                = "device_token"
let iosDeviceType               = "1"
let iosDeviceTokan              = "123456789"

struct AppConstants {
    
    static let appPin = "UserAppPin"
    static let loginToken = "loginToken"
    static let activeEmail = "activeEmail"
    
    static var mobileNo = "mobileNo"
    static var countryCode = "countryCode"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let paymentId = "paymentId"
    static let bioMetric = "bioMetric"
    static let okraKey = "6593af6f-163e-59cb-a8ed-ac4fa1ef9816"
    static let okraToken = "60786d66a1dd93252ac72613"
    static let okraProducts = ["auth", "balance", "identity", "transactions"]
    static let okraEnv = "production-sandbox"
    static let okraClientName = "AfriCash"
    static let okraConnectMsg = "Which account do you want to connect with?"
    static let okraWidget_success = "Your account was successfully linked to Okra, Inc"
    static let okraWidget_failed = "Which account do you want to connect with?"
    static let okraSuccess_title = "Successfully connect bank"
    static let okraSuccess_message = "You have successfully connected your bank account"
    static let balance = "balance"
    static let userId = "userId"
}
struct UserDefaultKeys{
    static let token = "token"
    static let status = "status"
    static let jwtToken = "jwtToken"
    static let tokenType = "tokenType"
    static let id = "id"
    static let kIsVerified = "isVerified"
    static let kIsLoggedIn = "isLogin"
    static let photo = "photo"
    static let accountType = "accountType"
    static let name = "name"
    static let jobTitle = "jobTitle"
    static let cityCode = "cityCode"
    static let email = "email"
    static let dob = "dob"
    static let gender = "gender"
    static let address = "address"
    static let isActive = "isActive"
    static let verified = "verified"
    static let uuid = "UUID"
    static let deviceToken = "DeviceToken"
    static let subsriptionStatus = "SubsriptionStatus"
    static let userSubscription = "UserSubscription"
    static let countryCode = "countryCode"
    static let mobileNumber = "mobileNumber"
}
struct Console{
    static func log(_ message: Any?){
        print(message ?? ErrorMessages.errorNothingToLog)
    }
}
struct ErrorMessages{
    static let errorToHandleInSuccess = "Something is wrong while getting success"
    static let errorToHandleInFailure = "Something is wrong while getting failure"
    static let errorNothingToLog = "There is nothing to log on console"
    static let somethingWentWrong = "Something went wrong"
    static let unableToParseError = "Unable to parse error response"
    static let invalidUserId = "Unable to find userId"
    static let networkError = "Network not available"
}
