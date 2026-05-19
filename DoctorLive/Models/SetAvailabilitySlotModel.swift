//
//  SetAvailabilitySlotModel.swift
//  DoctorLive
//
//  Created by call soft on 29/09/21.
//

import Foundation
struct SetAvailabilitySlotModel: Codable {
    let addavailability: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case addavailability = "addavailability"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addavailability = try? values.decode(String.self, forKey: .addavailability)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }
}

//class SetAvilability: Codable {
//    let doctorID, id, languageType: String
//    let slot: [Slot]
//
//    enum CodingKeys: String, CodingKey {
//        case doctorID = "doctor_id"
//        case id
//        case languageType = "language_type"
//        case slot
//    }
//
//    init(doctorID: String, id: String, languageType: String, slot: [Slot]) {
//        self.doctorID = doctorID
//        self.id = id
//        self.languageType = languageType
//        self.slot = slot
//    }
//}
//
//// MARK: - Slot
//class Slot: Codable {
//    let slot, clinicName, slotFrom, slotTo: String
//    let availability: String
//
//    enum CodingKeys: String, CodingKey {
//        case slot
//        case clinicName = "clinic_name"
//        case slotFrom = "slot_from"
//        case slotTo = "slot_to"
//        case availability
//    }
//
//    init(slot: String, clinicName: String, slotFrom: String, slotTo: String, availability: String) {
//        self.slot = slot
//        self.clinicName = clinicName
//        self.slotFrom = slotFrom
//        self.slotTo = slotTo
//        self.availability = availability
//    }
//}
//

class SetAvilability: Codable {

    let languageType: String
    let doctorId: String
    let slotId: String
    let status: String
    let slots: [NewSlotAdd]

     enum CodingKeys: String, CodingKey {
        case languageType = "language_type"
        case doctorId = "doctor_id"
        case slotId = "slot_id"
        case status = "status"
        case slots
    }

    init(languageType: String, doctorId: String, slotId: String, status: String, slots: [NewSlotAdd])  {
        self.languageType = languageType
        self.doctorId = doctorId
        self.slotId = slotId
        self.status = status
        self.slots = slots
    }


}

class NewSlotAdd: Codable {
    let slotNum: String
    let from: String
    let to: String
    let clinicId: String
    let status: String

     enum CodingKeys: String, CodingKey {
        case slotNum = "slot_num"
        case from = "from"
        case to = "to"
        case clinicId = "clinic_id"
         case status = "status"
    }

    init(slotNum: String, from: String, to: String, clinicId: String, status: String) {
        self.slotNum = slotNum
        self.from = from
        self.to = to
        self.clinicId = clinicId
        self.status = status
    }
}
