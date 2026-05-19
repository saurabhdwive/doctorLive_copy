//
//  TestListModel.swift
//  DoctorLive
//
//  Created by cst on 26/11/21.
//

import Foundation
struct TestListModel: Codable {

    let gettestinglist: [Gettestinglist]?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case gettestinglist = "gettestinglist"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gettestinglist = try? values.decode([Gettestinglist].self, forKey: .gettestinglist)
        status = try? values.decode(String.self, forKey: .status)
    }
}
struct Gettestinglist: Codable {
    let id: String?
    let name: String?
    let createdAt: String?
    let updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        updatedAt = try? values.decode(String.self, forKey: .updatedAt)
    }
}
