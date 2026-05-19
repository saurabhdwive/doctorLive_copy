//
//  VerificationModel.swift
//  DoctorLive
//
//  Created by call soft on 03/09/21.
//

import Foundation

struct CheckMailModel: Codable {
    let checkemail: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case checkemail = "checkemail"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkemail = try? values.decode(String.self, forKey: .checkemail)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}
