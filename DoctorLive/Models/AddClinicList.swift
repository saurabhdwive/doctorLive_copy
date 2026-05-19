//
//  AddClinicList.swift
//  DoctorLive
//
//  Created by call soft on 13/09/21.
//

import Foundation
struct AddClinicList: Codable {

    let addclinic: String?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case addclinic = "addclinic"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addclinic = try? values.decode(String.self, forKey: .addclinic)
        status = try? values.decode(String.self, forKey: .status)
    }
}
