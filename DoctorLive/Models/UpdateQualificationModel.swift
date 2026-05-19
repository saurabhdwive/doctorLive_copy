//
//  UpdateQualificationModel.swift
//  DoctorLive
//
//  Created by call soft on 09/09/21.
//

import Foundation

struct UpdateQualificationModel: Codable {
    let updatequalification: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case updatequalification = "updatequalification"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        updatequalification = try? values.decode(String.self, forKey: .updatequalification)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}
