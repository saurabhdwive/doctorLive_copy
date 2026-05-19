//
//  DeleteAvilability.swift
//  DoctorLive
//
//  Created by cst on 07/10/21.
//

import Foundation
struct DeleteAvilability: Codable {

    let addavailability: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case addavailability = "addavailability"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addavailability = try values.decode(String.self, forKey: .addavailability)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }

    
}
