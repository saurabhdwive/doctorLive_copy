//
//  LanguageChangeModel.swift
//  DoctorLive
//
//  Created by cst on 14/10/21.
//

import Foundation
struct LanguageChangeModel: Codable {

    let savelanguage: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case savelanguage = "savelanguage"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        savelanguage = try? values.decode(String.self, forKey: .savelanguage)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }

    

}
