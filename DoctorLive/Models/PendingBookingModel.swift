//
//  PendingBookingModel.swift
//  DoctorLive
//
//  Created by call soft on 15/09/21.
//

import Foundation

struct PendingBookingModel: Codable {
    let pendingbooking: Pendingbooking?
    let status: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case pendingbooking = "pendingbooking"
        case status = "status"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pendingbooking = try? values.decode(Pendingbooking.self, forKey: .pendingbooking)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}
struct Pendingbooking: Codable {
    let call: [Call]?
    let visit: [Visit]?
    
    private enum CodingKeys: String, CodingKey {
        case call = "call"
        case visit = "visit"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        call = try? values.decode([Call].self, forKey: .call)
        visit = try? values.decode([Visit].self, forKey: .visit)
    }
}

struct Call: Codable {
    let name: String?
    let email: String?
    let mobile: String?
    let id: String?
    let createdDate: String?
    let address: String?
    let bookingType: String?
    let scheduleTime: String?
    let scheduleDate: String?
    let sessionStatus: String?
    let userId: String?
    let reasonVisit: String?
    let memberId: String?
    let memberName: String?
    let memberDob: String?
    let memberGender: String?
    let latitude: String?
    let longitude: String?
    let bookingStatus: String?
    let bookingStatusName: String?
    let filePdf: String?
    let fileImg: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case id = "id"
        case createdDate = "created_date"
        case address = "address"
        case bookingType = "booking_type"
        case scheduleTime = "schedule_time"
        case scheduleDate = "schedule_date"
        case sessionStatus = "session_status"
        case userId = "user_id"
        case reasonVisit = "reason_visit"
        case memberId = "member_id"
        case memberName = "member_name"
        case memberDob = "member_dob"
        case memberGender = "member_gender"
        case latitude = "latitude"
        case longitude = "longitude"
        case bookingStatus = "booking_status"
        case bookingStatusName = "booking_status_name"
        case filePdf = "file_pdf"
        case fileImg = "file_img"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        email = try? values.decode(String.self, forKey: .email)
        mobile = try? values.decode(String.self, forKey: .mobile)
        id = try? values.decode(String.self, forKey: .id)
        createdDate = try? values.decode(String.self, forKey: .createdDate)
        address = try? values.decode(String.self, forKey: .address)
        bookingType = try? values.decode(String.self, forKey: .bookingType)
        scheduleTime = try? values.decode(String.self, forKey: .scheduleTime)
        scheduleDate = try? values.decode(String.self, forKey: .scheduleDate)
        sessionStatus = try? values.decode(String.self, forKey: .sessionStatus)
        userId = try? values.decode(String.self, forKey: .userId)
        reasonVisit = try? values.decode(String.self, forKey: .reasonVisit)
        memberId = try? values.decode(String.self, forKey: .memberId)
        memberName = try? values.decode(String.self, forKey: .memberName)
        memberDob = try? values.decode(String.self, forKey: .memberDob)
        memberGender = try? values.decode(String.self, forKey: .memberGender)
        latitude = try? values.decode(String.self, forKey: .latitude)
        longitude = try? values.decode(String.self, forKey: .longitude)
        bookingStatus = try? values.decode(String.self, forKey: .bookingStatus)
        bookingStatusName = try? values.decode(String.self, forKey: .bookingStatusName)
        filePdf = try? values.decode(String.self, forKey: .filePdf)
        fileImg = try? values.decode(String.self, forKey: .fileImg)
    }
}
struct Visit: Codable {
    let name: String?
    let email: String?
    let mobile: String?
    let id: String?
    let createdDate: String?
    let address: String?
    let bookingType: String?
    let scheduleTime: String?
    let scheduleDate: String?
    let sessionStatus: String?
    let userId: String?
    let reasonVisit: String?
    let memberId: String?
    let memberName: String?
    let memberDob: String?
    let memberGender: String?
    let latitude: String?
    let longitude: String?
    let bookingStatus: String?
    let bookingStatusName: String?
    let filePdf: String?
    let fileImg: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case id = "id"
        case createdDate = "created_date"
        case address = "address"
        case bookingType = "booking_type"
        case scheduleTime = "schedule_time"
        case scheduleDate = "schedule_date"
        case sessionStatus = "session_status"
        case userId = "user_id"
        case reasonVisit = "reason_visit"
        case memberId = "member_id"
        case memberName = "member_name"
        case memberDob = "member_dob"
        case memberGender = "member_gender"
        case latitude = "latitude"
        case longitude = "longitude"
        case bookingStatus = "booking_status"
        case bookingStatusName = "booking_status_name"
        case filePdf = "file_pdf"
        case fileImg = "file_img"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        email = try? values.decode(String.self, forKey: .email)
        mobile = try? values.decode(String.self, forKey: .mobile)
        id = try? values.decode(String.self, forKey: .id)
        createdDate = try? values.decode(String.self, forKey: .createdDate)
        address = try? values.decode(String.self, forKey: .address)
        bookingType = try? values.decode(String.self, forKey: .bookingType)
        scheduleTime = try? values.decode(String.self, forKey: .scheduleTime)
        scheduleDate = try? values.decode(String.self, forKey: .scheduleDate)
        sessionStatus = try? values.decode(String.self, forKey: .sessionStatus)
        userId = try? values.decode(String.self, forKey: .userId)
        reasonVisit = try? values.decode(String.self, forKey: .reasonVisit)
        memberId = try? values.decode(String.self, forKey: .memberId)
        memberName = try? values.decode(String.self, forKey: .memberName)
        memberDob = try? values.decode(String.self, forKey: .memberDob)
        memberGender = try? values.decode(String.self, forKey: .memberGender)
        latitude = try? values.decode(String.self, forKey: .latitude)
        longitude = try? values.decode(String.self, forKey: .longitude)
        bookingStatus = try? values.decode(String.self, forKey: .bookingStatus)
        bookingStatusName = try? values.decode(String.self, forKey: .bookingStatusName)
        filePdf = try? values.decode(String.self, forKey: .filePdf)
        fileImg = try? values.decode(String.self, forKey: .fileImg)
    }
}
