//
//  ForgetPassword.swift
//  DoctorLive
//
//  Created by call soft on 07/09/21.
//

import Foundation
struct ForgetPassword: Codable {

    let message: String?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        status = try? values.decode(String.self, forKey: .status)
    }

}
