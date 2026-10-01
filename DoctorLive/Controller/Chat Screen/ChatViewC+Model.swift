//
//  ChatViewC+Model.swift
//  Dr.Live
//
//  Created by Kv on 24/12/24.
//

import Foundation
import SwiftyJSON

struct ChatData{
    
    var message: String?
    var time: String?
    var msgType: String?
    var recieverType: String?
    var date: String?
    var id: String?
    var isExpired:Int?
    var historyType: String?
    var bookingId: String?
    var statusId: String?
    var fees: String?
    var patientName: String?
    var patientId: String?
    var doctorId: String?
    var changedByType: String?
    var changedById: String?
    var createdOn: String?
    var rating: String?
    var prescription_url: String?
    var is_status:String?
    var booking_date: String?
    var booking_time: String?
    let is_follow_up:String?
    
    init(message: String = EMPTY, time: String = EMPTY, msgType: String = EMPTY, recieverType: String = EMPTY, date: String = EMPTY, id: String = EMPTY,isExpired:Int = 0, historyType: String? = nil, bookingId: String? = nil, statusId: String? = nil, fees: String? = nil, patientName: String? = nil, patientId: String? = nil, doctorId: String? = nil, changedByType: String? = nil, changedById: String? = nil, createdOn: String? = nil, rating: String? = nil,prescription_url:String? = nil,
         is_status:String? = "1", booking_date: String? = nil, booking_time: String? = nil, is_follow_up: String? = nil) {
        self.message = message
        self.time = time
        self.msgType = msgType
        self.recieverType = recieverType
        self.date = date
        self.id = id
        self.isExpired = isExpired
        self.historyType = historyType
        self.bookingId = bookingId
        self.statusId = statusId
        self.fees = fees
        self.patientName = patientName
        self.patientId = patientId
        self.doctorId = doctorId
        self.changedByType = changedByType
        self.changedById = changedById
        self.createdOn = createdOn
        self.rating = rating
        self.prescription_url = prescription_url
        self.is_status = is_status
        self.booking_date = booking_date
        self.booking_time = booking_time
        self.is_follow_up = is_follow_up
    }
}


//struct DoctorchathistoryModal {
//
//    let doctorchathistory: [DoctorchathistoryData]?
//    let other_details:other_detailssss
//    let status: String?
//
//    init(_ json: JSON) {
//        doctorchathistory = json["doctorchathistory"].arrayValue.map { DoctorchathistoryData($0) }
//        status = json["status"].stringValue
//        other_details = json["other_details"].object
//    }
//
//}
//
//struct other_detailssss{
//    let last_active : String?
//}



struct DoctorchathistoryModal {

    let doctorchathistory: [DoctorchathistoryData]?
    let other_details: other_detailssss?
    let status: String?

    init(_ json: JSON) {
        doctorchathistory = json["doctorchathistory"].arrayValue.map {
            DoctorchathistoryData($0)
        }

        status = json["status"].string

        if json["other_details"].exists() {
            other_details = other_detailssss(json["other_details"])
        } else {
            other_details = nil
        }
    }
}


struct other_detailssss {

    let last_active: String?

    init(_ json: JSON) {
        last_active = json["last_active"].string
    }
}


struct DoctorchathistoryData {

    let id: String?
    let senderId: String?
    let reciverId: String?
    let message: String?
    let type: String?
    let createdOn: String?
    let readStatus: String?
    let userName: String?
    let senderType: String?
    let roomId: String?
    let isExpired:Int?
    
    let time: String?
    let date: String?
    let historyType: String?
    let bookingId: String?
    let doctorId: String?
    let patientName: String?
    let patientId: String?
    let fees: String?
    let changedByType: String?
    let changedById: String?
    let statusId: String?
    let statusSince: String?
    let rating:String?
    let prescription_url:String?
    let is_status:String?
    let booking_date: String?
    let booking_time: String?
    let is_follow_up:String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        senderId = json["sender_id"].stringValue
        reciverId = json["reciver_id"].stringValue
        message = json["message"].stringValue
        type = json["type"].stringValue
        createdOn = json["created_on"].stringValue
        readStatus = json["read_status"].stringValue
        userName = json["userName"].stringValue
        senderType = json["senderType"].stringValue
        roomId = json["room_id"].stringValue
        isExpired = json["isExpired"].intValue
        
        time = json["time"].string
        date = json["date"].string
        historyType = json["history_type"].string
//        bookingId = json["booking_id"].string
        doctorId = json["doctor_id"].string
        patientName = json["patient_name"].string
        patientId = json["patient_id"].string
        fees = json["fees"].string
        changedByType = json["changed_by_type"].string
        changedById = json["changed_by_id"].string
        statusId = json["status_id"].string
        statusSince = json["statusSince"].string
        rating = json["rating"].string
        prescription_url = json["prescription_url"].string
        if let value = json["is_status"].string {
            is_status = value
        } else if let value = json["is_status"].int {
            is_status = String(value)
        } else {
            is_status = nil
        }
        if let value = json["booking_id"].string {
            bookingId = value
        } else if let value = json["booking_id"].int {
            bookingId = String(value)
        } else {
            bookingId = nil
        }
        booking_date = json["booking_date"].string
        booking_time = json["booking_time"].string
        is_follow_up = json["is_follow_up"].stringValue
         
    }

}
