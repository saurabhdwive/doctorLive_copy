//
//  AppUrl.swift
//  E-RX
//
//  Created by SinhaAirBook on 29/06/20.
//  Copyright © 2020 macbook. All rights reserved.
//,

import UIKit

struct Domain {
    
    static let development = "https://doctorlivebd.com/api/"
    static let appVersion = "https://doctorlivebd.com/api/"
    //static let development = "http://3.129.241.38/api/doctors/"
    static let socketUrl = "http://3.22.227.41:2020"
    static let chatHistory = "http://3.22.227.41:2020/api/v1/user/"
    static let production = "https://doctorlivebd.com/api/doctor/"
    static let productions = "https://doctorlivebd.com/api/doctors/"
    static let socketUrlProduction = "https://e-rx.cc:2021"
}

extension Domain {
    static func baseUrl() -> String {
        return Domain.development
    }
    static func socketURL() -> String {
        return Domain.socketUrlProduction
    }
    
    static func baseDoctorUrl() -> String{
        return Domain.productions
    }
    
    static func chatHistoryUrl() ->String{
        return Domain.production
    }
}

struct APIEndpoint {
    //static let createBooking = "addavailability"
    static let createBooking = "doctors/slots/add"
    static let updateBooking = "doctors/slots/update" //made by kv .... this is for updating slots
    static let deleteBooking = "doctors/slots/delete"
    static let updateAvilability = "doctors/updateavailability"
    static let deleteAvilability = "doctors/deleteavailability"
    static let savePrescription = "doctor/addprescription"
    static let appVersion = "common/version"
    
    
    //ARTICLE
    static let myArticles               =       "articles/get_all_articles"
    static let deleteArticle            =       "articles/deletearticle/"
    static let cutDoctorCall            =       "user/doctor_call"
    static let postArticle              =       "articles/article"
    static let updateArticle            =       "articles/update_article/"
    static let questionList             =       "question/questionslist_all"
    static let myAnswerList             =       "question/myanswers_list"
    static let questionWithAnswer       =       "question/question_with_answers"
    static let postAnswer               =       "answer/add_answer"
    static let updateAnswer             =       "answer/update_answer/"
    
    //OTHERS
    static let myRating                 =       "patient/doctor/doctorRatings"
    
    
    //CHAT
    static let doctorchathistory        =       "doctor/doctorchathistory"

    // Presigned URL
    static let signedUrl                =       "Aws_s3/get_signed_url"
}

//enum HTTPHeaderField: String {
//    case authentication  = "Authorization"
//    case contentType     = "Content-Type"
//    case acceptType      = "Accept"
//    case acceptEncoding  = "Accept-Encoding"
//    case acceptLangauge  = "Accept-Language"
//    
//    var header:String{
//        
//        switch self {
//        case .authentication:
//            return "Authorization"
//        case .contentType:
//            return "Content-Type"
//        case .acceptType:
//            return "Accept"
//        case .acceptEncoding:
//            return "Accept-Encoding"
//        case .acceptLangauge:
//            return "Accept-Language"
//        
//        }
//    }
//}

//enum ContentType: String {
//    case json            = "application/json"
//    case multipart       = "multipart/form-data"
//    case ENUS            = "en-us"
//}

//enum MultipartType: String {
//    case image = "Image"
//    case csv = "CSV"
//}
//
//enum MimeType: String {
//    case image = "image/png"
//    case csvText = "text/csv"
//}

//enum UploadType: String {
//    case avatar
//    case file
//}
