//
//  QuestionDetailViewC+Model.swift
//  DoctorLive
//
//  Created by Kv on 07/11/24.
//

import Foundation
import SwiftyJSON

struct QuestionDetailRoot {

    let question: QuestionDetailQuestion?
    let answers: [QuestionDetailAnswers]?
    let status: String?

    init(_ json: JSON) {
        question = QuestionDetailQuestion(json["question"])
        answers = json["answers"].arrayValue.map { QuestionDetailAnswers($0) }
        status = json["status"].stringValue
    }

}

struct QuestionDetailQuestion {

    let id: String?
    let title: String?
    let description: String?
    let memberId: String?
    let statusCheck: String?
    let memberDetails: QuestionDetailMemberDetails?
    let hoursAgo: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        memberId = json["member_id"].stringValue
        statusCheck = json["status_check"].stringValue
        memberDetails = QuestionDetailMemberDetails(json["member_details"])
        hoursAgo = json["hours_ago"].stringValue
    }

}

struct QuestionDetailMemberDetails {

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

struct QuestionDetailAnswers {

    let id: String?
    let drId: String?
    let questionId: String?
    let answer: String?
    let statusCheck: String?
    let doctorName: String?
    let doctorExp: String?
    let specialtyId: String?
    let specialtyName: String?
    let doctorImage: String?
    let minutesAgo: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        drId = json["dr_id"].stringValue
        questionId = json["question_id"].stringValue
        answer = json["answer"].stringValue
        statusCheck = json["status_check"].stringValue
        doctorName = json["doctor_name"].stringValue
        doctorExp = json["doctor_exp"].stringValue
        specialtyId = json["specialty_id"].stringValue
        specialtyName = json["specialty_name"].stringValue
        doctorImage = json["doctor_image"].stringValue
        minutesAgo = json["minutes_ago"].stringValue
    }

}
