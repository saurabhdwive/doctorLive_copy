//
//  ClinicListModel.swift
//  DoctorLive
//
//  Created by call soft on 13/09/21.
//

import Foundation

struct ClinicListModel: Codable {
    let cliniclisting: [Cliniclisting]?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case cliniclisting = "cliniclisting"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cliniclisting = try? values.decode([Cliniclisting].self, forKey: .cliniclisting)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Cliniclisting: Codable {
    let clinicId: String?
    let clinicName: String?
    let shortName: String?
    let contactNumber: String?
    let address: String?
    let latitude: String?
    let longitude: String?

    private enum CodingKeys: String, CodingKey {
        case clinicId = "clinic_id"
        case clinicName = "clinic_name"
        case shortName = "short_name"
        case contactNumber = "contact_number"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clinicId = try? values.decode(String.self, forKey: .clinicId)
        clinicName = try? values.decode(String.self, forKey: .clinicName)
        shortName = try? values.decode(String.self, forKey: .shortName)
        contactNumber = try? values.decode(String.self, forKey: .contactNumber)
        address = try? values.decode(String.self, forKey: .address)
        latitude = try? values.decode(String.self, forKey: .latitude)
        longitude = try? values.decode(String.self, forKey: .longitude)
    }
}
