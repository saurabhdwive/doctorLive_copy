//
//  DeleteExpiernce.swift
//  DoctorLive
//
//  Created by call soft on 12/09/21.
//

import Foundation
struct DeleteExperience: Codable {
    let deleteexperience: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case deleteexperience = "deleteexperience"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deleteexperience = try? values.decode(String.self, forKey: .deleteexperience)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}
