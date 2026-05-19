//
//  UpdatePersonalDetails.swift
//  DoctorLive
//
//  Created by call soft on 10/09/21.
//

import Foundation

struct UpdatePersonalDetails: Codable {
    let updatepersonaldetail: Updatepersonaldetail?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case updatepersonaldetail = "updatepersonaldetail"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        updatepersonaldetail = try? values.decode(Updatepersonaldetail.self, forKey: .updatepersonaldetail)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Updatepersonaldetail: Codable {
    let id: String?
    let name: String?
    let email: String?
    let mobile: String?
    let referralCode: String?
    let countryCode: String?
    let dob: String?
    let gender: String?
    let address: String?
    let image: String?
    let passportNum: String?
    let registrationNum: String?
    let joiningDate: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case referralCode = "referral_code"
        case countryCode = "country_code"
        case dob = "dob"
        case gender = "gender"
        case address = "address"
        case image = "image"
        case passportNum = "passport_num"
        case registrationNum = "registration_num"
        case joiningDate = "joining_date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        email = try? values.decode(String.self, forKey: .email)
        mobile = try? values.decode(String.self, forKey: .mobile)
        referralCode = try? values.decode(String.self, forKey: .referralCode)
        countryCode = try? values.decode(String.self, forKey: .countryCode)
        dob = try? values.decode(String.self, forKey: .dob)
        gender = try? values.decode(String.self, forKey: .gender)
        address = try? values.decode(String.self, forKey: .address)
        image = try? values.decode(String.self, forKey: .image)
        passportNum = try? values.decode(String.self, forKey: .passportNum)
        registrationNum = try? values.decode(String.self, forKey: .registrationNum)
        joiningDate = try? values.decode(String.self, forKey: .joiningDate)
    }
 }

