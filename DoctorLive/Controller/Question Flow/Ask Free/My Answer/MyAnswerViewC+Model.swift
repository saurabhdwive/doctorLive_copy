//
//  MyAnswerViewC+Model.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import SwiftyJSON


struct MyAnswerRoot {

    let data: [MyAnswerData]?
    let status: String?

    init(_ json: JSON) {
        data = json["data"].arrayValue.map { MyAnswerData($0) }
        status = json["status"].stringValue
    }

}

struct MyAnswerData {

    let questionId: String?
    let title: String?
    let description: String?
    let memberDetails: MyAnswerMemberDetails?
    let hoursAgo: String?
    let answers: [MyAnswerAnswers]?
    let totalAnswerCount: Int?
    let doctorImages: [String]?

    init(_ json: JSON) {
        questionId = json["question_id"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        memberDetails = MyAnswerMemberDetails(json["member_details"])
        hoursAgo = json["hours_ago"].stringValue
        answers = json["answers"].arrayValue.map { MyAnswerAnswers($0) }
        totalAnswerCount = json["total_answer_count"].intValue
        doctorImages = json["doctor_images"].arrayValue.map { $0.stringValue }
    }

}

struct MyAnswerMemberDetails {

    let id: String?
    let name: String?
    let userId: String?
    let gender: String?
    let dob: String?
    let relationship: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        userId = json["user_id"].stringValue
        gender = json["gender"].stringValue
        dob = json["dob"].stringValue
        relationship = json["relationship"].stringValue
    }

}

struct MyAnswerAnswers {

    let id: String?
    let typeId: String?
    let drId: String?
    let patientId: Any?
    let questionId: String?
    let answer: String?
    let statusCheck: String?
    let createdAt: String?
    let updatedAt: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        typeId = json["type_id"].stringValue
        drId = json["dr_id"].stringValue
        patientId = json["patient_id"]
        questionId = json["question_id"].stringValue
        answer = json["answer"].stringValue
        statusCheck = json["status_check"].stringValue
        createdAt = json["created_at"].stringValue
        updatedAt = json["updated_at"].stringValue
    }

}
