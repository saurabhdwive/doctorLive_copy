//
//  WidhrawListModel.swift
//  DoctorLive
//
//  Created by cst on 28/10/21.
//

import Foundation
struct WidhrawListModel: Codable {
    let mywithdraw: Mywithdraw?
    let status: String?
    private enum CodingKeys: String, CodingKey {
        case mywithdraw = "mywithdraw"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mywithdraw = try? values.decode(Mywithdraw.self, forKey: .mywithdraw)
        status = try? values.decode(String.self, forKey: .status)
    }
}

struct Mywithdraw: Codable {
    let earning: [WithdrawEarning]?
    let totalEarning: Float?
    let paid: Float?
    let due: Float?
    
    private enum CodingKeys: String, CodingKey {
        case earning = "earning"
        case totalEarning = "totalEarning"
        case paid = "paid"
        case due = "due"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        earning = try? values.decode([WithdrawEarning].self, forKey: .earning)
        totalEarning = try? values.decode(Float.self, forKey: .totalEarning)
        paid = try? values.decode(Float.self, forKey: .paid)
        due = try? values.decode(Float.self, forKey: .due)
    }
}
struct WithdrawEarning: Codable {
    let id: String?
    let bankName: String?
    let accountNumber: String?
    let createdDate: String?
    let fees: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case bankName = "bank_name"
        case accountNumber = "account_number"
        case createdDate = "created_date"
        case fees = "fees"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        bankName = try? values.decode(String.self, forKey: .bankName)
        accountNumber = try? values.decode(String.self, forKey: .accountNumber)
        createdDate = try? values.decode(String.self, forKey: .createdDate)
        fees = try? values.decode(String.self, forKey: .fees)
    }
}
