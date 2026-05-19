//
//  NotificationListModel.swift
//  DoctorLive
//
//  Created by cst on 29/10/21.
//

import Foundation
struct NotificationListModel: Codable {
    let mynotification: [Mynotification]?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case mynotification = "mynotification"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mynotification = try? values.decode([Mynotification].self, forKey: .mynotification)
        status = try? values.decode(String.self, forKey: .status)
    }
}
struct Mynotification: Codable {
    let id: String?
    let title: String?
    let message: String?
    let type: String?
    let notificationStatus: String?
    let date: String?
    let time: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case message = "message"
        case type = "type"
        case notificationStatus = "notification_status"
        case date = "date"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        title = try? values.decode(String.self, forKey: .title)
        message = try? values.decode(String.self, forKey: .message)
        type = try? values.decode(String.self, forKey: .type)
        notificationStatus = try? values.decode(String.self, forKey: .notificationStatus)
        date = try? values.decode(String.self, forKey: .date)
        time = try? values.decode(String.self, forKey: .time)
    }
  }
