//
//  SignUpModel.swift
//  DoctorLive
//
//  Created by call soft on 02/09/21.
//

import Foundation
struct SignUpModel: Codable {
    let signup: Signup?
    let status: String?
    let message: String?
    private enum CodingKeys: String, CodingKey {
        case signup = "signup"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        signup = try? values.decode(Signup.self, forKey: .signup)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }

}
struct Signup: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let mobile: String?
    let countryCode: String?
    let dob: String?
    let gender: String?
    let address: String?
    let token: String?
    let loginType: String?
    let verifyStatus: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case countryCode = "country_code"
        case dob = "dob"
        case gender = "gender"
        case address = "address"
        case token = "token"
        case loginType = "login_type"
        case verifyStatus = "verify_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        email = try values.decode(String.self, forKey: .email)
        mobile = try values.decode(String.self, forKey: .mobile)
        countryCode = try values.decode(String.self, forKey: .countryCode)
        dob = try values.decode(String.self, forKey: .dob)
        gender = try values.decode(String.self, forKey: .gender)
        address = try values.decode(String.self, forKey: .address)
        token = try values.decode(String.self, forKey: .token)
        loginType = try values.decode(String.self, forKey: .loginType)
        verifyStatus = try values.decode(String.self, forKey: .verifyStatus)
    }
}
