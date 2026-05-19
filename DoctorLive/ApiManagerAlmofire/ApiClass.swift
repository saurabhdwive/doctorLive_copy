//
//  ApiClass.swift
//  DemoApp
//
//  Created by mobulous on 26/03/21.
//

import Foundation
import UIKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class ApiManager:Requestable {
    
    static let instance: ApiManager = {
        let instance = ApiManager()
        return instance
    }()
    
    func getHeadeWithJwtToken() -> [String: String]{
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
    func alertWithHandler(message : String , block:  @escaping ()->Void ){
        
        let  alert = UIAlertController(title: CommonClass.sharedInstance.createString(Str: "YouPick!"), message: CommonClass.sharedInstance.createString(Str: message), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: CommonClass.sharedInstance.createString(Str: "OK"), style: .default, handler: {(action : UIAlertAction) in
            
            block()
            
        }))
        
        commonController.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Api Service Method Using Alamofire, Recommended to use this service
    func fetchApiService(method:Method,url:String,passDict:[String:Any]? = nil,header:[String:String]? = nil, callback: @escaping Handler = { _ in }){

        request(method: method, url: url, params: passDict, headers: header) {(result) in
            switch result {
            case .success(let data):
            break
             case .failure(let error):
                if error.localizedDescription.contains("URLSessionTask failed with error:") {
//                    self.fetchApiService(method: method, url: url, passDict: passDict, header: header) {
//                        stuff in
//                        print(stuff)
//                    }
                    return
                }

                print(error.localizedDescription)

            }
           
            callback(result)
        }

    }
//    func fetchApiService1(method:Method,url:String,passDict:[String:Any]? = nil,header:[String:String]? = nil, callback: @escaping Handler){
//
//        request(method: method, url: url, params: passDict, headers: header) {(result) in
//            callback(result)
//            //Indicator.shared.hideProgressView()
//            switch result {
//            case .success(let data):
//
//                let message = data["message"].string ?? ""
//                if message == "Invalid Token"{
//                    self.alertWithHandler(message: "This credential is logged in through other device") {
//                        let realm = try! Realm()
//                        try! realm.write({
//                            let deletedNotifications = realm.objects(DataUser.self)
//                            realm.delete(deletedNotifications)
//                        })
//
//                    }
//
//                }
//                break
//
//            case .failure(let error):
//
//                print(error.localizedDescription)
//
//            }
//
//        }
//
//    }
//    func fetchMultipartedApiService(imageData : [NSData]? = nil ,fileName:[String]? = nil , imageparams:[String]? = nil,url:String,params:[String:Any]? = nil , headers:[String:String]? = nil , callback:@escaping Handler){
//
//        multipartingRequest(imageData: imageData, fileName: fileName, imageParam: imageparams, url: url, params: params, headers: headers) { (result) in
//            callback(result)
//            Indicator.shared.hideLoaderPresent()
//            switch result {
//            case .success(let data):
//
//                let message = data["message"].string ?? ""
//                if message == "Invalid Token"{
//                    self.alertWithHandler(message: "This credential is logged in through other device") {
//                        let realm = try! Realm()
//                        try! realm.write({
//                            let deletedNotifications = realm.objects(DataUser.self)
//                            realm.delete(deletedNotifications)
//                        })
//                        kAppDelegate.appNavigator = ApplicationNavigator(window: kAppDelegate.window, sendViewController: "LoginVC")
//
//                    }
//
//                }
//                break
//
//            case .failure(let error):
//
//                print(error.localizedDescription)
//
//            }
//        }
//
//    }
}

//MARK:- Api Service Method Using URL Session
extension ApiManager{
    
    //MARK:- Multiparting
    
    public func MultipartSessionService(EndUrl url: String,Method method:Method,Parameters param:[String:Any]? = nil,Header header: [String:String]? = nil,ImageData imageData:[NSData]? = nil,fileName:[String]? = nil,_ completion: @escaping Handler1){
        
        let mainURL = Domain.baseUrl().appending(url)
        var request = URLRequest(url: URL(string: mainURL)!,timeoutInterval: Double.infinity)
        let boundary = "Boundary-\(UUID().uuidString)"
        let httpBody = NSMutableData()
        if let param = param{
            for (key, value) in param {
                httpBody.appendString(convertFormField(named: key, value: value as! String, using: boundary))
            }
        }
        // DispatchQueue.main.async {
        for i in 0..<(imageData?.count ?? 0){
            httpBody.append(self.convertFileData(fieldName: "image_field+\(i)",
                                                 fileName: fileName?[i] ?? "",
                                                 mimeType: "image/png",
                                                 fileData: (imageData?[i])!,
                                                 using: boundary))
        }
        // }
        
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        request.addValue(header?.values.first ?? "", forHTTPHeaderField: header?.keys.first ?? "")
        //request.addValue(getSavedToken() ?? "", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.method.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print(error!);
                let error : Error = error!
                completion(.failure(error))
                // semaphore.signal()
                return
            }
            //DispatchQueue.main.async {
            completion(.success(data!)) // Do Catch
            //}
            
        }
        
        task.resume()
        // semaphore.wait()
    }
    
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: NSData, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData as Data)
        data.appendString("\r\n")
        
        return data as Data
    }
    
    
    //MARK:- Post And Get Type
    
    public func GetPostSessionService(_ param : [String : Any]? = nil, _ url : String,_ method:Method,_ header: [String:String]? = nil, completionHandler: @escaping Handler1) {
        
        let mainURL = Domain.development.appending(url)
        var request = URLRequest(url: URL(string: mainURL)!,timeoutInterval: Double.infinity)
        let session = URLSession.shared
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.method.rawValue
        if let param = param{
            request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        }
        
        let task = session.dataTask(with: request as URLRequest) {
            (data,response,error) in
            print("response.........\(response)")
            print("data.........\(data)")
            print("error.........\(error)")
            //Indicator.shared.hideProgressView()
            guard error == nil else {
                let error : Error = error!
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(data!)) // Do Catch
        };
        task.resume()
    }
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
var semaphore = DispatchSemaphore (value: 0)

var commonController = UIViewController()
