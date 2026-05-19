//
//  AvililabilityList.swift
//  DoctorLive
//
//  Created by call soft on 28/09/21.
//

import Foundation
struct AvililabilityListModel: Codable {
    let availabilityfetch: [Availabilityfetch]?
    let status: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case availabilityfetch = "availabilityfetch"
        case status = "status"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        availabilityfetch = try? values.decode([Availabilityfetch].self, forKey: .availabilityfetch)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

struct Availabilityfetch: Codable {
    let id: String?
    let type: String?
    let dayName: String?
    let slots: [Slots]?
    
    let flag: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case dayName = "day_name"
        case slots = "slots"
        case flag = "flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        type = try? values.decode(String.self, forKey: .type)
        dayName = try? values.decode(String.self, forKey: .dayName)
        slots = try? values.decode([Slots].self, forKey: .slots)
        
        flag = try? values.decode(String.self, forKey: .flag)
    }
}

//struct Slots: Codable {
//    let id: String?
//    let slot: String?
//    let clinicName: String?
//    let slotFrom: String?
//    let slotTo: String?
//    let availability: String?
//
//    private enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case slot = "slot"
//        case clinicName = "clinic_name"
//        case slotFrom = "slot_from"
//        case slotTo = "slot_to"
//        case availability = "availability"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try? values.decode(String.self, forKey: .id)
//        slot = try? values.decode(String.self, forKey: .slot)
//        clinicName = try? values.decode(String.self, forKey: .clinicName)
//        slotFrom = try? values.decode(String.self, forKey: .slotFrom)
//        slotTo = try? values.decode(String.self, forKey: .slotTo)
//        availability = try? values.decode(String.self, forKey: .availability)
//    }
//}
struct Slots: Codable {

    let id: String?
    let availableId: String?
    let slots: [Slots1]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case availableId = "available_id"
        case slots = "slots"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        availableId = try? values.decode(String.self, forKey: .availableId)
        slots = try? values.decode([Slots1].self, forKey: .slots)
    }
}

struct Slots1: Codable {
    let slotNum: String?
    let from: String?
    let to: String?
    let clinic: String?
    let clinicId: String?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case slotNum = "slot_num"
        case from = "from"
        case to = "to"
        case clinic = "clinic"
        case clinicId = "clinic_id"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slotNum = try? values.decode(String.self, forKey: .slotNum)
        from = try? values.decode(String.self, forKey: .from)
        to = try? values.decode(String.self, forKey: .to)
        clinic = try? values.decode(String.self, forKey: .clinic)
        clinicId = try? values.decode(String.self, forKey: .clinicId)
        status = try? values.decode(String.self, forKey: .status)
    }
}
