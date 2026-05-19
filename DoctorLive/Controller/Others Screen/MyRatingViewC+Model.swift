//
//  MyRatingViewC+Model.swift
//  DoctorLive
//
//  Created by Kv on 14/11/24.
//

import Foundation
import SwiftyJSON

struct MyRatingRoot {

    let message: String?
    let avgrating: String?
    let rating: [Rating]?
    let status: String?

    init(_ json: JSON) {
        message = json["message"].stringValue
        avgrating = json["avgrating"].stringValue
        rating = json["rating"].arrayValue.map { Rating($0) }
        status = json["status"].stringValue
    }

}

struct Rating {

    let id: String?
    let userId: String?
    let doctorId: String?
    let bookingId: String?
    let rating: String?
    let comment: String?
    let createdDate: String?
    let userName: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        userId = json["user_id"].stringValue
        doctorId = json["doctor_id"].stringValue
        bookingId = json["booking_id"].stringValue
        rating = json["rating"].stringValue
        comment = json["comment"].stringValue
        createdDate = json["created_date"].stringValue
        userName = json["user_name"].stringValue
    }

}
