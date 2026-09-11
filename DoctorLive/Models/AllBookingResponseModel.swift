//
//  AllBookingResponseModel.swift
//  DoctorLive
//
//  Created for the new pastbooking array-based API response.
//

import Foundation

// MARK: - AllBookingResponseModel
// Matches the new API: pastbooking is now an array of PatientBookingGroup
struct AllBookingResponseModel: Codable {
    let pastbooking: [PatientBookingGroup]?
    let status: String?
    let message: String?
    let pagination: BookingPagination?

    private enum CodingKeys: String, CodingKey {
        case pastbooking = "pastbooking"
        case status = "status"
        case message = "message"
        case pagination = "pagination"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pastbooking = try? values.decode([PatientBookingGroup].self, forKey: .pastbooking)
        status = try? values.decode(String.self, forKey: .status)
        message = try? values.decode(String.self, forKey: .message)
        pagination = try? values.decode(BookingPagination.self, forKey: .pagination)
    }
}

// MARK: - PatientBookingGroup
// Represents one patient's card with their list of bookings
struct PatientBookingGroup: Codable {
    let patientId: String?
    let patientName: String?
    let mobile: String?
    let email: String?
    let dob: String?
    let gender: String?
    let totalBookings: Int?
    let sinchKey: String?
    let deviceToken: String?
    var call: [PastCall]?                    // mutable for inner pagination append
    let visit: [PastVisit]?
    let bookingPagination: BookingPagination?

    private enum CodingKeys: String, CodingKey {
        case patientId = "patient_id"
        case patientName = "patient_name"
        case mobile = "mobile"
        case email = "email"
        case dob = "dob"
        case gender = "gender"
        case totalBookings = "total_bookings"
        case sinchKey = "sinch_key"
        case deviceToken = "device_token"
        case call = "call"
        case visit = "visit"
        case bookingPagination = "booking_pagination"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        patientId = try? values.decode(String.self, forKey: .patientId)
        patientName = try? values.decode(String.self, forKey: .patientName)
        mobile = try? values.decode(String.self, forKey: .mobile)
        email = try? values.decode(String.self, forKey: .email)
        dob = try? values.decode(String.self, forKey: .dob)
        gender = try? values.decode(String.self, forKey: .gender)
        totalBookings = try? values.decode(Int.self, forKey: .totalBookings)
        sinchKey = try? values.decode(String.self, forKey: .sinchKey)
        deviceToken = try? values.decode(String.self, forKey: .deviceToken)
        call = try? values.decode([PastCall].self, forKey: .call)
        visit = try? values.decode([PastVisit].self, forKey: .visit)
        bookingPagination = try? values.decode(BookingPagination.self, forKey: .bookingPagination)
    }
}

// MARK: - BookingPagination
struct BookingPagination: Codable {
    let currentPage: Int?
    let totalPages: Int?
    let perPage: Int?
    let hasMore: Bool?
    let totalRecords: Int?

    private enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case perPage = "per_page"
        case hasMore = "has_more"
        case totalRecords = "total_records"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try? values.decode(Int.self, forKey: .currentPage)
        totalPages = try? values.decode(Int.self, forKey: .totalPages)
        perPage = try? values.decode(Int.self, forKey: .perPage)
        hasMore = try? values.decode(Bool.self, forKey: .hasMore)
        totalRecords = try? values.decode(Int.self, forKey: .totalRecords)
    }
}



// MARK: - PastCall -> Booking helper
extension PastCall {
    func toBooking() -> Booking {
        let bookingStatusRaw = self.current_status ?? ""
        let status: BookingStatus
        switch bookingStatusRaw {
            //        case "Pending":            status = .requested
            //        case "Accepted":           status = .confirmed
            //        case "Payment Success":    status = .paymentCompleted
            //        case "Pending Payment":    status = .paymentPending
            //        case "Past Booking":       status = .completed
            //        case "Cancel":             status = .cancelled
            //        case "Reject":             status = .cancelled   // no .rejected case — treated as cancelled
            //        default:                   status = .confirmed
            
        case "REQUESTED": status = .requested
        case "NO_RESPONSE": status = .noResponse
        case "REJECTED": status = .rejected
        case "CANCELLED": status = .cancelled
        case "PAYMENT_PENDING": status = .paymentPending
        case "PAYMENT_EXPIRED": status = .paymentExpired
        case "PAYMENT_COMPLETED": status = .paymentCompleted
        case "WAITING_FOR_CALL": status = .waitingForCall
        case "CALL_STARTED": status = .callStarted
        case "CALL_ENDED": status = .callEnded
        case "CONSULTATION_COMPLETED": status = .consultationCompleted
        case "PRESCRIPTION_SENT": status = .prescriptionSent
        case "FOLLOW_UP_STARTED": status = .followUpStarted
        case "FOLLOW_UP_CLOSED": status = .followUpClosed
        case "CLOSED": status = .closed
        default:                   status = .closed
            
        }
        
        let parsedDate = Booking.parseDate(dateStr: self.scheduleDate, createdOn: self.status_since)
        let formattedTime = self.scheduleTime ?? ""
        
        return Booking(
            id: self.id ?? "",
            bookingId: self.id,
            date: parsedDate,
            time: formattedTime,
            status: status,
            rawDate: self.scheduleDate,
            rawTime: self.scheduleTime
        )
    }
}


enum BookingPhase {
    // case requested
    // case noResponse
    // case rejected
    // case timeProposed
    // case paymentPending
    // case paymentExpired
    // case waitingForCall
    // case inCall
    // case callEnded
    // case followUp
    // case closed
    case requested  
    case noResponse
    case rejected  
    case cancelled 
    case paymentPending  
    case paymentExpired  
    case paymentCompleted  
    case waitingForCall  
    case callStarted  
    case callEnded  
    case consultationCompleted  
    case prescriptionSent  
    case followUpStarted  
    case followUpClosed  
    case closed  
}

enum BookingStatus: String {
//    case requested = "REQUESTED"
//    case confirmed = "CONFIRMED"
//    case paymentPending = "PAYMENT_PENDING"
//    case paymentCompleted = "PAYMENT_COMPLETED"
//    case waitingForCall = "WAITING_FOR_CALL"
//    case inCall = "IN_CALL"
//    case completed = "COMPLETED"
//    case cancelled = "CANCELLED"
    case requested = "REQUESTED"
    case noResponse = "NO_RESPONSE"
    case rejected = "REJECTED"
    case cancelled = "CANCELLED"
    case paymentPending = "PAYMENT_PENDING"
    case paymentExpired = "PAYMENT_EXPIRED"
    case paymentCompleted = "PAYMENT_COMPLETED"
    case waitingForCall = "WAITING_FOR_CALL"
    case callStarted = "CALL_STARTED"
    case callEnded = "CALL_ENDED"
    case consultationCompleted = "CONSULTATION_COMPLETED"
    case prescriptionSent = "PRESCRIPTION_SENT"
    case followUpStarted = "FOLLOW_UP_STARTED"
    case followUpClosed = "FOLLOW_UP_CLOSED"
    case closed = "CLOSED"
    
    static func from(type: String?, statusId: String?) -> BookingStatus {
        let normalized = (type ?? "").uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        //  switch normalized {
        //  case "REQUESTED", "0":
        //      return .requested
        //  case "CONFIRMED", "2", "TIME_PROPOSED":
        //      return .confirmed
        //  case "PAYMENT_PENDING", "3", "PAYMENT":
        //      return .paymentPending
        //  case "PAYMENT_COMPLETED", "7", "PAYMENT_SUCCESS":
        //      return .paymentCompleted
        //  case "WAITING_FOR_CALL", "WAITING", "6":
        //      return .waitingForCall
        //  case "IN_CALL", "LIVE":
        //      return .inCall
        //  case "COMPLETED", "CALL_ENDED", "ENDED", "5":
        //      return .completed
        //  case "CANCELLED", "CANCEL", "REJECTED", "REJECT", "4":
        //      return .cancelled
        //  default:
        //      if let sid = statusId {
        //          switch sid {
        //          case "1": return .requested
        //          case "4": return .cancelled
        //          case "3": return .paymentPending
        //          case "7": return .paymentCompleted
        //          default: break
        //          }
        //      }
        //      return .requested
        //  }

        switch normalized {
        case "REQUESTED":
            return .requested
        case "NO_RESPONSE":
            return .noResponse
        case "REJECTED":
            return .rejected
        case "CANCELLED":
            return .cancelled
        case "PAYMENT_PENDING":
            return .paymentPending
        case "PAYMENT_EXPIRED":
            return .paymentExpired
        case "PAYMENT_COMPLETED":
            return .paymentCompleted
        case "WAITING_FOR_CALL":
            return .waitingForCall
        case "CALL_STARTED":
            return .callStarted
        case "CALL_ENDED":
            return .callEnded
        case "CONSULTATION_COMPLETED":
            return .consultationCompleted
        case "PRESCRIPTION_SENT":
            return .prescriptionSent
        case "FOLLOW_UP_STARTED":
            return .followUpStarted
        case "FOLLOW_UP_CLOSED":
            return .followUpClosed
        case "CLOSED":
            return .closed
        default:
            return .requested
        }

        
    }
}

struct Booking {
    let id: String
    let bookingId: String?
    let date: Date
    let time: String
    let status: BookingStatus
    let rawDate: String?
    let rawTime: String?

    static func parseDate(dateStr: String?, createdOn: String?) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let createdOn = createdOn, !createdOn.isEmpty {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let d = formatter.date(from: createdOn) {
                return d
            }
            
            formatter.dateFormat = "dd-MM-yyyy hh:mm a"
            if let d = formatter.date(from: createdOn) {
                return d
            }
        }
        
        if let dateStr = dateStr, !dateStr.isEmpty {
            formatter.dateFormat = "dd-MMM-yyyy"
            if let d = formatter.date(from: dateStr) {
                return d
            }
            formatter.dateFormat = "yyyy-MM-dd"
            if let d = formatter.date(from: dateStr) {
                return d
            }
            formatter.dateFormat = "dd-MM-yyyy"
            if let d = formatter.date(from: dateStr) {
                return d
            }
        }
        
        return Date()
    }
    // static func parseDate(dateStr: String?, createdOn: String?) -> Date {
    //     let formatter = DateFormatter()
    //     formatter.locale = Locale(identifier: "en_US_POSIX")

    //     if let createdOn = createdOn, !createdOn.isEmpty {

    //         // Local/server date without timezone
    //         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //         formatter.timeZone = TimeZone.current

    //         if let date = formatter.date(from: createdOn) {
    //             return date
    //         }

    //         formatter.dateFormat = "dd-MM-yyyy hh:mm a"
    //         formatter.timeZone = TimeZone.current

    //         if let date = formatter.date(from: createdOn) {
    //             return date
    //         }

    //         // ISO 8601 UTC date
    //         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //         formatter.timeZone = TimeZone(secondsFromGMT: 0)

    //         if let date = formatter.date(from: createdOn) {
    //             return date
    //         }
    //     }

    //     if let dateStr = dateStr, !dateStr.isEmpty {

    //         formatter.dateFormat = "dd-MMM-yyyy"
    //         formatter.timeZone = TimeZone.current

    //         if let date = formatter.date(from: dateStr) {
    //             return date
    //         }

    //         formatter.dateFormat = "yyyy-MM-dd"
    //         formatter.timeZone = TimeZone.current

    //         if let date = formatter.date(from: dateStr) {
    //             return date
    //         }

    //         formatter.dateFormat = "dd-MM-yyyy"
    //         formatter.timeZone = TimeZone.current

    //         if let date = formatter.date(from: dateStr) {
    //             return date
    //         }

    //         // ISO 8601 UTC
    //         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //         formatter.timeZone = TimeZone(secondsFromGMT: 0)

    //         if let date = formatter.date(from: dateStr) {
    //             return date
    //         }
    //     }

    //     return Date()
    // }
    
    static func formatTime(timeStr: String?) -> String {
        guard let timeStr = timeStr, !timeStr.isEmpty else { return "" }
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm:ss"
        if let d = inFormatter.date(from: timeStr) {
            let outFormatter = DateFormatter()
            outFormatter.locale = Locale(identifier: "en_US_POSIX")
            outFormatter.dateFormat = "hh:mm a"
            return outFormatter.string(from: d)
        }
        return timeStr
    }
}
