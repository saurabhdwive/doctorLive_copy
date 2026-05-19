

import Foundation
import SwiftyJSON

class APICaller {
    
    static let shared = APICaller()
    private var lastRequest: URLRequest?
    private init() { }
}

extension APICaller {
    
    //MARK: - Header :
    
    var headerWithAccess_token:[String: String] {
        var header  = [String: String]()
        var finalToken =  String()
        let user = UserDefaults.standard.string(forKey: Constants.accessToken)
        finalToken = user ?? ""
        let header1 = ["token":" \(finalToken)"]
        header = header1
        
        return header
    }
//    
    func getHeader(withAccessToken:Bool = true , encoded :HeaderEncoded) -> [String: String]{
        var header = [String: String]()
        header = headerWithAccess_token
        switch encoded {
        case .Raw:
             header["content-type"] = "application/json"
        case .urlEncoded:
            header["content-type"] = "application/x-www-form-urlencoded"
        case .multiPart:
            header["content-type"] = "multipart/form-data"
        }
        return header
    }
    
    // this function handle the response if respnse with no error the we will return json other wise nil
    
    func handleResponse(_ response: JSON,
                        callBack:@escaping (_ json: JSON?, _ err: ErrorModel?)->()) {

        let err = ErrorModel(json: response)
        if err.errCode.isSucess { //Success return
            callBack(response, err)
        }else if  err.errCode == .alreadyExist { // already in use
            if response["message"] == "Room already Exists"{
                callBack(response, err)
            }else{
                callBack( nil, err)
            }
            
        }else { //Handling for other cases
            callBack( nil, err)
        }
    }
}


struct ErrorModel {
    
    var success: Bool
    var errCode: StatusCode
    var message: String

    init(json: JSON) {
        
        self.success = json[ApiKey.statusCode].intValue == StatusCode.noError.rawValue
        self.errCode = StatusCode(rawValue: json[ApiKey.statusCode].intValue) ?? .exception
        self.message = json[ApiKey.message].stringValue
    }
}


enum StatusCode: Int {
    
    case noError = 200
    case createSucessfully = 201
    case notFound = 404
    case alreadyExist = 400
    case TOKENIZATION_ERROR = 501
    case exception = -1
    case tokenExpire = 403
    case loginAnotherDevice = 401
    var value: Int {
        return self.rawValue
    }
    var isSucess : Bool {
       return [StatusCode.noError,StatusCode.createSucessfully].contains(self)
    }
}

enum Status : String{
    case sucess = "success"
    case failure = "failure"
    
}

enum HeaderEncoded {
    case urlEncoded
    case Raw
    case multiPart
}

enum RequestMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}


struct ApiKey{
    static let  code = "code"
    static let  statusCode = "statusCode"
    static let  message = "message"
    static let  firstName = "firstName"
    static let  lastName = "lastName"
    static let  country = "country"
    static let  fullName = "fullName"
    static let  emailId = "EmailId"
    static let  dateOfBirth = "dateOfBirth"
    static let  _id = "_id"
    static let  responseCode = "response_code"
    static let  data = "Data"
    static let  otp = "otp"
    static let  deviceType = "DeviceType"
    static let  deviceToken = "DeviceToken"
    static let  passcode = "Passcode"
    static let  newPassword = "newPassword"
    static let  compareNewPassword = "compareNewPassword"
    static let  accessToken = "token"
    static let  pageNumber = "pageNumber"
    static let  userID = "userID"
    static let  userId = "userId"
    static let  likeStatus = "likeStatus"
    static let  postId = "postId"
    static let  phoneNumber = "phoneNumber"
    static let  languageSetting = "languageSetting"
    static let  jwtToken = "jwtToken"
    static let  username = "username"
    static let  status = "status"
    static let errors = "errors"
    static let  error = "error"
    static let  detail = "detail"
    static let authorization = "Authorization"
}
