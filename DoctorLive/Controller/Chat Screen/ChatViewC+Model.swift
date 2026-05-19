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
    
    init(message: String = EMPTY, time: String = EMPTY, msgType: String = EMPTY, recieverType: String = EMPTY, date: String = EMPTY, id: String = EMPTY) {
        self.message = message
        self.time = time
        self.msgType = msgType
        self.recieverType = recieverType
        self.date = date
        self.id = id
    }
}


struct DoctorchathistoryModal {

    let doctorchathistory: [DoctorchathistoryData]?
    let status: String?

    init(_ json: JSON) {
        doctorchathistory = json["doctorchathistory"].arrayValue.map { DoctorchathistoryData($0) }
        status = json["status"].stringValue
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
    }

}
