//
//  ApiCallerDropDown.swift
//  Croma
//
//  Created by Mphrx on 16/05/22.
//

import Foundation

extension APICaller : Requestable{
    func updateProfileService(method: Method, imageData : [NSData]? = nil ,fileName:[String]? = nil , imageparams:[String]? = nil,url:String,params:[String:Any]? = nil,dataType:String? , headers: [String:String]? = nil , callback:@escaping Handler){
        
            multipartingRequestData(method: method, imageData: imageData, fileName: fileName, imageParam: imageparams, url: url, params: params,headers: headers, dataType: dataType) {(result) in
                
                Indicator.shared.hideProgressView()
                
                switch result{
                case .success( _):
                    callback(result)
                    break
                case .failure(let error):
                    print(error)
                    callback(result)
                    break
                }
                
            }
            
        }
    
}
