//
//  MyArticleViewC+Model.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import Foundation
import SwiftyJSON

struct MyArticlesRoot {

    let articles: [MyArticlesArticles]?
    let status: String?

    init(_ json: JSON) {
        articles = json["articles"].arrayValue.map { MyArticlesArticles($0) }
        status = json["status"].stringValue
    }

}

struct MyArticlesArticles {

    let id: String?
    let speciality: String?
    let drId: String?
    let title: String?
    let description: String?
    let statusCheck: String?
    let createdAt: String?
    let updatedAt: String?
    let doctorName: String?
    let doctorSpecialtyId: String?
    let doctorSpecialty: String?
    let doctorImage: String?
    let doctorYear: String?
    let articleImagePaths: [String]?

    init(_ json: JSON) {
        id = json["id"].stringValue
        speciality = json["speciality"].stringValue
        drId = json["dr_id"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        statusCheck = json["status_check"].stringValue
        createdAt = json["created_at"].stringValue
        updatedAt = json["updated_at"].stringValue
        doctorName = json["doctor_name"].stringValue
        doctorSpecialtyId = json["doctor_specialty_id"].stringValue
        doctorSpecialty = json["doctor_specialty"].stringValue
        doctorImage = json["doctor_image"].stringValue
        doctorYear = json["doctor_year"].stringValue
        articleImagePaths = json["article_image_paths"].arrayValue.map { $0.stringValue }
    }

}
