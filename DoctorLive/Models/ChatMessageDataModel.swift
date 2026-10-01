//
//  Data.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 09, 2021
//
import Foundation
import SwiftyJSON

//struct ChatDataModel: Codable {
//    let doctorchathistory: [Doctorchathistory]?
//    let status: String?
//    let message: String?
//
//    init(_ json: JSON) {
//        doctorchathistory = json["doctorchathistory"].arrayValue.map { Doctorchathistory($0) }
//        status = json["status"].stringValue
//        message = json["message"].stringValue
//    }
// }
//
//struct Doctorchathistory: Codable {
//    let id: String?
//    let senderId: String?
//    let reciverId: String?
//    let message: String?
//    let type: String?
//    let createdAt: String?
//
//    init(_ json: JSON) {
//        id = json["id"].stringValue
//        senderId = json["sender_id"].stringValue
//        reciverId = json["reciver_id"].stringValue
//        message = json["message"].stringValue
//        type = json["type"].stringValue
//        createdAt = json["created_at"].stringValue
//    }
//  }

struct ChatDataModel: Codable {
    let doctorchathistory: [Doctorchathistory]?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case doctorchathistory = "doctorchathistory"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        doctorchathistory = try? values.decode([Doctorchathistory].self, forKey: .doctorchathistory)
        status = try? values.decode(String.self, forKey: .status)
    }
}

struct Doctorchathistory: Codable {
    
    let id: String?
    let senderId: String?
    let reciverId: String?
    let message: String?
    let type: String?
    let createdAt: String?
    let read_status: String?
    let userName: String?
    let senderType: String?
    let room_id: String?
    let booking_date: String?
    let booking_time: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case senderId = "sender_id"
        case reciverId = "reciver_id"
        case message = "message"
        case type = "type"
        case createdAt = "created_on"
        case read_status = "read_status"
        case userName = "userName"
        case senderType = "senderType"
        case room_id = "room_id"
        case booking_date = "booking_date"
        case booking_time = "booking_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        senderId = try? values.decode(String.self, forKey: .senderId)
        reciverId = try? values.decode(String.self, forKey: .reciverId)
        message = try? values.decode(String.self, forKey: .message)
        type = try? values.decode(String.self, forKey: .type)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        read_status = try? values.decode(String.self, forKey: .read_status)
        userName = try? values.decode(String.self, forKey: .userName)
        senderType = try? values.decode(String.self, forKey: .senderType)
        room_id = try? values.decode(String.self, forKey: .room_id)
        booking_date = try? values.decode(String.self, forKey: .booking_date)
        booking_time = try? values.decode(String.self, forKey: .booking_time)
    }

}
