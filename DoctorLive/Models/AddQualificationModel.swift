//
//  AddQualificationModel.swift
//  DoctorLive
//
//  Created by call soft on 07/09/21.
//

import Foundation
struct AddQualificationModel: Codable {
    let addqualificationdetail: Int?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case addqualificationdetail = "addqualificationdetail"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addqualificationdetail = try? values.decode(Int.self, forKey: .addqualificationdetail)
        status = try? values.decode(String.self, forKey: .status)
    }

}
