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
    let chatCount: Int?
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
        case chatCount = "chatcount"
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
        chatCount = try? values.decode(Int.self, forKey: .chatCount)
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
        case "SUGGESTED_TIME_PENDING": status = .suggestedTimePending
        case "SUGGESTED_TIME_ACCEPTED": status = .suggestedTimeAccepted
        case "CALL_UNANSWERED": status = .callUnanswered
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
            rawTime: self.scheduleTime,
            doctorSpeciality: nil,
            memberDob: self.memberDob,
            memberGender: self.memberGender,
            bookingNumber: self.booking_number,
            amount: self.amount
        )
    }
}


enum BookingPhase {
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
    case suggestedTimePending
    case suggestedTimeAccepted
    case callUnanswered
}

enum BookingStatus: String {
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
    case suggestedTimePending = "SUGGESTED_TIME_PENDING"
    case suggestedTimeAccepted = "SUGGESTED_TIME_ACCEPTED"
    case callUnanswered = "CALL_UNANSWERED"
    
    static func from(type: String?, statusId: String?) -> BookingStatus {
        let normalized = (type ?? "").uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
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
        case "SUGGESTED_TIME_PENDING":
            return .suggestedTimePending
        case "SUGGESTED_TIME_ACCEPTED":
            return .suggestedTimeAccepted
        case "CALL_UNANSWERED":
            return .callUnanswered
        default:
            return .closed
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
    let doctorSpeciality: String?
    let memberDob: String?
    let memberGender: String?
    let bookingNumber: String?
    let amount: String?
    

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
        
        return Date(timeIntervalSince1970: 0)
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
    
    static func formattedDate1(_ date: Date) -> String {
        let calendar = Calendar.current

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        if calendar.isDateInToday(date) {
            formatter.dateFormat = "'Today,' hh:mm a"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "'Yesterday,' hh:mm a"
        } else {
            formatter.dateFormat = "MMM d, yyyy"
        }

        return formatter.string(from: date)
    }
//    static func formattedDate2(_ dateString: String) -> String {
//        let inputFormatter = DateFormatter()
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
//        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        guard let date = inputFormatter.date(from: dateString) else {
//            return dateString
//        }
//
//        let calendar = Calendar.current
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//
//        if calendar.isDateInToday(date) {
//            formatter.dateFormat = "'Today,' hh:mm a"
//        } else if calendar.isDateInYesterday(date) {
//            formatter.dateFormat = "'Yesterday,' hh:mm a"
//        } else {
//            formatter.dateFormat = "MMM d, yyyy"
//        }
//
//        return formatter.string(from: date)
//    }
    static func formattedDate2(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }

        let calendar = Calendar.current

        // Time
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "hh:mm a"

        let time = timeFormatter.string(from: date)

        let today = calendar.startOfDay(for: Date())
        let givenDate = calendar.startOfDay(for: date)

        guard let daysAgo = calendar.dateComponents(
            [.day],
            from: givenDate,
            to: today
        ).day else {
            return dateString
        }

        // Today
        if daysAgo == 0 {
            return "Today, \(time)"
        }

        // Yesterday
        if daysAgo == 1 {
            return "Yesterday, \(time)"
        }

        // 2 - 6 days ago
        if daysAgo < 7 {
            return "\(daysAgo) days ago, \(time)"
        }

        // Weeks
        if daysAgo < 30 {
            let weeksAgo = daysAgo / 7

            if weeksAgo == 1 {
                return "1 week ago, \(time)"
            } else {
                return "\(weeksAgo) weeks ago, \(time)"
            }
        }

        // Months
        let components = calendar.dateComponents(
            [.month],
            from: givenDate,
            to: today
        )

        let monthsAgo = components.month ?? 0

        if monthsAgo < 12 {
            if monthsAgo <= 1 {
                return "1 month ago, \(time)"
            } else {
                return "\(monthsAgo) months ago, \(time)"
            }
        }

        // Older than 12 months
        return "Long time ago"
    }
    
    static func formattedDateeee(
        _ date: Date
    ) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, yyyy"

        return formatter.string(
            from: date
        )
    }
    static func formattedDate11(
        _ date: Date
    ) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, yyyy"

        return formatter.string(
            from: date
        )
    }
}
import SwiftyJSON
import Alamofire

class BookingTimerManager {
    static let shared = BookingTimerManager()
    
    private var timers: [String: Double] = [:]
    private var reminderTimers: [String: Double] = [:]
    
    private init() {
        // Default values in seconds (if API fails or before it loads)
        timers["REQUESTED"] = 10 * 60
        timers["PAYMENT_PENDING"] = 30 * 60
        timers["PAYMENT_COMPLETED"] = 10 * 60
        timers["CONSULTATION_COMPLETED"] = 10 * 60
        timers["PRESCRIPTION_SENT"] = 120 * 60
    }
    
    func fetchTimers() {
        guard let url = URL(string: Domain.baseUrl() + "user/booking_status_timer") else { return }
        
        print("DEBUG: Requesting timers from URL - \(url)")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("DEBUG: Fetch timers error - \(error)")
                return
            }
            guard let data = data else {
                print("DEBUG: Fetch timers no data received")
                return
            }
            
            if let responseStr = String(data: data, encoding: .utf8) {
                print("DEBUG: Fetch timers response - \(responseStr)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   json["status"] as? String == "SUCCESS",
                   let timersArray = json["booking_timer"] as? [[String: Any]] {
                    
                    for timerData in timersArray {
                        if let status = timerData["status"] as? String {
                            if let timeStr = timerData["time"] as? String, let timeValue = Double(timeStr) {
                                self?.timers[status] = timeValue * 60
                            }
                            if let reminderStr = timerData["reminder_time"] as? String, let reminderValue = Double(reminderStr) {
                                self?.reminderTimers[status] = reminderValue * 60
                            }
                        }
                    }
                }
            } catch {
                print("Error parsing booking timers: \(error)")
            }
        }.resume()
    }
    
    func getTimer(for status: String, defaultMinutes: Double = 10) -> TimeInterval {
        if let seconds = timers[status] {
            return seconds
        }
        return defaultMinutes * 60
    }
    
    func getTimer(for status: BookingStatus, defaultMinutes: Double = 10) -> TimeInterval {
        return getTimer(for: status.rawValue, defaultMinutes: defaultMinutes)
    }
}
