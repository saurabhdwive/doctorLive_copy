//
//  DoctorMemberModel.swift
//  DoctorLive
//

import Foundation

// MARK: - PatientMember
struct PatientMember: Codable {
    let member_id: String?
    let member_name: String?
    let member_dob: String?
    let member_gender: String?
    let member_relationship: String?
    let member_created_date: String?
    
    enum CodingKeys: String, CodingKey {
        case member_id
        case member_name
        case member_dob
        case member_gender
        case member_relationship
        case member_created_date
    }
    
    init(member_id: String?, member_name: String?, member_dob: String?, member_gender: String?, member_relationship: String?, member_created_date: String? = nil) {
        self.member_id = member_id
        self.member_name = member_name
        self.member_dob = member_dob
        self.member_gender = member_gender
        self.member_relationship = member_relationship
        self.member_created_date = member_created_date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intId = try? container.decode(Int.self, forKey: .member_id) {
            member_id = "\(intId)"
        } else {
            member_id = try? container.decode(String.self, forKey: .member_id)
        }
        member_name = try? container.decode(String.self, forKey: .member_name)
        if let intDob = try? container.decode(Int.self, forKey: .member_dob) {
            member_dob = "\(intDob)"
        } else {
            member_dob = try? container.decode(String.self, forKey: .member_dob)
        }
        member_gender = try? container.decode(String.self, forKey: .member_gender)
        member_relationship = try? container.decode(String.self, forKey: .member_relationship)
        member_created_date = try? container.decode(String.self, forKey: .member_created_date)
    }
    
    static func formatGender(_ raw: String?) -> String {
        guard let g = raw?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !g.isEmpty else {
            return ""
        }
        if g.hasPrefix("m") { return "Male" }
        if g.hasPrefix("f") { return "Female" }
        return "Others"
    }
    
    static func formatAge(from rawDob: String?) -> String {
        guard let dob = rawDob?.trimmingCharacters(in: .whitespacesAndNewlines), !dob.isEmpty else {
            return ""
        }
        
        // If dob is already a numeric age (e.g. "1", "5", "32")
        if let years = Int(dob) {
            return "\(years)y"
        }
        
        // If dob contains "Yrs" or "y"
        let cleaned = dob.replacingOccurrences(of: " Yrs,", with: "")
                         .replacingOccurrences(of: "Yrs,", with: "")
                         .replacingOccurrences(of: " Yrs", with: "")
                         .replacingOccurrences(of: "yrs", with: "")
                         .replacingOccurrences(of: "y", with: "")
                         .trimmingCharacters(in: .whitespacesAndNewlines)
        if let years = Int(cleaned) {
            return "\(years)y"
        }
        
        // Try parsing date formats (e.g. "1994-12-12" or "1994/12/12" or "dd-MM-yyyy")
        let formatters = ["yyyy-MM-dd", "yyyy/MM/dd", "dd-MM-yyyy", "dd/MM/yyyy", "yyyy-MM-dd'T'HH:mm:ss.000Z"]
        for format in formatters {
            let df = DateFormatter()
            df.dateFormat = format
            if let birthDate = df.date(from: dob) {
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
                if let age = ageComponents.year, age >= 0 {
                    return "\(age)y"
                }
            }
        }
        
        return dob
    }
    
    var formattedGender: String {
        return PatientMember.formatGender(member_gender)
    }
    
    var formattedAge: String {
        return PatientMember.formatAge(from: member_dob)
    }
    
    var displayRelationship: String {
        let rel = (member_relationship ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if rel.lowercased() == "me" {
            return "Account holder"
        }
        return rel.capitalized
    }
    
    var subtitleText: String {
        var parts: [String] = []
        let rel = displayRelationship
        if !rel.isEmpty { parts.append(rel) }
        
        var genderAge: [String] = []
        let g = formattedGender
        if !g.isEmpty { genderAge.append(g) }
        let a = formattedAge
        if !a.isEmpty { genderAge.append(a) }
        
        if !genderAge.isEmpty {
            parts.append(genderAge.joined(separator: ", "))
        }
        
        return parts.joined(separator: " · ")
    }
}

// MARK: - MembersResponse
struct MembersResponse: Codable {
    let message: String?
    let status: String?
    let data: [PatientMember]?
}

// MARK: - AddMemberResponse
struct AddMemberResponse: Codable {
    let message: String?
    let status: String?
    let member_id: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case status
        case member_id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try? container.decode(String.self, forKey: .message)
        status = try? container.decode(String.self, forKey: .status)
        if let intId = try? container.decode(Int.self, forKey: .member_id) {
            member_id = "\(intId)"
        } else {
            member_id = try? container.decode(String.self, forKey: .member_id)
        }
    }
}
