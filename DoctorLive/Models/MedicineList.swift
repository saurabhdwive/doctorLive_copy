//
//  MedicineList.swift
//  DoctorLive
//
//  Created by cst on 28/10/21.
//

import Foundation
struct MedicineListModel: Codable {
    let medicinelisting: [Medicinelisting]?
        let status: String?

        private enum CodingKeys: String, CodingKey {
            case medicinelisting = "medicinelisting"
            case status = "status"
        }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        medicinelisting = try? values.decode([Medicinelisting].self, forKey: .medicinelisting)
        status = try? values.decode(String.self, forKey: .status)
    }
}

struct Medicinelisting: Codable {
    let id: String?
    let genericName: String?
    let brandName: String?
    let form: String?
    let strength: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case genericName = "generic_name"
        case brandName = "brand_name"
        case form = "form"
        case strength = "strength"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        genericName = try? values.decode(String.self, forKey: .genericName)
        brandName = try? values.decode(String.self, forKey: .brandName)
        form = try? values.decode(String.self, forKey: .form)
        strength = try? values.decode(String.self, forKey: .strength)
    }
}
