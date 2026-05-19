//
//  WidhrawRequest.swift
//  DoctorLive
//
//  Created by cst on 10/10/21.
//

import Foundation
struct WidhrawRequestModel: Codable {
    let withdrawrequest: String?
    let status: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case withdrawrequest = "withdrawrequest"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        withdrawrequest = try values.decode(String.self, forKey: .withdrawrequest)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
 }
