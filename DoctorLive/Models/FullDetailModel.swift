//
//  FullDetailModel.swift
//  DoctorLive
//
//  Created by call soft on 08/09/21.
//

import Foundation
struct FullProfileDetailModel: Codable {
    let professionaldetail: Professionaldetail?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case professionaldetail = "professionaldetail"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        professionaldetail = try? values.decode(Professionaldetail.self, forKey: .professionaldetail)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}
struct Professionaldetail: Codable {
    let id: String?
    let specialty: String?
    let year: String?
    let month: String?
    let about: String?
    let image: String?
    let qualification: [Qualification]?
    let experience: [Experience]?
    let bank: [Bank]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case specialty = "specialty"
        case year = "year"
        case month = "month"
        case about = "about"
        case image = "image"
        case qualification = "qualification"
        case experience = "experience"
        case bank = "bank"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        specialty = try? values.decode(String.self, forKey: .specialty)
        year = try? values.decode(String.self, forKey: .year)
        month = try? values.decode(String.self, forKey: .month)
        about = try? values.decode(String.self, forKey: .about)
        image = try? values.decode(String.self, forKey: .image)
        qualification = try? values.decode([Qualification].self, forKey: .qualification)
        experience = try? values.decode([Experience].self, forKey: .experience)
        bank = try? values.decode([Bank].self, forKey: .bank)
    }
}

struct Qualification: Codable {

    let id: String?
    let degree: String?
    let institute: String?
    let country: String?
    let passingYear: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case degree = "degree"
        case institute = "institute"
        case country = "country"
        case passingYear = "passing_year"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        degree = try? values.decode(String.self, forKey: .degree)
        institute = try? values.decode(String.self, forKey: .institute)
        country = try? values.decode(String.self, forKey: .country)
        passingYear = try? values.decode(String.self, forKey: .passingYear)
    }
}

struct Experience: Codable {
    let id: String?
    let designation: String?
    let institute: String?
    let year: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case designation = "designation"
        case institute = "institute"
        case year = "year"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        designation = try? values.decode(String.self, forKey: .designation)
        institute = try? values.decode(String.self, forKey: .institute)
        year = try? values.decode(String.self, forKey: .year)
    }
}

struct Bank: Codable {
    let id: String?
    let bankName: String?
    let branchName: String?
    let acHolder: String?
    let accountNo: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case bankName = "bank_name"
        case branchName = "branch_name"
        case acHolder = "ac_holder"
        case accountNo = "account_no"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        bankName = try? values.decode(String.self, forKey: .bankName)
        branchName = try? values.decode(String.self, forKey: .branchName)
        acHolder = try? values.decode(String.self, forKey: .acHolder)
        accountNo = try? values.decode(String.self, forKey: .accountNo)
    }
}
