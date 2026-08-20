//
//  RestClient.swift
//  Healthcare
//
//  Created by mobulous on 19/05/21.
//


import Foundation
import Alamofire
import PromiseKit
import UIKit

//import Kingfisher

struct MultiPart{
    let data: Data
    let fileNameWithExt: String
    let serverKey: String
    let mimeType: MediaType1
}
enum MediaType1: String {
    case image = "image/png"
    case video = "video/mov"
}
 enum Resource {
    case signup
    case login
    case forgetPass
    case validateUser
    case speciality
    case qualification
    case experince
    case bankDetails
    case bankList
    case completeProfile
    case fullProfile
    case updateQualification
    case personalProfile
    case updateExperince
    case updateBank
    case updateProfile
    case deleteQualification
    case deleteExperience
    case clinicList
    case addClinic
    case deleteClinic
    case forgetPassword
    case updateProfessionalDetails
    case pendingBooking
    case bookingStatus
    case upcomingBooking
    case pastBooking
    case chatHistory
    case getAvilability
    case setAvilability
    case deleteAvialability
    case myEarning
    case myWidhraw
    case widhrawRequest
    case changePass
    case changeLanguage
    case editClinic
    case medicineList
    case notification
    case doctorAvilability
    case doctorFee
    case doctorFeeUpdate
    case notificationRead
    case notificationUnRead
    case investigationList
    case deleteClinicVisit
    case validateNumber
    case loginWithOtp
    case appVersionPopUp
    case generateAndSendPush
    case getToken
    case allBooking

    var resource: (method: HTTPMethod, endPoint: String) {
        switch self {
        case .signup:
            return (.post ,"signup")
        case .login:
            return (.post, "login")
        case .validateUser:
            return (.post, "checkemail")
        case .forgetPass:
            return (.post, "updatepassword")
        case .speciality:
            return (.post, "specialtylist")
        case .qualification:
            return (.post, "addqualificationdetail")
        case .experince:
            return (.post, "addexperiencedetail")
        case .bankDetails:
            return (.post, "addbank")
        case .bankList:
            return (.post, "banklist")
        case .completeProfile:
            return (.post, "addprofessionaldetail")
        case .fullProfile:
            return (.post, "professionaldetail")
        case .updateQualification:
            return (.post, "updatequalification")
        case .personalProfile:
            return (.post, "personaldetail")
        case .updateExperince:
            return (.post, "updateexperience")
        case .updateBank:
            return (.post, "updatebankdetail")
        case .updateProfile:
            return (.post, "updatepersonaldetail")
        case .deleteQualification:
            return (.post, "deletequalification")
        case .deleteExperience:
            return (.post, "deleteexperience")
        case .clinicList:
            return (.post, "cliniclisting")
        case .addClinic:
            return (.post, "addclinic")
        case .deleteClinic:
            return (.post, "deleteclinic")
        case .forgetPassword:
            return (.post, "forgotpassword")
        case .updateProfessionalDetails:
            return (.post, "updateprofessionaldetail")
        case .pendingBooking:
            return (.post, "pendingbooking")
        case .bookingStatus:
            return (.post, "bookingstatuschange")
        case .upcomingBooking:
            return (.post, "upcomingbooking")
        case .pastBooking:
            return (.post, "pastBooking")
        case .chatHistory:
            return (.post, "doctorchathistory")
        case .getAvilability:
            //return (.post, "availabilityfetch")
            return (.post, "slots/fetch")
        case .setAvilability:
            return (.post, "addavailability")
        case .deleteAvialability:
            return (.post, "deleteavailability")
        case .myEarning:
            return (.post, "myearning")
        case .myWidhraw:
            return (.post, "mywithdraw")
        case .widhrawRequest:
            return (.post, "withdrawrequest")
        case .changePass:
            return (.post, "changepassword")
        case .changeLanguage:
            return (.post, "savelanguage")
        case .editClinic:
            return (.post, "editclinic")
        case .medicineList:
            return (.post, "medicinelisting")
        case .notification:
            return (.post, "mynotification")
        case .doctorAvilability:
            return (.post, "changeonline")
        case .doctorFee:
            return (.post, "feesdetail")
        case .doctorFeeUpdate:
            return (.post, "editfees")
        case .notificationRead:
            return (.post, "notificationread")
        case .notificationUnRead:
            return (.post, "notificationunread")
        case .investigationList:
            return (.get, "gettestinglist")
        case .deleteClinicVisit:
            return (.post, "slots/delete")
        case .validateNumber:
            return (.post, "auth/validatemobile")
        case .loginWithOtp:
            return (.post, "auth/loginwithotp")
        case .appVersionPopUp:
            return (.get, "common/version")
        case .generateAndSendPush:
            return (.post, "user/generateAndSendPush")
        case .getToken:
            return (.post, "user/getToken")
        case .allBooking:
            return (.post, "allbooking")
        }
    }
}
class RestClient {
    var baseURL: String
    let session = AF
    init(baseURL: String){
        self.baseURL = baseURL
    }
    
    func requestWithParams<T: Decodable>(_ resource: Resource,
                                         parameters: [String: Any]? ,header:String?) -> Promise <T> {
        return Promise { seal in
            let method = resource.resource.method
            var url = "\(baseURL)\(resource.resource.endPoint)"
            if resource.resource.endPoint.contains("http"){
                url = resource.resource.endPoint
            }
            //if showLoader {
            //Loader.show()
           // Console.log("LoaderShow")
            //}
//            var headr = Alamofire.HTTPHeaders()
//            var temp = header == "DeviceToken" ? getHeadeWithDeviceToken(): getHeadeWithJwtToken()
//
//
//            for (k,v) in temp {
//                headr.add(Alamofire.HTTPHeader(name: k, value: v))
//            }

            
            let headers = HTTPHeaders(getHeadeWithDeviceToken())
            print("================= API REQUEST ======================")
            print("🚀 URL: \(url)")
            print("🚀 Method: \(method.rawValue)")
            print("🚀 Headers: \(headers.dictionary)")
            if let params = parameters {
                print("🚀 Params: \(params)")
            }
            print("====================================================")
            
            session.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { (response) in
                if let data = response.data,
                    let jsonString = String(data: data, encoding: .utf8) {
                     print("Response String:")
                     print(jsonString)
                 }
                
                let loggedInOtherDeviceMessages = [
                    "Your credentials are logged in on another device! Please login again.",
                    "Your credentials is loggedIn in another device! Please login again."
                ]
//                if let data = response.data,
//                   let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let status = jsonDict["status"] as? String,
//                   let message = jsonDict["message"] as? String,
//                   status == "FAILURE",
//                   message.contains(loggedInOtherDeviceMessages) {
//                    print(message)
//                    
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "DoctorLive", message: message, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
//                            let menuVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                            let navigationController = UINavigationController(rootViewController: menuVC)
//                            navigationController.isNavigationBarHidden = true
//                            UIApplication.shared.windows.first?.rootViewController = navigationController
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                        }))
//                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//                        UserDefaults.standard.set(false, forKey: Constants.accountStatus)
//                    }
//                }
                
                if let data = response.data,
                   let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = jsonDict["status"] as? String,
                   let message = jsonDict["message"] as? String,
                   status == "FAILURE",
                   loggedInOtherDeviceMessages.contains(where: { message.contains($0) }) {

                    print("🚨 Logged in on another device: \(message)")

                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "DoctorLive",
                            message: message,
                            preferredStyle: .alert
                        )

                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in

                            UserDefaults.standard.set(false, forKey: Constants.accountStatus)

                            let storyboard = UIStoryboard(name: "Auth", bundle: nil)

                            let loginVC = storyboard.instantiateViewController(
                                withIdentifier: "LoginVC"
                            ) as! LoginVC

                            let navigationController = UINavigationController(
                                rootViewController: loginVC
                            )

                            navigationController.isNavigationBarHidden = true

                            if let windowScene = UIApplication.shared.connectedScenes
                                .first(where: {
                                    $0.activationState == .foregroundActive
                                }) as? UIWindowScene,
                               let window = windowScene.windows
                                .first(where: { $0.isKeyWindow }) {

                                window.rootViewController = navigationController
                                window.makeKeyAndVisible()
                            }
                        })

                        if let windowScene = UIApplication.shared.connectedScenes
                            .first(where: {
                                $0.activationState == .foregroundActive
                            }) as? UIWindowScene,
                           let window = windowScene.windows.first(where: {
                               $0.isKeyWindow
                           }),
                           let rootVC = window.rootViewController {

                            rootVC.present(alert, animated: true)
                        }
                    }
                }
                
                switch response.result {
                case .success(let data):
                    seal.fulfill(data)
                case .failure(let error):
                    seal.reject(self.actualError(error: error))
                }
                self.logRequest(response: response, param: parameters)
                self.logResponse(data: response.data)
            }
        }
    }
    
    func logResponse(data:Data?) {
        guard let dataValue = data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: dataValue, options: .allowFragments) as? [String:Any] {
            Console.log(RestClient.prettyPrintDict(with: json))
        }
        else {
            Console.log(String(data: dataValue, encoding: .utf8))
        }
    }
    
    func logRequest<T>(response: DataResponse<T, AFError>, param: [String: Any]?) {
        let url = response.request?.url
        let httpMethod = response.request?.httpMethod
        let code = response.response?.statusCode
        let header = response.response?.headers
        
        Console.log("URL:- \(url)")
        Console.log("HttpMethod:- \(httpMethod)")
        Console.log("Code:- \(code)")
        Console.log("Param:- \(param)")
        Console.log("header:- \(header)")
    }
    
     class func prettyPrintDict(with json: [String : Any]) -> String{
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            if let string  = string{
                return string
            }
        }catch{
            Console.log(error.localizedDescription)
        }
        return ""
    }
    
//    func upload<T: Decodable>(_ resource: Resource, onProgress: @escaping (Double)-> (),
//                              parameters: [String: Any]?) -> Promise <T> {
//        return Promise { seal in
//
//            let method = resource.resource.method
//            var url = "\(baseURL)\(resource.resource.endPoint)"
//            if resource.resource.endPoint.contains("http"){
//                url = resource.resource.endPoint
//            }
//            Console.log("LoaderShow")
//            session.upload(multipartFormData: { multiPart in
//                guard let params = parameters else{return}
//                for (key, value) in params {
//                    if let allMedia = value as? [MultiPart]{
//                        let allkeys = allMedia.map({$0.serverKey})
//                        let unique = Array(Set(allkeys))
//                        for serverKey in unique{
//                            let uploadFile = allMedia.filter({$0.serverKey == serverKey})
//                            if uploadFile.count > 1 {
//                                for media in uploadFile{
//                                    multiPart.append(media.data, withName: "\(media.serverKey)[]", fileName: media.fileNameWithExt, mimeType: media.mimeType.rawValue)
//                                }
//                            }else{
//                                if let media = uploadFile.first{
//                                    multiPart.append(media.data, withName: media.serverKey, fileName: media.fileNameWithExt, mimeType: media.mimeType.rawValue)
//                                }
//                            }
//                        }
//                    }else if let media = value as? MultiPart{
//                        multiPart.append(media.data, withName: media.serverKey, fileName: media.fileNameWithExt, mimeType: media.mimeType.rawValue)
//                    }else if let data = "\(value)".data(using: .utf8) {
//                        multiPart.append(data, withName: key)
//                    }
//
//                }
//            },to: url, method: method, headers: HTTPHeaders(getHeaderData()))
//                .uploadProgress(queue: .main, closure: { progress in
//                    onProgress(progress.fractionCompleted)
//                })
//                .responseDecodable(of: T.self) { (response) in
//                    switch response.result{
//                    case .success(let data):
//                        seal.fulfill(data)
//                    case .failure(let error):
//                        seal.reject(self.actualError(error: error))
//                    }
//                    self.logRequest(response: response, param: parameters)
//                    self.logResponse(data: response.data)
//
//            }
//
//
//        }
//    }
    
    func requestWithBody<T: Decodable>(_ resource: Resource,
                                       parameters: [String: Any]?,header:String?) -> Promise <T> {
        return Promise { seal in
            
            let method = resource.resource.method
            var url = "\(baseURL)\(resource.resource.endPoint)"
            if resource.resource.endPoint.contains("http"){
                url = resource.resource.endPoint
            }
            //if showLoader {
            //Loader.show()
            Console.log("LoaderShow")
            
            //}
           
            var headr = Alamofire.HTTPHeaders()
            var temp = header == "DeviceToken" ? getHeadeWithDeviceToken(): getHeadeWithJwtToken()
            
            
            for (k,v) in temp {
                headr.add(Alamofire.HTTPHeader(name: k, value: v))
            }
            
            print("================= API REQUEST (BODY) ===============")
            print("🚀 URL: \(url)")
            print("🚀 Method: \(method.rawValue)")
            print("🚀 Headers: \(headr.dictionary)")
            if let params = parameters {
                print("🚀 Params: \(params)")
            }
            print("====================================================")
            
            session.upload(multipartFormData: { multiPart in
                guard let params = parameters else{return}
                for (key, value) in params {
                    if let data = "\(value)".data(using: .utf8) {
                        multiPart.append(data, withName: key)
                    }
                }
            },to: url, method: method, headers: headr
                )
                .uploadProgress(queue: .main, closure: { progress in
                    //onProgress(progress.fractionCompleted)
                })
                .responseDecodable(of: T.self) { (response) in
//                    if let data = response.data,
//                       let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let status = jsonDict["status"] as? String,
//                       let message = jsonDict["message"] as? String,
//                       status == "FAILURE",
//                       message == "Your credentials is loggedIn in another device! Please login again." {
//                        
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "DoctorLive", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                                let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
//                                let menuVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                                let navigationController = UINavigationController(rootViewController: menuVC)
//                                navigationController.isNavigationBarHidden = true
//                                UIApplication.shared.windows.first?.rootViewController = navigationController
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            }))
//                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//                            UserDefaults.standard.set(false, forKey: Constants.accountStatus)
//
//                        }
//                    }
                    let loggedInOtherDeviceMessages = [
                        "Your credentials are logged in on another device! Please login again.",
                        "Your credentials is loggedIn in another device! Please login again."
                    ]
                    
                    if let data = response.data,
                       let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = jsonDict["status"] as? String,
                       let message = jsonDict["message"] as? String,
                       status == "FAILURE",
                       loggedInOtherDeviceMessages.contains(where: { message.contains($0) }) {

                        print("🚨 Logged in on another device: \(message)")

                        DispatchQueue.main.async {
                            let alert = UIAlertController(
                                title: "DoctorLive",
                                message: message,
                                preferredStyle: .alert
                            )

                            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in

                                UserDefaults.standard.set(false, forKey: Constants.accountStatus)

                                let storyboard = UIStoryboard(name: "Auth", bundle: nil)

                                let loginVC = storyboard.instantiateViewController(
                                    withIdentifier: "LoginVC"
                                ) as! LoginVC

                                let navigationController = UINavigationController(
                                    rootViewController: loginVC
                                )

                                navigationController.isNavigationBarHidden = true

                                if let windowScene = UIApplication.shared.connectedScenes
                                    .first(where: {
                                        $0.activationState == .foregroundActive
                                    }) as? UIWindowScene,
                                   let window = windowScene.windows
                                    .first(where: { $0.isKeyWindow }) {

                                    window.rootViewController = navigationController
                                    window.makeKeyAndVisible()
                                }
                            })

                            if let windowScene = UIApplication.shared.connectedScenes
                                .first(where: {
                                    $0.activationState == .foregroundActive
                                }) as? UIWindowScene,
                               let window = windowScene.windows.first(where: {
                                   $0.isKeyWindow
                               }),
                               let rootVC = window.rootViewController {

                                rootVC.present(alert, animated: true)
                            }
                        }
                    }
                    
                    switch response.result{
                    case .success(let data):
                        seal.fulfill(data)
                    case .failure(let error):
                        seal.reject(self.actualError(error: error))
                    }
                    self.logResponse(data: response.data)
                    self.logRequest(response: response, param: parameters)
            }
        }
    }
    
    
    func getHeadeWithDeviceToken() -> [String: String]{
        var headers = [String: String]()
        if let token = kUserDefaults.value(forKey: UserDefaultKeys.deviceToken) as? String {
            headers = [
                "Authorization": token
            ]
        }
        headers["deviceType"] = "ios"
        headers["Accept"] = "application/json"
        return headers
    }
    
    func getHeadeWithJwtToken() -> [String: String] {
        var headers = [String: String]()
        if let token = kUserDefaults.value(forKey: UserDefaultKeys.jwtToken) as? String {
            headers = [
                "Authorization": token
            ]
        }
        headers["deviceType"] = "ios"
        headers["Accept"] = "application/json"
        return headers
    }
    func actualError(error: AFError) -> Error{
        if let underlyingError = error.underlyingError {
            if let urlError = underlyingError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    return NSError(domain:"", code:urlError.code.rawValue, userInfo:[ NSLocalizedDescriptionKey: "The Internet connection appears to be offline."])
                case .networkConnectionLost:
                    return NSError(domain:"", code:urlError.code.rawValue, userInfo:[ NSLocalizedDescriptionKey: "The Internet connection appears to be offline."])
                default:
                    //Do something
                    return error
                }
            }
        }
        return error
    }
    
    class func checkIfFileExists(urlString: String) -> Bool{
        guard let url = URL(string: urlString) else {return false}
        let pathUrl = getDirectoryPath()
        if let fullPathUrl = pathUrl?.appendingPathComponent(url.lastPathComponent) {
            return FileManager.default.fileExists(atPath: fullPathUrl.path)
        }
        
        return false
        
    }
    class func getDirectoryPath()-> URL?{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    class func getDocumentDirectoryFilePath(string: String) -> URL?{
        let pathUrl = getDirectoryPath()
        return pathUrl?.appendingPathComponent(string)
    }
    class func saveFilesToDocumentDirectory(lastPath: String, data: Data) {
        let pathUrl = getDirectoryPath()
        if let fullPathUrl = pathUrl?.appendingPathComponent(lastPath) {
            do {
                // writes the image data to disk
                try data.write(to: fullPathUrl)
                print("file saved \(lastPath)")
            } catch {
                print("error saving file: \(error) path \(lastPath)")
            }
        }
    }
    class func removeFilesFromDocumentDirectory(lastPath: String){
        let pathUrl = getDirectoryPath()
        print("Path Url:- \(pathUrl)")
        if let fullPathUrl = pathUrl?.appendingPathComponent(lastPath) {
            let fileManager = FileManager.default
            do{
            try fileManager.removeItem(at: fullPathUrl)
                 print("file removed \(lastPath)")
            }catch{
                 print("error removing file: \(error) path \(lastPath)")
            }
        }
    }

    class func removeDocumentDirectory() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try fileManager.removeItem(at: myDocuments)
        } catch {
            return
        }
    }
    
//    class func getImageFromCacheOrDownload(url: URL) {
//        let fullUrlSting = url.absoluteString
//        guard let fullUrl = URL(string: fullUrlSting) else {
//            DisplayBanner.show(message: "Invaliad url found, getSaveDownloadImage")
//            return
//        }
//        KingfisherManager.shared.retrieveImage(with: fullUrl, options: nil, progressBlock: nil) {(image, error, cache, imageUrl) in
//            if let error = error {
//                Console.log(error)
//                return
//            }
//            guard let image = image, let data = image.jpegData(compressionQuality: 1.0) else {return}
//            saveFilesToDocumentDirectory(lastPath: url.lastPathComponent, data: data)
//        }
//    }
    
}
//enum HTTPHeaderField: String {
//    
//    case authentication  = "Authorization"
//    case contentType     = "Content-Type"
//    case acceptType      = "Accept"
//    case acceptEncoding  = "Accept-Encoding"
//    case acceptLangauge  = "Accept-Language"
//    
//    var header:String{
//        
//        switch self {
//        case .authentication:
//            return "Authorization"
//        case .contentType:
//            return "Content-Type"
//        case .acceptType:
//            return "Accept"
//        case .acceptEncoding:
//            return "Accept-Encoding"
//        case .acceptLangauge:
//            return "Accept-Language"
//        
//        }
//        
//    }
//    
//}
//
//enum ContentType: String {
//    case json            = "application/json"
//    case multipart       = "multipart/form-data"
//    case ENUS            = "en-us"
//}
//
//enum MultipartType: String {
//    case image = "Image"
//    case csv = "CSV"
//}
//
//enum MimeType: String {
//    case image = "image/png"
//    case csvText = "text/csv"
//}
//
//enum UploadType: String {
//    case avatar
//    case file
//}
