//
//  BankListModel.swift
//  DoctorLive
//
//  Created by call soft on 08/09/21.
//

import Foundation

struct BankListModel: Codable {
    let banklist: [Banklist]?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case banklist = "banklist"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        banklist = try? values.decode([Banklist].self, forKey: .banklist)
        status = try? values.decode(String.self, forKey: .status)
    }
}
struct Banklist: Codable {

    let id: String?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
    }
}
