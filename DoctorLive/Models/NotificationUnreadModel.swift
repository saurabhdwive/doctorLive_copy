//
//  NotificationUnreadModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on November 24, 2021
//
import Foundation

struct NotificationUnreadModel: Codable {

	let notificationunread: Int?
	let status: String?

	private enum CodingKeys: String, CodingKey {
		case notificationunread = "notificationunread"
		case status = "status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		notificationunread = try? values.decode(Int.self, forKey: .notificationunread)
		status = try? values.decode(String.self, forKey: .status)
	}

}
