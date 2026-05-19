//
//  AddCompleteDetail.swift
//  DoctorLive
//
//  Created by call soft on 08/09/21.
//

import Foundation
struct AddCompleteDetail: Codable {

    let addprofessionaldetail: Addprofessionaldetail?
    let status: String?
    let message: String?
    private enum CodingKeys: String, CodingKey {
        case addprofessionaldetail = "addprofessionaldetail"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addprofessionaldetail = try? values.decode(Addprofessionaldetail.self, forKey: .addprofessionaldetail)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Addprofessionaldetail: Codable {
    let specialty: String?
    let year: String?
    let month: String?
    let callFees: String?
    let call: String?
    let visitFees: String?
    let visit: String?
    let about: String?
    let image: String?
    let profileStatus: Int?
    private enum CodingKeys: String, CodingKey {
        case specialty = "specialty"
        case year = "year"
        case month = "month"
        case callFees = "call_fees"
        case call = "call"
        case visitFees = "visit_fees"
        case visit = "visit"
        case about = "about"
        case image = "image"
        case profileStatus = "profile_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        specialty = try? values.decode(String.self, forKey: .specialty)
        year = try? values.decode(String.self, forKey: .year)
        month = try? values.decode(String.self, forKey: .month)
        callFees = try? values.decode(String.self, forKey: .callFees)
        call = try? values.decode(String.self, forKey: .call)
        visitFees = try? values.decode(String.self, forKey: .visitFees)
        visit = try? values.decode(String.self, forKey: .visit)
        about = try? values.decode(String.self, forKey: .about)
        image = try? values.decode(String.self, forKey: .image)
        profileStatus = try? values.decode(Int.self, forKey: .profileStatus)
    }
}
