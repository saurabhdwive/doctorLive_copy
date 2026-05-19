//
//  QuestionListViewC+Model.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import SwiftyJSON

struct QuestionListRoot {

    let data: [QuestionListData]?
    let status: String?

    init(_ json: JSON) {
        data = json["data"].arrayValue.map { QuestionListData($0) }
        status = json["status"].stringValue
    }

}

struct QuestionListData {

    let questionId: String?
    let title: String?
    let description: String?
    let memberDetails: QuestionListMemberDetails?
    let answer: [QuestionListAnswer]?
    let totalAnswerCount: Int?
    let doctorImages: [String]?

    init(_ json: JSON) {
        questionId = json["question_id"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        memberDetails = QuestionListMemberDetails(json["member_details"])
        answer = json["answer"].arrayValue.map { QuestionListAnswer($0) }
        totalAnswerCount = json["total_answer_count"].intValue
        doctorImages = json["doctor_images"].arrayValue.map { $0.stringValue }
    }

}

struct QuestionListMemberDetails {

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

struct QuestionListAnswer {

    let id: String?
    let drId: String?
    let questionId: String?
    let answer: String?
    let statusCheck: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        drId = json["dr_id"].stringValue
        questionId = json["question_id"].stringValue
        answer = json["answer"].stringValue
        statusCheck = json["status_check"].stringValue
    }

}
