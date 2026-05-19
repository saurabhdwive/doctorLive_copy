//
//  DeleteQualification.swift
//  DoctorLive
//
//  Created by call soft on 12/09/21.
//

import Foundation
struct DeleteQualification: Codable {
    let deletequalification: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case deletequalification = "deletequalification"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deletequalification = try? values.decode(String.self, forKey: .deletequalification)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
 }
