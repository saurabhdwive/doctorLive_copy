//
//  UpdateAvilability.swift
//  DoctorLive
//
//  Created by call soft on 01/10/21.
//

import Foundation
struct UpdateAvilabilityModel: Codable {
    let updateavailability: String?
    let status: String?
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case updateavailability = "updateavailability"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        updateavailability = try? values.decode(String.self, forKey: .updateavailability)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
    }

}

class UpdateAvilability: Codable {
    let languageType: String
    let availabilityID: Int
    let slots: [Slot1]

    enum CodingKeys: String, CodingKey {
        case languageType = "language_type"
        case availabilityID = "availability_id"
        case slots
    }

    init(languageType: String, availabilityID: Int, slots: [Slot1]) {
        self.languageType = languageType
        self.availabilityID = availabilityID
        self.slots = slots
    }
}

// MARK: - Slot
class Slot1: Codable {
    let id: Int
    let slot, clinicName, slotFrom, slotTo: String
    let availability: String

    enum CodingKeys: String, CodingKey {
        case id, slot
        case clinicName = "clinic_name"
        case slotFrom = "slot_from"
        case slotTo = "slot_to"
        case availability
    }

    init(id: Int, slot: String, clinicName: String, slotFrom: String, slotTo: String, availability: String) {
        self.id = id
        self.slot = slot
        self.clinicName = clinicName
        self.slotFrom = slotFrom
        self.slotTo = slotTo
        self.availability = availability
    }
}
