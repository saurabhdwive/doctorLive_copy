//
//  RootClass.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 07, 2021
//

import Foundation

struct DoctorSpeciality: Codable {
    let specialtyList: [SpecialtyList]?
	let status: String?
    let message: String?

	private enum CodingKeys: String, CodingKey {
		case specialtyList = "specialtyList"
		case status = "status"
        case message = "message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		specialtyList = try? values.decode([SpecialtyList].self, forKey: .specialtyList)
		status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
	}
}

struct SpecialtyList: Codable {
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
