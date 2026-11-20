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
    var general: String?
    var temperature: String?
    var bloodPressureSystolic: String?
    var bloodPressureDiastolic: String?
    var pulse: String?
    var bloodSugar: String?
    var bloodSugarSecond: String?
    var investigations: [String]?
    var followUpDays: String?
    var medicines: [TemplateMedicine]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mongoId = "_id"
        case templateId = "template_id"
        case title
        case name
        case usedCount = "used_count"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case chiefComplain = "chief_complain"
        case pastHistory = "past_history"
        case provisionalDiagnosis = "provisional_diagnosis"
        case diagnosis
        case generalAdvice = "general_advice"
        case advice
        case genralAdvice = "genral_advice"
        case general
        case temperature
        case bloodPressureSystolic = "blood_pressure_systolic"
        case bloodFirst = "blood_first"
        case bloodPressureDiastolic = "blood_pressure_diastolic"
        case bloodSecond = "blood_second"
        case pulse
        case bloodSugar = "blood_sugar"
        case bloodSugarFirst = "blood_sugar_first"
        case bloodSugarSecond = "blood_sugar_second"
        case investigations
        case investigation
        case followUpDays = "follow_up_days"
        case followup
        case followupValue = "followup_value"
        case medicines
        case medicine
    }
    
    init(id: String, title: String, usedCount: Int, updatedAt: String, chiefComplain: String?, pastHistory: String?, provisionalDiagnosis: String?, generalAdvice: String?, general: String? = nil, temperature: String?, bloodPressureSystolic: String?, bloodPressureDiastolic: String?, pulse: String?, bloodSugar: String?, bloodSugarSecond: String? = nil, investigations: [String]?, followUpDays: String?, medicines: [TemplateMedicine]?) {
        self.id = id
        self.title = title
        self.usedCount = usedCount
        self.updatedAt = updatedAt
        self.chiefComplain = chiefComplain
        self.pastHistory = pastHistory
        self.provisionalDiagnosis = provisionalDiagnosis
        self.generalAdvice = generalAdvice
        self.general = general
        self.temperature = temperature
        self.bloodPressureSystolic = bloodPressureSystolic
        self.bloodPressureDiastolic = bloodPressureDiastolic
        self.pulse = pulse
        self.bloodSugar = bloodSugar
        self.bloodSugarSecond = bloodSugarSecond
        self.investigations = investigations
        self.followUpDays = followUpDays
        self.medicines = medicines
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        if let sId = try? c.decodeIfPresent(String.self, forKey: .id) {
            id = sId
        } else if let tId = try? c.decodeIfPresent(String.self, forKey: .templateId) {
            id = tId
        } else if let iId = try? c.decodeIfPresent(Int.self, forKey: .id) {
            id = "\(iId)"
        } else if let itId = try? c.decodeIfPresent(Int.self, forKey: .templateId) {
            id = "\(itId)"
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
        
        // Diagnosis / Provisional Diagnosis
        provisionalDiagnosis = (try? c.decodeIfPresent(String.self, forKey: .provisionalDiagnosis)) ??
                               (try? c.decodeIfPresent(String.self, forKey: .diagnosis))
        
        // General Advice
        generalAdvice = (try? c.decodeIfPresent(String.self, forKey: .generalAdvice)) ??
                        (try? c.decodeIfPresent(String.self, forKey: .advice)) ??
                        (try? c.decodeIfPresent(String.self, forKey: .genralAdvice))
        
        // General exam toggle
        if let gStr = try? c.decodeIfPresent(String.self, forKey: .general) {
            general = gStr
        } else if let gInt = try? c.decodeIfPresent(Int.self, forKey: .general) {
            general = "\(gInt)"
        } else {
            general = nil
        }
        
        temperature = try? c.decodeIfPresent(String.self, forKey: .temperature)
        bloodPressureSystolic = (try? c.decodeIfPresent(String.self, forKey: .bloodPressureSystolic)) ?? (try? c.decodeIfPresent(String.self, forKey: .bloodFirst))
        bloodPressureDiastolic = (try? c.decodeIfPresent(String.self, forKey: .bloodPressureDiastolic)) ?? (try? c.decodeIfPresent(String.self, forKey: .bloodSecond))
        pulse = try? c.decodeIfPresent(String.self, forKey: .pulse)
        bloodSugar = (try? c.decodeIfPresent(String.self, forKey: .bloodSugar)) ?? (try? c.decodeIfPresent(String.self, forKey: .bloodSugarFirst))
        bloodSugarSecond = try? c.decodeIfPresent(String.self, forKey: .bloodSugarSecond)
        
        // Follow-up Days (follow_up_days, followup, followup_value)
        if let fStr = try? c.decodeIfPresent(String.self, forKey: .followUpDays), !fStr.isEmpty {
            followUpDays = fStr
        } else if let fVal = try? c.decodeIfPresent(String.self, forKey: .followup), !fVal.isEmpty {
            followUpDays = fVal
        } else if let fVal2 = try? c.decodeIfPresent(String.self, forKey: .followupValue), !fVal2.isEmpty {
            followUpDays = fVal2
        } else if let fInt = try? c.decodeIfPresent(Int.self, forKey: .followUpDays) {
            followUpDays = "\(fInt)"
        } else if let fInt2 = try? c.decodeIfPresent(Int.self, forKey: .followup) {
            followUpDays = "\(fInt2)"
        } else if let fInt3 = try? c.decodeIfPresent(Int.self, forKey: .followupValue) {
            followUpDays = "\(fInt3)"
        } else {
            followUpDays = nil
        }
        
        // Investigations (array of strings, array of dicts, or comma-separated string)
        if let invArr = try? c.decodeIfPresent([String].self, forKey: .investigations) {
            investigations = invArr.filter { !$0.isEmpty }
        } else if let invArr2 = try? c.decodeIfPresent([String].self, forKey: .investigation) {
            investigations = invArr2.filter { !$0.isEmpty }
        } else if let invObjArr = try? c.decodeIfPresent([GenericInvestigationItem].self, forKey: .investigation) {
            investigations = invObjArr.compactMap { $0.resolvedName }.filter { !$0.isEmpty }
        } else if let invObjArr2 = try? c.decodeIfPresent([GenericInvestigationItem].self, forKey: .investigations) {
            investigations = invObjArr2.compactMap { $0.resolvedName }.filter { !$0.isEmpty }
        } else if let invStr = try? c.decodeIfPresent(String.self, forKey: .investigations) {
            investigations = invStr.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        } else if let invStr2 = try? c.decodeIfPresent(String.self, forKey: .investigation) {
            investigations = invStr2.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
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
        try container.encodeIfPresent(provisionalDiagnosis, forKey: .diagnosis)
        try container.encodeIfPresent(generalAdvice, forKey: .generalAdvice)
        try container.encodeIfPresent(general, forKey: .general)
        try container.encodeIfPresent(temperature, forKey: .temperature)
        try container.encodeIfPresent(bloodPressureSystolic, forKey: .bloodPressureSystolic)
        try container.encodeIfPresent(bloodPressureSystolic, forKey: .bloodFirst)
        try container.encodeIfPresent(bloodPressureDiastolic, forKey: .bloodPressureDiastolic)
        try container.encodeIfPresent(bloodPressureDiastolic, forKey: .bloodSecond)
        try container.encodeIfPresent(pulse, forKey: .pulse)
        try container.encodeIfPresent(bloodSugar, forKey: .bloodSugar)
        try container.encodeIfPresent(bloodSugar, forKey: .bloodSugarFirst)
        try container.encodeIfPresent(bloodSugarSecond, forKey: .bloodSugarSecond)
        try container.encodeIfPresent(investigations, forKey: .investigations)
        try container.encodeIfPresent(investigations, forKey: .investigation)
        try container.encodeIfPresent(followUpDays, forKey: .followUpDays)
        try container.encodeIfPresent(followUpDays, forKey: .followup)
        try container.encodeIfPresent(medicines, forKey: .medicines)
    }
}

// Helper for investigations if returned as an array of objects
private struct GenericInvestigationItem: Codable {
    var name: String?
    var investigation: String?
    var title: String?
    
    var resolvedName: String? {
        return name ?? investigation ?? title
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
    var strength: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case medicine
        case medicineName = "medicine_name"
        case dosage
        case frequencyFirst = "frequency_first"
        case duration
        case meals
        case strength
        case medicineStrength = "medicine_strength"
    }
    
    init(id: String?, name: String, dosage: String, frequencyFirst: String, duration: String, meals: String, strength: String? = nil) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequencyFirst = frequencyFirst
        self.duration = duration
        self.meals = meals
        self.strength = strength
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
        
        let rawName = (try? c.decodeIfPresent(String.self, forKey: .name)) ??
                      (try? c.decodeIfPresent(String.self, forKey: .medicine)) ??
                      (try? c.decodeIfPresent(String.self, forKey: .medicineName)) ?? ""
        
        let str = (try? c.decodeIfPresent(String.self, forKey: .strength)) ??
                  (try? c.decodeIfPresent(String.self, forKey: .medicineStrength))
        strength = str
        
        if let str = str, !str.isEmpty, !rawName.contains(str) {
            name = "\(rawName) \(str)"
        } else {
            name = rawName
        }
        
        dosage = (try? c.decodeIfPresent(String.self, forKey: .dosage)) ?? ""
        frequencyFirst = (try? c.decodeIfPresent(String.self, forKey: .frequencyFirst)) ?? ""
        duration = (try? c.decodeIfPresent(String.self, forKey: .duration)) ?? ""
        meals = (try? c.decodeIfPresent(String.self, forKey: .meals)) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(name, forKey: .medicine)
        try c.encode(dosage, forKey: .dosage)
        try c.encode(frequencyFirst, forKey: .frequencyFirst)
        try c.encode(duration, forKey: .duration)
        try c.encode(meals, forKey: .meals)
        try c.encodeIfPresent(strength, forKey: .medicineStrength)
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
