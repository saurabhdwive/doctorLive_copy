//
//  EditClinicModel.swift
//  DoctorLive
//
//  Created by cst on 24/10/21.
//

import Foundation
struct EditClinicModel: Codable {
    let editclinic: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case editclinic = "editclinic"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        editclinic = try values.decode(String.self, forKey: .editclinic)
        status = try values.decode(String.self, forKey: .status)
        message = try values.decode(String.self, forKey: .message)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(editclinic, forKey: .editclinic)
        try container.encode(status, forKey: .status)
        try container.encode(status, forKey: .message)
    }

}
