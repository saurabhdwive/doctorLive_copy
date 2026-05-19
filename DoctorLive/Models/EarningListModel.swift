//
//  EarningListModel.swift
//  DoctorLive
//
//  Created by cst on 10/10/21.
//

import Foundation
struct EarningListModel: Codable {
    let myearning: Myearning?
    let status: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case myearning = "myearning"
        case status = "status"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        myearning = try? values.decode(Myearning.self, forKey: .myearning)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Myearning: Codable {
    let earning: [Earning]?
    let totalEarning: String?
    let bank: Bank?
    let paid: Int?
    let due: Int?
    
    private enum CodingKeys: String, CodingKey {
        case earning = "earning"
        case totalEarning = "totalEarning"
        case bank = "bank"
        case paid = "paid"
        case due = "due"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        earning = try? values.decode([Earning].self, forKey: .earning)
        totalEarning = try? values.decode(String.self, forKey: .totalEarning)
        bank = try? values.decode(Bank.self, forKey: .bank)
        paid = try? values.decode(Int.self, forKey: .paid)
        due = try? values.decode(Int.self, forKey: .due)
    }
    
}
struct Earning: Codable {
    let id: String?
    let doctorName: String?
    let bookingId: String?
    let booking: String?
    let bookingDate: String?
    let amount: String?
    let patient_name: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case doctorName = "doctor_name"
        case bookingId = "booking_id"
        case booking = "booking"
        case bookingDate = "booking_date"
        case amount = "amount"
        case patient_name = "patient_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        doctorName = try? values.decode(String.self, forKey: .doctorName)
        bookingId = try? values.decode(String.self, forKey: .bookingId)
        booking = try? values.decode(String.self, forKey: .booking)
        bookingDate = try? values.decode(String.self, forKey: .bookingDate)
        amount = try? values.decode(String.self, forKey: .amount)
        patient_name = try? values.decode(String.self, forKey: .patient_name)
    }
    
}
