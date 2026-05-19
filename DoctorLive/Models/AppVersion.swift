//
//  AppVersion.swift
//  DoctorLive
//
//  Created by apple on 10/03/22.
//

import Foundation

//struct AppVersionModel: Codable {
//  let version: [Version]?
//    let status: String?
//    let message: String?
//
//    private enum CodingKeys: String, CodingKey {
//        case version = "version"
//        case status = "status"
//        case message = "message"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        version = try? values.decode([Version].self, forKey: .version)
//        status = try? values.decode(String.self, forKey: .status)
//        message = try? values.decode(String.self, forKey: .message)
//    }
//}

//struct Version: Codable {
//    let apiVersion: String?
//    let recommendUpdate: String?
//    let forceUpdate: String?
//    let message: String?
//
//    private enum CodingKeys: String, CodingKey {
//        case apiVersion = "api_version"
//        case recommendUpdate = "recommend_update"
//        case forceUpdate = "force_update"
//        case message = "message"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        apiVersion = try? values.decode(String.self, forKey: .apiVersion)
//        recommendUpdate = try? values.decode(String.self, forKey: .recommendUpdate)
//        forceUpdate = try? values.decode(String.self, forKey: .forceUpdate)
//        message = try? values.decode(String.self, forKey: .message)
//    }
//}

struct AppVersionModel: Codable {
    let version: Version
    let status: String
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case version = "version"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        version = try values.decode(Version.self, forKey: .version)
        status = try values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }


}

struct Version: Codable {
    let doctor: [Doctor]?
    let patient: [Patient]?

    private enum CodingKeys: String, CodingKey {
        case doctor = "doctor"
        case patient = "patient"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        doctor = try? values.decode([Doctor].self, forKey: .doctor)
        patient = try? values.decode([Patient].self, forKey: .patient)
    }
}

struct Doctor: Codable {
    let apiVersion: String?
    let recommendUpdate: String?
    let forceUpdate: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case recommendUpdate = "recommend_update"
        case forceUpdate = "force_update"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        apiVersion = try? values.decode(String.self, forKey: .apiVersion)
        recommendUpdate = try? values.decode(String.self, forKey: .recommendUpdate)
        forceUpdate = try? values.decode(String.self, forKey: .forceUpdate)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Patient: Codable {
    let apiVersion: String?
    let recommendUpdate: String?
    let forceUpdate: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case recommendUpdate = "recommend_update"
        case forceUpdate = "force_update"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        apiVersion = try? values.decode(String.self, forKey: .apiVersion)
        recommendUpdate = try? values.decode(String.self, forKey: .recommendUpdate)
        forceUpdate = try? values.decode(String.self, forKey: .forceUpdate)
        message = try? values.decode(String.self, forKey: .message)
    }
}
