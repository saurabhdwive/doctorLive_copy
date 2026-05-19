//
//  AddBank.swift
//  DoctorLive
//
//  Created by call soft on 08/09/21.
//

import Foundation
struct AddBank: Codable {
    let addbank: [Addbank]?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case addbank = "addbank"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addbank = try? values.decode([Addbank].self, forKey: .addbank)
        status = try? values.decode(String.self, forKey: .status)
    }
}
struct Addbank: Codable {
    let id: String?
    let doctorId: String?
    let bankName: String?
    let branchName: String?
    let acHolder: String?
    let accountNo: String?
    let ifscCode: String?
    let status: String?
    let createdDate: String?
    let updatedDate: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case doctorId = "doctor_id"
        case bankName = "bank_name"
        case branchName = "branch_name"
        case acHolder = "ac_holder"
        case accountNo = "account_no"
        case ifscCode = "ifsc_code"
        case status = "status"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        doctorId = try? values.decode(String.self, forKey: .doctorId)
        bankName = try? values.decode(String.self, forKey: .bankName)
        branchName = try? values.decode(String.self, forKey: .branchName)
        acHolder = try? values.decode(String.self, forKey: .acHolder)
        accountNo = try? values.decode(String.self, forKey: .accountNo)
        ifscCode = try? values.decode(String.self, forKey: .ifscCode)
        status = try? values.decode(String.self, forKey: .status)
        createdDate = try? values.decode(String.self, forKey: .createdDate)
        updatedDate = try? values.decode(String.self, forKey: .updatedDate)
    }
}
