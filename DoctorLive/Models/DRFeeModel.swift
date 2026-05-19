//
//  DRFeeModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on November 12, 2021
//
import Foundation

struct DRFeeModel: Codable {
    let feesdetail: Feesdetail?
	let status: String?

	private enum CodingKeys: String, CodingKey {
		case feesdetail = "feesdetail"
		case status = "status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		feesdetail = try? values.decode(Feesdetail.self, forKey: .feesdetail)
		status = try? values.decode(String.self, forKey: .status)
	}
}
struct Feesdetail: Codable {
   let callPrice: String?
    let call: String?
    let callPercent: Int?
    let visitPrice: String?
    let visit: String?
    let visitPercent: String?
    let followup: String?
    let followupPrice: String?
    let followupPercent: Int?

    private enum CodingKeys: String, CodingKey {
        case callPrice = "call_price"
        case call = "call"
        case callPercent = "call_percent"
        case visitPrice = "visit_price"
        case visit = "visit"
        case visitPercent = "visit_percent"
        case followup = "followup"
        case followupPrice = "followup_price"
        case followupPercent = "followup_percent"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        callPrice = try? values.decode(String.self, forKey: .callPrice)
        call = try? values.decode(String.self, forKey: .call)
        callPercent = try? values.decode(Int.self, forKey: .callPercent)
        visitPrice = try? values.decode(String.self, forKey: .visitPrice)
        visit = try? values.decode(String.self, forKey: .visit)
        visitPercent = try? values.decode(String.self, forKey: .visitPercent)
        followup = try? values.decode(String.self, forKey: .followup)
        followupPrice = try? values.decode(String.self, forKey: .followupPrice)
        followupPercent = try? values.decode(Int.self, forKey: .followupPercent)
    }
}
