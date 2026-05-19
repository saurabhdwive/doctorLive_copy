//
//  BookingStatusModel.swift
//  DoctorLive
//
//  Created by call soft on 16/09/21.
//

import Foundation
struct BookingStatusModel: Codable {
    let bookingstatuschange: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case bookingstatuschange = "bookingstatuschange"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bookingstatuschange = try? values.decode(String.self, forKey: .bookingstatuschange)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
 }

struct PushNotificationRoot: Codable {

    let status: String?
    let message: String?
    let pushNotificationStatus: PushNotificationStatus?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case pushNotificationStatus = "push_notification_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        pushNotificationStatus = try values.decodeIfPresent(PushNotificationStatus.self, forKey: .pushNotificationStatus)
    }

}

struct PushNotificationStatus: Codable {

    let name: String?

    private enum CodingKeys: String, CodingKey {
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct TokenRoot: Codable {

    let message: String?
    let uid: String?
    let token: String?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case uid = "uid"
        case token = "token"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        uid = try values.decodeIfPresent(String.self, forKey: .uid)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}
