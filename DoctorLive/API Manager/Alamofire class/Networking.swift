//
//  Networking.swift
//  Helper Class
//
//  Created by Krishanvir on 29/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON
 /*
 Enum uses in API

 */
enum Result<Value: Decodable> {
    case success(Value)
    case failure(Error)
}

typealias HandlerNew = (Result<JSON>) -> Void



//enum NetworkError: Error {
//    case nullData
//}


public enum ApiMethod {
   
    case delete
    case get
    case head
    case post
    case put
    case connect
    case options
    case trace
    case patch
    case other(method: String)
}

enum NetworkingError: String, LocalizedError {
    case jsonError = "JSON error"
    case other
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}

extension ApiMethod {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
        case "DELETE":
            self = .delete
        case "GET":
            self = .get
        case "HEAD":
            self = .head
        case "POST":
            self = .post
        case "PUT":
            self = .put
        case "CONNECT":
            self = .connect
        case "OPTIONS":
            self = .options
        case "TRACE":
            self = .trace
        case "PATCH":
            self = .patch
        default:
            self = .other(method: method)
        }
    }
}

extension ApiMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .delete:            return "DELETE"
        case .get:               return "GET"
        case .head:              return "HEAD"
        case .post:              return "POST"
        case .put:               return "PUT"
        case .connect:           return "CONNECT"
        case .options:           return "OPTIONS"
        case .trace:             return "TRACE"
        case .patch:             return "PATCH"
        case .other(let method): return method.uppercased()
        }
    }
}

extension ApiMethod{
    
    var method:HTTPMethod{
        
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .connect:
            return .connect
        case .delete:
            return .delete
        case .head:
            return .head
        case .options:
            return .options
        case .patch:
            return .patch
        case .put:
            return .put
        case .trace:
            return .trace
        
        case .other( _):
            return .head
        }
    }
    
}

protocol Requestable1 {}

extension Requestable1{
    
    // For Post and Get Method
    internal func request(method: ApiMethod, url: String, params: [String: Any]? = nil,headers:[String:String]? = nil, callback: @escaping HandlerNew){
        
        guard let url = URL(string:url) else {
            return
        }
        var Headers = [String:String]()
        Headers = headers?.compactMapValues({ value in
            return value
        }) ?? [:]
        
        var request = URLRequest(url: url)
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        var header : HTTPHeaders = HTTPHeaders()
        for (k,v) in Headers {
            header.add(name: k, value: v)
        }
        
        print("================= API REQUEST ======================")
        print("🚀 URL: \(url)")
        print("🚀 Method: \(method.method.rawValue)")
        print("🚀 Headers: \(header.dictionary)")
        if let p = params {
            print("🚀 Params: \(p)")
        }
        print("====================================================")
        
//        URLEncoding.default =====   for form data
//        JSONEncoding.default =====  for raw data 
        AF.request(url, method: method.method, parameters: params, encoding: URLEncoding.default, headers: header).response { responseObject in
            switch responseObject.result{
                
            case .success(_):
                let resJson = JSON(responseObject.value!)
                callback(.success(resJson))
                
            case .failure(_):
                
                let error : Error = responseObject.error!
//                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost."{
//                    callback(.failure("Please check your Internet connectivity!"))
//                }else{
                    callback(.failure(error))
//                }
            }
        }
        
//        AF.request(url, method: method.method, parameters: params, encoding: JSONEncoding.default, headers:header).responseJSON { (responseObject) -> Void in
////                .validate(statusCode: 200..<300)
////            responseObject.response?.statusCode == 200
//            
//            switch responseObject.result{
//                
//            case .success(_):
//                let resJson = JSON(responseObject.value!)
//                callback(.success(resJson))
//                
//            case .failure(_):
//                
//                let error : Error = responseObject.error!
//                callback(.failure(error))
//                
//            }
//            
//        }

        
    }
    
    internal func requestRaw(method: ApiMethod, url: String, params: [String: Any]? = nil,headers:[String:String]? = nil, callback: @escaping HandlerNew){
        
        guard let url = URL(string:url) else {
            return
        }
        var Headers = [String:String]()
        Headers = headers?.compactMapValues({ value in
            return value
        }) ?? [:]
        
        var request = URLRequest(url: url)
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        var header : HTTPHeaders = HTTPHeaders()
        for (k,v) in Headers {
            header.add(name: k, value: v)
        }
        
        print("================= API REQUEST ======================")
        print("🚀 URL: \(url)")
        print("🚀 Method: \(method.method.rawValue)")
        print("🚀 Headers: \(header.dictionary)")
        if let p = params {
            print("🚀 Params: \(p)")
        }
        print("====================================================")
        
//        URLEncoding.default =====   for form data
//        JSONEncoding.default =====  for raw data
        AF.request(url, method: method.method, parameters: params, encoding: JSONEncoding.default, headers: header).response { responseObject in
            switch responseObject.result{
                
            case .success(_):
                let resJson = JSON(responseObject.value!)
                callback(.success(resJson))
                
            case .failure(_):
                
                let error : Error = responseObject.error!
//                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost."{
//                    callback(.failure("Please check your Internet connectivity!"))
//                }else{
                    callback(.failure(error))
//                }
            }
        }
        
//        AF.request(url, method: method.method, parameters: params, encoding: JSONEncoding.default, headers:header).responseJSON { (responseObject) -> Void in
////                .validate(statusCode: 200..<300)
////            responseObject.response?.statusCode == 200
//
//            switch responseObject.result{
//
//            case .success(_):
//                let resJson = JSON(responseObject.value!)
//                callback(.success(resJson))
//
//            case .failure(_):
//
//                let error : Error = responseObject.error!
//                callback(.failure(error))
//
//            }
//
//        }

        
    }
    
   // For Multiparting
//
//    internal func multipartingRequest(imageData:[NSData]? = nil,fileName:[String]? = nil , imageParam:[String]? = nil,url: String, params: [String: Any]? = nil,headers:[String:String]? = nil, callback: @escaping Handler){
//
//        guard let url = URL(string: url) else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue(ContentType.multipart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
//        var Headers = [String:String]()
//               Headers = headers?.compactMapValues({ value in
//                   return value
//               }) ?? [:]
//        var header : HTTPHeaders = HTTPHeaders()
//
//        for (k,v) in Headers{
//
//            header.add(name: k, value: v)
//
//        }
//
//        AF.upload(multipartFormData: { (multipartFormData) in
//
//            if imageData?.count ?? 0 > 0{
//                for i in 0..<imageData!.count{
//                    let imagedata = imageData![i] as Data
//                    multipartFormData.append(imagedata as Data, withName: imageParam?[i] ?? "", fileName: fileName?[i], mimeType:"image/png")
//                }
//            }
//
//            for (key, value) in params ?? ["":""] {
//
//                if let tagsArray = value as? NSMutableArray{
//
//                    let stringsData = NSMutableData()
//                    for tag in tagsArray{
//                        if let stringData = "\(tag)".data(using: .utf8) {
//                            stringsData.append(stringData)
//                            multipartFormData.append("\(tag)".data(using: .utf8)!, withName: key)
//
//                        }
//                    }
//                }
//                else if value is String || value is Int {
//
//
//                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//                }
//
//
//            }
//
//        },to: url, usingThreshold:UInt64.init(), method: .post, headers: header).responseJSON { (response) in
//
//            switch response.result{
//
//            case .success(_):
//
//                let resJson = JSON(response.value!)
//                callback(.success(resJson))
//
//            case .failure(_):
//
//                let error : Error = response.error!
//
//                callback(.failure(error))
//
//            }
//        }
//    }
    
    
    
//    internal func multipartingRequestData(method: ApiMethod,imageData:[NSData]? = nil,fileName:[String]? = nil , imageParam:[String]? = nil,url: String, params: [String: Any]? = nil,headers:[String:String]? = nil, dataType:String?, callback: @escaping Handler){
//
//        guard let url = URL(string: url) else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue(ContentType.multipart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
//        var Headers = [String:String]()
//        Headers = headers?.compactMapValues({ value in
//            return value
//        }) ?? [:]
//        var header : HTTPHeaders = HTTPHeaders()
//
//        for (k,v) in Headers{
//
//            header.add(name: k, value: v)
//
//        }
//
//        AF.upload(multipartFormData: { (multipartFormData) in
//
//            if imageData?.count ?? 0 > 0{
//                for i in 0..<imageData!.count{
//
//                    var mimeTy = String()
//
//                    if fileName?[i] == "video.mp4"{
//                        mimeTy = "video/mp4"
//                    }else if fileName?[i] == "audio.mp3"{
//                        mimeTy = "audio/mp3"
//                    }else{
//                        mimeTy = "image/png"
//                    }
//
//                    let imagedata = imageData![i] as Data
//                    multipartFormData.append(imagedata as Data, withName: imageParam?[i] ?? "", fileName: fileName?[i], mimeType:mimeTy)
//                }
//            }
//
//            if params?.count ?? 0 > 0 {
//                for (key, value) in params! {
//
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
//                }
//            }
//
//
//        },to: url, usingThreshold:UInt64.init(), method: method.method, headers: header).responseJSON { (response) in
//
//            switch response.result{
//
//            case .success(_):
//
//                let resJson = JSON(response.value!)
//                callback(.success(resJson))
//
//            case .failure(_):
//
//                let error : Error = response.error!
//
//                callback(.failure(error))
//
//            }
//        }
//    }
    
}

// SINGLTON CLASS FOR SCREEN NAME  that on That screen notification popup will not come
class ScreeNNameClass {
    static let shareScreenInstance = ScreeNNameClass()
    var  screenName = ""
    private init() {}
}
enum ContentType: String {
    case json            = "application/json"
    case multipart       = "multipart/form-data"
    case ENUS            = "en-us"
}
enum HTTPHeaderField: String {
    
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case acceptLangauge  = "Accept-Language"
    case localization    =  "X-localization"
    
    var header:String{
        
        switch self {
        case .authentication:
            return "Authorization"
        case .contentType:
            return "Content-Type"
        case .acceptType:
            return "Accept"
        case .acceptEncoding:
            return "Accept-Encoding"
        case .acceptLangauge:
            return "Accept-Language"
        case .localization:
            return "X-localization"
        }
        
    }
    
}
enum MultipartType: String {
    case image = "Image"
    case csv = "CSV"
}

enum MimeType: String {
    case image = "image/png"
    case csvText = "text/csv"
}

enum UploadType: String {
    case avatar
    case file
}
