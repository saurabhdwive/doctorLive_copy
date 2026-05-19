//
//  SavePrescription.swift
//  DoctorLive
//
//  Created by cst on 12/10/21.
//

import Foundation
struct SavePrescriptionModel: Codable {
    let addprescription: String?
    let filePdf: String?
    let fileImg: String?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case addprescription = "addprescription"
        case filePdf = "file_pdf"
        case fileImg = "file_img"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addprescription = try? values.decode(String.self, forKey: .addprescription)
        filePdf = try? values.decode(String.self, forKey: .filePdf)
        fileImg = try? values.decode(String.self, forKey: .fileImg)
        status = try? values.decode(String.self, forKey: .status)
    }
}

//struct MedicineData {
//    var name: String
//    var dosage: String
//    var frequencyFirst: String
//    var duration: String
//    var meals: String
//}

//:- prescription Classes Data
class SavePrescription: Codable {
    let token, languageType, bookingID, userID: String
    let chiefComplain, pastHistory, general, temperature: String
    let bloodFirst, bloodSecond, pulse, bloodSugarFirst: String
    let bloodSugarSecond, diagnosis, investigation: String
    let medicine: [Medicine]
    let generalAdvice, followup, followupValue: String

    enum CodingKeys: String, CodingKey {
        case token
        case languageType = "language_type"
        case bookingID = "booking_id"
        case userID = "user_id"
        case chiefComplain = "chief_complain"
        case pastHistory = "past_history"
        case general, temperature
        case bloodFirst = "blood_first"
        case bloodSecond = "blood_second"
        case pulse
        case bloodSugarFirst = "blood_sugar_first"
        case bloodSugarSecond = "blood_sugar_second"
        case diagnosis, investigation, medicine
        case generalAdvice = "general_advice"
        case followup
        case followupValue = "followup_value"
    }

    init(token: String, languageType: String, bookingID: String, userID: String, chiefComplain: String, pastHistory: String, general: String, temperature: String, bloodFirst: String, bloodSecond: String, pulse: String, bloodSugarFirst: String, bloodSugarSecond: String, diagnosis: String, investigation: String, medicine: [Medicine], generalAdvice: String, followup: String, followupValue: String) {
        self.token = token
        self.languageType = languageType
        self.bookingID = bookingID
        self.userID = userID
        self.chiefComplain = chiefComplain
        self.pastHistory = pastHistory
        self.general = general
        self.temperature = temperature
        self.bloodFirst = bloodFirst
        self.bloodSecond = bloodSecond
        self.pulse = pulse
        self.bloodSugarFirst = bloodSugarFirst
        self.bloodSugarSecond = bloodSugarSecond
        self.diagnosis = diagnosis
        self.investigation = investigation
        self.medicine = medicine
        self.generalAdvice = generalAdvice
        self.followup = followup
        self.followupValue = followupValue
    }
}

// MARK: - Medicine
class Medicine: Codable {
    let id: String
    let name, dosage, frequencyFirst, duration, meals: String
    let toggleBtnState, investigationState, genralExamState, followUpState, comeFromMedicne: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case dosage = "dosage"
        case frequencyFirst = "frequency_first"
        case duration = "duration"
        case meals = "meals"
        case toggleBtnState = "toggleBtnState"
        case investigationState = "investigationState"
        case genralExamState = "genralExamState"
        case followUpState = "followUpState"
        case comeFromMedicne = "comeFromMedicne"
    }
    
    init(id: String, name: String, dosage: String, frequencyFirst: String, duration: String, meals: String, toggleBtnState: Bool, genralExamState: Bool, followUpState: Bool,investigationState: Bool, comeFromMedicne:Bool) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequencyFirst = frequencyFirst
        self.duration = duration
        self.meals = meals
        self.toggleBtnState = toggleBtnState
        self.genralExamState = genralExamState
        self.followUpState = followUpState
        self.investigationState = investigationState
        self.comeFromMedicne = comeFromMedicne
    }
}

