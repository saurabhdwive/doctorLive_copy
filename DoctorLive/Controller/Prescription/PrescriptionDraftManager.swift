//
//  PrescriptionDraftManager.swift
//  DoctorLive
//
//  Created for persisting and managing prescription drafts during app sessions.
//

import Foundation
import UIKit

// MARK: - Draft Medicine
struct DraftMedicine: Codable {
    var id: String?
    var name: String
    var dosage: String
    var frequencyFirst: String
    var duration: String
    var meals: String
    var strength: String?
}

// MARK: - Prescription Draft Model
struct PrescriptionDraft: Codable {
    var bookingId: String
    var patientName: String
    var patientGender: String?
    var patientDobOrAge: String?
    var patientRelationship: String?
    var patientDate: String?
    var patientSubtitle: String
    var savedAtTime: String // e.g. "06:33"
    var savedTimestamp: Date
    
    // Core fields
    var chiefComplain: String?
    var pastHistory: String?
    var provisionalDiagnosis: String?
    var generalAdvice: String?
    var general: String? // "1" or "0"
    var temperature: String?
    var systolicBp: String?
    var diastolicBp: String?
    var pulse: String?
    var bloodSugar1: String?
    var bloodSugar2: String?
    var followUpDays: String?
    var investigations: String?
    var medicines: [DraftMedicine]
    
    // Switch states
    var generalExamState: Bool
    var followUpState: Bool
    var medicineSwitch: Bool
    var investigationToggleState: Bool
    
    // Member / User IDs
    var memberId: String?
    var patientUserId: String?
    
    /// Returns true if at least one meaningful field has non-empty text or item
    var hasAnyContent: Bool {
        let hasChief = !(chiefComplain?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasDiag = !(provisionalDiagnosis?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasAdvice = !(generalAdvice?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasPast = !(pastHistory?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasMeds = !medicines.isEmpty
        let hasInvs = !(investigations?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasFollow = !(followUpDays?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasTemp = !(temperature?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasSys = !(systolicBp?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasPulse = !(pulse?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasSugar = !(bloodSugar1?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        
        return hasChief || hasDiag || hasAdvice || hasPast || hasMeds || hasInvs || hasFollow || hasTemp || hasSys || hasPulse || hasSugar
    }
    
    var investigationList: [String] {
        return (investigations ?? "")
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}

// MARK: - Draft Manager
class PrescriptionDraftManager {
    static let shared = PrescriptionDraftManager()
    
    private let userDefaultsKeyPrefix = "prescription_draft_v2_"
    private let draftsIndexKey = "prescription_drafts_index_v2"
    
    private init() {}
    
    func saveDraft(_ draft: PrescriptionDraft) {
        let bId = draft.bookingId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !bId.isEmpty else { return }
        
        // If draft has no content, delete it
        guard draft.hasAnyContent else {
            deleteDraft(for: bId)
            return
        }
        
        let key = userDefaultsKeyPrefix + bId
        if let encoded = try? JSONEncoder().encode(draft) {
            UserDefaults.standard.set(encoded, forKey: key)
            addToIndex(bookingId: bId)
            print("💾 [PrescriptionDraftManager] Draft saved for booking: \(bId)")
        }
    }
    
    func getDraft(for bookingId: String) -> PrescriptionDraft? {
        let bId = bookingId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !bId.isEmpty else { return nil }
        let key = userDefaultsKeyPrefix + bId
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(PrescriptionDraft.self, from: data)
    }
    
    func hasDraft(for bookingId: String) -> Bool {
        return getDraft(for: bookingId) != nil
    }
    
    func deleteDraft(for bookingId: String) {
        let bId = bookingId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !bId.isEmpty else { return }
        let key = userDefaultsKeyPrefix + bId
        UserDefaults.standard.removeObject(forKey: key)
        removeFromIndex(bookingId: bId)
        print("🗑️ [PrescriptionDraftManager] Draft removed for booking: \(bId)")
    }
    
    private func addToIndex(bookingId: String) {
        var index = UserDefaults.standard.stringArray(forKey: draftsIndexKey) ?? []
        if !index.contains(bookingId) {
            index.append(bookingId)
            UserDefaults.standard.set(index, forKey: draftsIndexKey)
        }
    }
    
    private func removeFromIndex(bookingId: String) {
        var index = UserDefaults.standard.stringArray(forKey: draftsIndexKey) ?? []
        index.removeAll { $0 == bookingId }
        UserDefaults.standard.set(index, forKey: draftsIndexKey)
    }
}
