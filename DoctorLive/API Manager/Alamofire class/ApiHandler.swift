//
//  ApiHandler.swift
//  Helper Class
//
//  Created by Krishanvir on 29/03/22.
//

import Foundation
import SwiftyJSON

class ApiHandler: Requestable1 {
    //URLEncoding.httpBody
    func fetchApiHeaderService(method: ApiMethod, url: String, passDict: [String:Any]? = nil , header: [String:String]? = nil, callback: @escaping HandlerNew){
        request(method: method, url: url, params: passDict, headers: header) { (result) in
            callback(result)
        }
    }
    
    func fetchApiService(method:ApiMethod,url:String,passDict:[String:Any]? = nil,header:[String:String]? = nil, callback: @escaping HandlerNew){
                 let header = ["Content-Type":"application/json",
                               "Accept": "application/json"]
        request(method: method, url: url, params: passDict, headers: header) {(result) in
            callback(result)
        }
    }
    
    func fetchApiHeaderServiceRaw(method: ApiMethod, url: String, passDict: [String:Any]? = nil , header: [String:String]? = nil, callback: @escaping HandlerNew){
        requestRaw(method: method, url: url, params: passDict, headers: header) { (result) in
            callback(result)
        }
    }
}
