//
//  DoctorProfile.swift
//  DoctorLive
//
//  Created by call soft on 10/09/21.
//

import Foundation
struct DoctorProfileModel: Codable {
    let personaldetail: Personaldetail?
    let status: String?
    let message: String?
    private enum CodingKeys: String, CodingKey {
        case personaldetail = "personaldetail"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personaldetail = try? values.decode(Personaldetail.self, forKey: .personaldetail)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Personaldetail: Codable {
    let id: String?
    let name: String?
    let email: String?
    let mobile: String?
    let countryCode: String?
    let dob: String?
    let earning_amount: String?
    let gender: String?
    let address: String?
    let image: String?
    let passportNum: String?
    let registrationNum: String?
    let joiningDate: String?
    let totalConsult: Int?
    let totalCallConsult: Int?
    let totalVisitConsult: Int?
    let onCall: String?
    let onVisit: String?
    let callFees: String?
    let visitFees: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case earning_amount = "earning_amount"
        case countryCode = "country_code"
        case dob = "dob"
        case gender = "gender"
        case address = "address"
        case image = "image"
        case passportNum = "passport_num"
        case registrationNum = "registration_num"
        case joiningDate = "joining_date"
        case totalConsult = "totalConsult"
        case totalCallConsult = "totalCallConsult"
        case totalVisitConsult = "totalVisitConsult"
        case onCall = "on_call"
        case onVisit = "on_visit"
        case callFees = "call_fees"
        case visitFees = "visit_fees"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        email = try? values.decode(String.self, forKey: .email)
        mobile = try? values.decode(String.self, forKey: .mobile)
        countryCode = try? values.decode(String.self, forKey: .countryCode)
        dob = try? values.decode(String.self, forKey: .dob)
        gender = try? values.decode(String.self, forKey: .gender)
        address = try? values.decode(String.self, forKey: .address)
        image = try? values.decode(String.self, forKey: .image)
        passportNum = try? values.decode(String.self, forKey: .passportNum)
        registrationNum = try? values.decode(String.self, forKey: .registrationNum)
        joiningDate = try? values.decode(String.self, forKey: .joiningDate)
        totalConsult = try? values.decode(Int.self, forKey: .totalConsult)
        totalCallConsult = try? values.decode(Int.self, forKey: .totalCallConsult)
        totalVisitConsult = try? values.decode(Int.self, forKey: .totalVisitConsult)
        onCall = try? values.decode(String.self, forKey: .onCall)
        onVisit = try? values.decode(String.self, forKey: .onVisit)
        callFees = try? values.decode(String.self, forKey: .callFees)
        visitFees = try? values.decode(String.self, forKey: .visitFees)
        earning_amount = try? values.decode(String.self, forKey: .earning_amount)
    }
}
