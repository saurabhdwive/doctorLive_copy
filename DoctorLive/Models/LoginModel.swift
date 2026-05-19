//
//  LoginModel.swift
//  DoctorLive
//
//  Created by call soft on 02/09/21.
//

import Foundation
import SwiftyJSON

struct LoginDataModel: Codable {
    let login: Login?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case login = "login"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try? values.decode(Login.self, forKey: .login)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Login: Codable {
    let id: String?
    let name: String?
    let email: String?
    let mobile: String?
    let countryCode: String?
    let dob: String?
    let gender: String?
    let address: String?
    let image: String?
    let token: String?
    let profileStatus: String?
    let verifyStatus: String?
    let availableStatus: String?
    let rating: String?
    let badgeCount: Int?
    let language: String?
    let notificationStatus: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case countryCode = "country_code"
        case dob = "dob"
        case gender = "gender"
        case address = "address"
        case image = "image"
        case token = "token"
        case profileStatus = "profile_status"
        case verifyStatus = "verify_status"
        case availableStatus = "available_status"
        case rating = "rating"
        case badgeCount = "badge_count"
        case language = "language"
        case notificationStatus = "notification_status"
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
        token = try? values.decode(String.self, forKey: .token)
        profileStatus = try? values.decode(String.self, forKey: .profileStatus)
        verifyStatus = try? values.decode(String.self, forKey: .verifyStatus)
        availableStatus = try? values.decode(String.self, forKey: .availableStatus)
        rating = try? values.decode(String.self, forKey: .rating)
        badgeCount = try? values.decode(Int.self, forKey: .badgeCount)
        language = try? values.decode(String.self, forKey: .language)
        notificationStatus = try? values.decode(String.self, forKey: .notificationStatus)
    }
}
