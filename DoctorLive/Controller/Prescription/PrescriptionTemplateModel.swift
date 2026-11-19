//
//  PrescriptionTemplateModel.swift
//  DoctorLive
//
//  Created for Prescription Templates Feature.
//

import Foundation

// MARK: - Prescription Template Model
struct PrescriptionTemplate: Codable {
    var id: String
    var title: String
    var usedCount: Int
    var updatedAt: String
    var chiefComplain: String?
    var pastHistory: String?
    var provisionalDiagnosis: String?
    var generalAdvice: String?
    var temperature: String?
    var bloodPressureSystolic: String?
    var bloodPressureDiastolic: String?
    var pulse: String?
    var bloodSugar: String?
    var investigations: [String]?
    var followUpDays: String?
    var medicines: [TemplateMedicine]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mongoId = "_id"
        case title
        case name
        case usedCount = "used_count"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case chiefComplain = "chief_complain"
        case pastHistory = "past_history"
        case provisionalDiagnosis = "provisional_diagnosis"
        case generalAdvice = "general_advice"
        case temperature
        case bloodPressureSystolic = "blood_pressure_systolic"
        case bloodPressureDiastolic = "blood_pressure_diastolic"
        case pulse
        case bloodSugar = "blood_sugar"
        case investigations
        case followUpDays = "follow_up_days"
        case medicines
        case medicine
    }
    
    init(id: String, title: String, usedCount: Int, updatedAt: String, chiefComplain: String?, pastHistory: String?, provisionalDiagnosis: String?, generalAdvice: String?, temperature: String?, bloodPressureSystolic: String?, bloodPressureDiastolic: String?, pulse: String?, bloodSugar: String?, investigations: [String]?, followUpDays: String?, medicines: [TemplateMedicine]?) {
        self.id = id
        self.title = title
        self.usedCount = usedCount
        self.updatedAt = updatedAt
        self.chiefComplain = chiefComplain
        self.pastHistory = pastHistory
        self.provisionalDiagnosis = provisionalDiagnosis
        self.generalAdvice = generalAdvice
        self.temperature = temperature
        self.bloodPressureSystolic = bloodPressureSystolic
        self.bloodPressureDiastolic = bloodPressureDiastolic
        self.pulse = pulse
        self.bloodSugar = bloodSugar
        self.investigations = investigations
        self.followUpDays = followUpDays
        self.medicines = medicines
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        if let sId = try? c.decodeIfPresent(String.self, forKey: .id) {
            id = sId
        } else if let iId = try? c.decodeIfPresent(Int.self, forKey: .id) {
            id = "\(iId)"
        } else if let mId = try? c.decodeIfPresent(String.self, forKey: .mongoId) {
            id = mId
        } else {
            id = UUID().uuidString
        }
        
        if let t = try? c.decodeIfPresent(String.self, forKey: .title) {
            title = t
        } else if let n = try? c.decodeIfPresent(String.self, forKey: .name) {
            title = n
        } else {
            title = "Untitled Template"
        }
        
        if let uInt = try? c.decodeIfPresent(Int.self, forKey: .usedCount) {
            usedCount = uInt
        } else if let uStr = try? c.decodeIfPresent(String.self, forKey: .usedCount), let uVal = Int(uStr) {
            usedCount = uVal
        } else {
            usedCount = 0
        }
        
        if let uDate = try? c.decodeIfPresent(String.self, forKey: .updatedAt) {
            updatedAt = uDate
        } else if let cDate = try? c.decodeIfPresent(String.self, forKey: .createdAt) {
            updatedAt = cDate
        } else {
            updatedAt = "Recently"
        }
        
        chiefComplain = try? c.decodeIfPresent(String.self, forKey: .chiefComplain)
        pastHistory = try? c.decodeIfPresent(String.self, forKey: .pastHistory)
        provisionalDiagnosis = try? c.decodeIfPresent(String.self, forKey: .provisionalDiagnosis)
        generalAdvice = try? c.decodeIfPresent(String.self, forKey: .generalAdvice)
        temperature = try? c.decodeIfPresent(String.self, forKey: .temperature)
        bloodPressureSystolic = try? c.decodeIfPresent(String.self, forKey: .bloodPressureSystolic)
        bloodPressureDiastolic = try? c.decodeIfPresent(String.self, forKey: .bloodPressureDiastolic)
        pulse = try? c.decodeIfPresent(String.self, forKey: .pulse)
        bloodSugar = try? c.decodeIfPresent(String.self, forKey: .bloodSugar)
        
        if let fStr = try? c.decodeIfPresent(String.self, forKey: .followUpDays) {
            followUpDays = fStr
        } else if let fInt = try? c.decodeIfPresent(Int.self, forKey: .followUpDays) {
            followUpDays = "\(fInt)"
        } else {
            followUpDays = nil
        }
        
        if let invArr = try? c.decodeIfPresent([String].self, forKey: .investigations) {
            investigations = invArr
        } else if let invStr = try? c.decodeIfPresent(String.self, forKey: .investigations) {
            investigations = invStr.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        } else {
            investigations = nil
        }
        
        if let mList = try? c.decodeIfPresent([TemplateMedicine].self, forKey: .medicines) {
            medicines = mList
        } else if let mList2 = try? c.decodeIfPresent([TemplateMedicine].self, forKey: .medicine) {
            medicines = mList2
        } else {
            medicines = []
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(usedCount, forKey: .usedCount)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(chiefComplain, forKey: .chiefComplain)
        try container.encodeIfPresent(pastHistory, forKey: .pastHistory)
        try container.encodeIfPresent(provisionalDiagnosis, forKey: .provisionalDiagnosis)
        try container.encodeIfPresent(generalAdvice, forKey: .generalAdvice)
        try container.encodeIfPresent(temperature, forKey: .temperature)
        try container.encodeIfPresent(bloodPressureSystolic, forKey: .bloodPressureSystolic)
        try container.encodeIfPresent(bloodPressureDiastolic, forKey: .bloodPressureDiastolic)
        try container.encodeIfPresent(pulse, forKey: .pulse)
        try container.encodeIfPresent(bloodSugar, forKey: .bloodSugar)
        try container.encodeIfPresent(investigations, forKey: .investigations)
        try container.encodeIfPresent(followUpDays, forKey: .followUpDays)
        try container.encodeIfPresent(medicines, forKey: .medicines)
    }
}

// MARK: - Template Medicine Model
struct TemplateMedicine: Codable {
    var id: String?
    var name: String
    var dosage: String
    var frequencyFirst: String
    var duration: String
    var meals: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case dosage
        case frequencyFirst = "frequency_first"
        case duration
        case meals
    }
    
    init(id: String?, name: String, dosage: String, frequencyFirst: String, duration: String, meals: String) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequencyFirst = frequencyFirst
        self.duration = duration
        self.meals = meals
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let sId = try? c.decodeIfPresent(String.self, forKey: .id) {
            id = sId
        } else if let iId = try? c.decodeIfPresent(Int.self, forKey: .id) {
            id = "\(iId)"
        } else {
            id = nil
        }
        name = (try? c.decodeIfPresent(String.self, forKey: .name)) ?? ""
        dosage = (try? c.decodeIfPresent(String.self, forKey: .dosage)) ?? ""
        frequencyFirst = (try? c.decodeIfPresent(String.self, forKey: .frequencyFirst)) ?? ""
        duration = (try? c.decodeIfPresent(String.self, forKey: .duration)) ?? ""
        meals = (try? c.decodeIfPresent(String.self, forKey: .meals)) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(dosage, forKey: .dosage)
        try c.encode(frequencyFirst, forKey: .frequencyFirst)
        try c.encode(duration, forKey: .duration)
        try c.encode(meals, forKey: .meals)
    }
}

// MARK: - API Response Wrappers
struct PrescriptionTemplateListResponse: Codable {
    var status: String?
    var message: String?
    var data: [PrescriptionTemplate]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
        case template
        case templates
        case prescriptionTemplate = "prescription_template"
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try? container.decodeIfPresent(String.self, forKey: .status)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        
        if let d = try? container.decodeIfPresent([PrescriptionTemplate].self, forKey: .data) {
            data = d
        } else if let t = try? container.decodeIfPresent([PrescriptionTemplate].self, forKey: .template) {
            data = t
        } else if let ts = try? container.decodeIfPresent([PrescriptionTemplate].self, forKey: .templates) {
            data = ts
        } else if let pt = try? container.decodeIfPresent([PrescriptionTemplate].self, forKey: .prescriptionTemplate) {
            data = pt
        } else if let l = try? container.decodeIfPresent([PrescriptionTemplate].self, forKey: .list) {
            data = l
        } else {
            data = []
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(data, forKey: .data)
    }
}

struct PrescriptionTemplateDetailResponse: Codable {
    var status: String?
    var message: String?
    var data: PrescriptionTemplate?
}

struct PrescriptionTemplateCommonResponse: Codable {
    var status: String?
    var message: String?
    var templateId: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case templateId = "template_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try? container.decodeIfPresent(String.self, forKey: .status)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        if let sId = try? container.decodeIfPresent(String.self, forKey: .templateId) {
            templateId = sId
        } else if let iId = try? container.decodeIfPresent(Int.self, forKey: .templateId) {
            templateId = "\(iId)"
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(templateId, forKey: .templateId)
    }
}
