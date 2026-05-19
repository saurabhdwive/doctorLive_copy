//
//  Date+Additions.swift
//  Helper Class
//
//  Created by Krishanvir on 29/03/22.
//

import Foundation

let CURRENT_CALENDAR = Calendar.current
let EMPTY_SPACE = " "

// MARK: - Date formatters
struct DateFormat {
    static let shortDateFormatWithSpace     =   "dd MMM yyyy"
    static let dateMonthyear                =   "dd MMMM yyyy"
    static let dateMonthyear1                =   "dd-MMM-yyyy"
    static let hhmm                         =   "hh:mm"
    static let a                            =   "a"
    static let timeFormat                   =   "hh:mm:ss"
    static let exactTimeFormat              =   "HH:mm"
    static let exactTimeFormat1             =   "hh:mm a"
    static let dayOfMonth                   =   "dd MMM"
    static let dayOfMonth1                  =   "d MMM"
    static let dayOfMonth2                  =   "MMM d    HH:mm"
    static let monthofYear                  =   "MMM YYYY"
    static let monthofYear1                 =   "MMM yyyy"
    static let apiDate                      =   "yyyy-MM-dd"
    static let apiSendDateType              =   "yyyyMMdd"
    static let fbApiDate                    =   "MM/dd/yyyy"
    static let fbApiDateSlash               =   "MM/dd/yyyy"
    static let yyyyMMddFormat               =   "yyyy/MM/dd"
    static let sleepFormat                  =   "dd-MMM-yyyy HH:mm a"
    static let onlyDay1                     =   "d"
    static let onlyDay                      =   "dd"
    static let onlyHour                     =   "HH"
    static let onlyHour1                    =   "H"
    static let onlyWeek                     =   "EEE"
    static let chatFormat                   =   "yyyy-MM-dd HH:mm"
    static let onlyMonth                    =   "MM"
    static let onlyMonth1                   =   "mm"
    static let onlyMonth2                   =   "MMM"
    static let fullMonth                    =   "LLLL"
    static let onlyYear                     =   "YYYY"
    static let onlyYear1                    =   "yyyy"
    static let isoFormat                    =   "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let iso8601Format                =   "yyyy-MM-dd'T'HH:mm:ss'Z'"
    static let dateWithDay                  =   "EEE, MMM dd, yyyy"
    static let dateWithDay1                 =   "EEE dd MMM, YYYY "
    static let standardFormat               =   "yyyy-MM-dd'T'HH:mm:ss.000Z"
    static let ddMMYYYY                     =   "dd/MM/yyyy"
    static let ddMMYYYY1                    =   "dd-MM-yyyy"
    static let dayMotnthDate                =   "EEE, MMM dd"
    static let monthDayYearTime             =   "MMM d yyyy , h a"
    static let monthDayYear                 =   "MMM d, yyyy "
    static let dayMonthDayYear              =   "EEEE, MMM d, yyyy"
    static let stravaDateFormate            =   "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static let monthDate                    =   "MMM dd"
    static let transactionFormate           =   "MMM dd,yyyy hh:mm a"
    static let normalDate                   =   "yyyy-MM-dd HH:mm:ss Z"
    static let ddMMMTime                    =   "dd MMM, hh:mm a"
    static let ddDASHYYYTime                =   "dd-MM-yyyy hh:mm a"
  
}

extension Date {
    
    func getCurrentTime() -> String {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        var hour = dateTimeComponents.hour ?? 0
        let minute = dateTimeComponents.minute ?? 0
            
            // Convert hour to 12-hour format and determine AM/PM
            let amPM: String
            if hour >= 12 {
                amPM = "PM"
                if hour > 12 {
                    hour -= 12
                }
            } else {
                amPM = "AM"
                if hour == 0 {
                    hour = 12
                }
            }
            
            // Format the time as "hour:minute AM/PM"
            return "\(hour):\(String(format: "%02d", minute)) \(amPM)"
//        return "\(dateTimeComponents.hour ?? INTZERO):\(dateTimeComponents.minute ?? INTZERO)"
    }
    
    func getParseBetweenTimeStatus(firstData: String, secondDate: String) -> Bool {
        let currentDate = getCurrentTime()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        if let date1 = parseTime(firstData),
           let date2 = parseTime(secondDate),
           let current = parseTime(currentDate) {
            let calendar = Calendar.current
            let isBetween = current >= date1 && current <= date2
            print(isBetween)
            return isBetween
        }
        return true
    }
    
    func parseTime(_ time: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.date(from: time)
    }
    
    // MARK: - Get string data
    func getStringDate(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    
    public func dateStringWith(strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = CURRENT_CALENDAR.timeZone
        dateFormatter.locale = CURRENT_CALENDAR.locale
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
    
    func getStringDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormat.ddMMYYYY
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    static func convertFBDateString(dateString: String) -> Date {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = DateFormat.fbApiDate
        let convertedDate = dateFormatter.date(from: dateString)
        return convertedDate!
    }
    
//    static func convertStringDateToStringDate(strFormat: String, dateString: String) -> String {
//        let dateFormatter = Foundation.DateFormatter()
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = strFormat
//        let convertedDate = dateFormatter.string(from: dateString)
//        return String(convertedDate)
//    }
    
    static func convertStringDateToStringDate(inputFormat: String, outputFormat: String, dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = inputFormat
        
        // Convert the input date string to a Date object
        guard let date = dateFormatter.date(from: dateString) else {
            // Return an empty string or handle the error as needed
            return "Invalid date"
        }
        
        // Set the date format to the output format
        dateFormatter.dateFormat = outputFormat
        
        // Convert the Date object to the output date string
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
    
    func userAge() -> Int {
        let units:NSCalendar.Unit = [.year]
        let calendar = NSCalendar.current as NSCalendar
        calendar.timeZone = NSTimeZone.default
        calendar.locale = NSLocale.current
        let components = calendar.components(units, from: self, to: Date(), options: NSCalendar.Options.wrapComponents)
        let years = components.year
        return years!
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    public var calendar: Calendar {
        return CURRENT_CALENDAR
    }
    
    
    static func -(lhs: Date, rhs: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
    }
    
    /// Era.
    public var era: Int {
        return calendar.component(.era, from: self)
    }
    
    /// Year.
    
    func localDate() -> Date {
        if let timeZone = TimeZone(abbreviation: "UTC") {
            let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
            return Date(timeInterval: seconds, since: self)
        }
        return self
        //return Formatter.preciseLocalTime.string(for: self) ?? ""
    }
    // or GMT time
    func utcDate() -> Date {
        
        if let timeZone = TimeZone(abbreviation: "UTC") {
            let seconds = -TimeInterval(timeZone.secondsFromGMT(for: self))
            return Date(timeInterval: seconds, since: self)
        }
        return self
    }
    
    static func timeSince(_ dateStr: String, numericDates: Bool = false) -> String {
        if let date = DateFormatter.date(fromISO8601String: dateStr)?.toLocalTime() {
            let calendar = NSCalendar.current
            let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
            let now = Date().toLocalTime()
            let earliest = now < date ? now : date
            let latest = (earliest == now) ? date : now
            let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
            if (components.year! >= 2) {
                return "\(components.year!) yrs ago"
            } else if (components.year! >= 1) {
                if (numericDates) {
                    return "1 yr ago"
                } else {
                    return "1 yr ago"
                }
            } else if (components.month! >= 2) {
                return "\(components.month!) m ago"
            } else if (components.month! >= 1) {
                if (numericDates) {
                    return "1 m ago"
                } else {
                    return "1 m ago"
                }
            } else if (components.weekOfYear! >= 2) {
                return "\(components.weekOfYear!) w ago"
            } else if (components.weekOfYear! >= 1) {
                if (numericDates) {
                    return "1 w ago"
                } else {
                    return "1 w ago"
                }
            } else if (components.day! >= 2) {
                return "\(components.day!) d ago"
            } else if (components.day! >= 1) {
                if (numericDates) {
                    return "1 d ago"
                } else {
                    return "1 d ago"
                }
            } else if (components.hour! >= 2) {
                return "\(components.hour!) hrs ago"
            } else if (components.hour! >= 1) {
                if (numericDates) {
                    return "1 hr ago"
                } else {
                    return "1 hr ago"
                }
            } else if (components.minute! >= 2) {
                return "\(components.minute!) mins ago"
            } else if (components.minute! >= 1) {
                if (numericDates) {
                    return "1 min ago"
                } else {
                    return "1 min ago"
                }
            } else if (components.second! >= 3) {
                return "\(components.second!) secs ago"
            } else {
                return "Just now"
            }
        }
        return ""
    }
}

// MARK: - ISO data formatter
extension DateFormatter {
    static let iso8601DateFormatter: DateFormatter = {
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        let iso8601DateFormatter = DateFormatter()
        iso8601DateFormatter.locale = enUSPOSIXLocale
        iso8601DateFormatter.dateFormat = DateFormat.isoFormat
        iso8601DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return iso8601DateFormatter
    }()
    
    static let iso8601WithoutMillisecondsDateFormatter: DateFormatter = {
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        let iso8601DateFormatter = DateFormatter()
        iso8601DateFormatter.locale = enUSPOSIXLocale
        iso8601DateFormatter.dateFormat = DateFormat.iso8601Format
        iso8601DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return iso8601DateFormatter
    }()
    
    static func date(fromISO8601String string: String) -> Date? {
        if let dateWithMilliseconds = iso8601DateFormatter.date(from: string) {
            return dateWithMilliseconds
        }
        if let dateWithoutMilliseconds = iso8601WithoutMillisecondsDateFormatter.date(from: string) {
            return dateWithoutMilliseconds
        }
        return nil
    }
}

extension Date {
    func getDateTimeInMilliseconds() -> Int64 {
        let milliSeconds = self.timeIntervalSince1970 * 1000
        return Int64(milliSeconds.rounded())
    }
    
    func millisecondsToTime(_ timeInMillis:Int64?, _ format: String = "HH:mm a") -> String? {
        var formattedDate:String?
        var date : Date = Date()
        
        //Get formatted date
        if let time = timeInMillis {
            let timeInterval: TimeInterval = Double(time)/1000
            date = Date(timeIntervalSince1970: timeInterval)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = format
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
    }
    
    static func getStartTimeFromDate(_ date: Date, minute: Int = 0) -> Date {
        let comp: DateComponents = CURRENT_CALENDAR.dateComponents([.year, .month, .day], from: date)
        return date.makeDateUsingComponent(day: comp.day!, hour: 0, minute: minute)
    }
    
    static func getDateUsingCurrentTime(_ date: Date) -> Date {
        let comp: DateComponents = CURRENT_CALENDAR.dateComponents([.year, .month, .day], from: date)
        let comp1: DateComponents = CURRENT_CALENDAR.dateComponents([.hour, .minute], from: Date())
        return date.makeDateUsingComponent(day: comp.day!, hour: comp1.hour!, minute: comp1.minute!)
    }
    
    static func getEndTimeFromDate(_ date: Date) -> Date {
        let comp: DateComponents = CURRENT_CALENDAR.dateComponents([.year, .month, .day], from: date)
        return date.makeDateUsingComponent(day: comp.day!, hour: 24, minute: 0)
    }
    
    static func getDateFromTimeStamp(_ timeStamp: Double,format:String ) -> String {
        let timeStampp = timeStamp / 1000
        let date = Date(timeIntervalSince1970: timeStampp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        return  dateFormatter.string(from: date)
    }
    
    func makeDateUsingComponent(day: Int, hour: Int, minute: Int, seconds: Int = 0) -> Date {
        let comp: DateComponents = CURRENT_CALENDAR.dateComponents([.year, .month, .day], from: self)
        var dateComponent = DateComponents()
        dateComponent.year = comp.year
        dateComponent.month = comp.month
        dateComponent.day = day
        dateComponent.timeZone = TimeZone.current
        dateComponent.hour = hour
        dateComponent.minute = minute
        dateComponent.second = seconds
        if let currentDate = CURRENT_CALENDAR.date(from: dateComponent) {
            return currentDate
        } else {
            return Date()
        }
    }
    
    func dateWithComponent(_ hour: Int = 0, _ minute: Int = 0, _ seconds: Int = 0) -> Date {
        let comp: DateComponents = CURRENT_CALENDAR.dateComponents([.year, .month, .day], from: self)
        var dateComponent = DateComponents()
        dateComponent.year = comp.year
        dateComponent.month = comp.month
        dateComponent.day = comp.day
        dateComponent.timeZone = TimeZone.current
        dateComponent.hour = hour
        dateComponent.minute = minute
        dateComponent.second = seconds
        if let currentDate = CURRENT_CALENDAR.date(from: dateComponent) {
            return currentDate
        } else {
            return Date()
        }
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return CURRENT_CALENDAR.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        //        var result: String = ""
        //        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        //        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        //        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        //        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
//                if days(from: date)    > 0 { result = result + " " + "\(days(from: date)) D" }
        //        if hours(from: date)   > 0 { result = result + " " + "\(hours(from: date)) H" }
        //        if minutes(from: date) > 0 { result = result + " " + "\(minutes(from: date)) M" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        return ""
    }
    
    static func getDate(dateStr:String,format:String = DateFormat.standardFormat ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateStr)
    }
    
    static func getDateExcatTimeZoen(dateStr:String ,format:String = DateFormat.isoFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let currentDate = dateFormatter.date(from: dateStr)
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let currentTimeZoneDate = currentDate?.timeIntervalSince1970
        if let currentTimeZoneDatee = currentTimeZoneDate {
            let timezoneEpochOffset = (currentTimeZoneDatee + Double(timezoneOffset))
            let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
            return timeZoneOffsetDate
        }
        return Date()
    }
    
    static func getDateStringWithDatee(_ format:String, date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone =  TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    
    func checkDateIsLessThan(datee:Date) -> String {
        let now = Date()
        let order = Calendar.current.compare(datee, to: now, toGranularity: .day)
        switch order {
        case .orderedDescending:
            return "DESCENDING"
        case .orderedAscending:
            return "ASCENDING"
        case .orderedSame:
            return "SAME"
        }
    }
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
    
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    //    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
    //        return self.compare(with: date, only: component) == 0
    //    }
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
}

extension String{
    
    var integer: Int {
        return Int(self) ?? 0
    }
    
    var secondFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        let seconds = components[2].integer
        return Int((hours * 60 * 60) + (minutes * 60) + seconds)
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }
    
    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
    
    
    
    var day: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 1
    }
    
    var isToday: Bool {
        let gregorian = Calendar(identifier: .gregorian)
        let thisDate = gregorian.dateComponents([.day, .month, .year], from: self)
        let currentDate = gregorian.dateComponents([.day, .month, .year], from: Date())
        return thisDate == currentDate
    }
    
    var previousDay: Date {
        var components = DateComponents()
        components.day = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var nextDay: Date {
        var components = DateComponents()
        components.day = 1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return sunday!
    }
    
    var startOfNextWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .weekOfMonth, value: 1, to: sunday!)!
    }
    
    var startOfPreviousWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .weekOfMonth, value: -1, to: sunday!)!
    }
    
    var weekDates: [Date] {
        var dates: [Date] = []
        for i in 0..<7 {
            dates.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return dates
    }
    
    var dayOfTheWeek: Int {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        // day number starts from 1 but array count from 0
        return dayNumber - 1
    }
    
    var iso8601: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter.string(from: self)
    }
    
    func string(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

extension Double {
    func getDateStringFromUnixTime(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}


extension Date{
    
    static func getAgeFromString(datePass: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // above string formatte
        //        dateFormatter.dateFormat = "dd/MM/yyyy" // above string formatte
        let date = dateFormatter.date(from: datePass) //convert string date
        let age = Calendar.current.dateComponents([.year], from: Date(), to: date!).year // convert date to age
        return age ?? 0
    }
    
    static func getAgeFromString1(datePass: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z" // above string formatte
        //        dateFormatter.dateFormat = "dd/MM/yyyy" // above string formatte
        let date = dateFormatter.date(from: datePass) //convert string date
        let age = Calendar.current.dateComponents([.year], from: Date(), to: date!).year // convert date to age
        if age == 0 {
            let agge = convertYearToMonth(datePass1: datePass)
            if agge == 0{
                let aggge = convertMonthToDays(datePass2: datePass)
                return String(aggge) + EMPTY_SPACE  +  "day"
            }else{
                return String(agge) + EMPTY_SPACE + "month"
            }
        }else{
            return String(age ?? 0) + EMPTY_SPACE + "year"
        }
    }
    
   static func convertYearToMonth(datePass1: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z" // above string formatte
//        dateFormatter.dateFormat = "dd/MM/yyyy" // above string formatte
        let date = dateFormatter.date(from: datePass1) //convert string date
       let age = Calendar.current.dateComponents([.month], from: Date(), to: date!).month // convert date to age
        print(age ?? 0)
        return age ?? 0
    }
    
    static func convertMonthToDays(datePass2: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z" // above string formatte
//        dateFormatter.dateFormat = "dd/MM/yyyy" // above string formatte
        let date = dateFormatter.date(from: datePass2) //convert string date
        let age = Calendar.current.dateComponents([.day], from: Date(), to: date!).day // convert date to age
        print(age ?? 0)
        return age ?? 0
    }
    
    static func timesinceDate(_ dateStr: String) -> Int {
        if let date = DateFormatter.date(fromISO8601String: dateStr)?.toLocalTime() {
            let calendar = NSCalendar.current
            let unitFlags: Set<Calendar.Component> = [.second]
            let now = Date().toLocalTime()
            let earliest = now < date ? now : date
            let latest = (earliest == now) ? date : now
            let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
            return components.second ?? INTZERO
        }else{
            return 0
        }
    }

    static func convertSecondsToMinutes(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02dm %02ds", minutes, remainingSeconds)
    }
    
    static func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}


//ADD 5:30 hr in date 

//let dateFormatter = DateFormatter()
//dateFormatter.dateFormat = DateFormat.isoFormat
//if let date = dateFormatter.date(from: noti?.createdAt ?? EMPTY) {
//    var calendar = Calendar.current
//    calendar.timeZone = TimeZone(abbreviation: "UTC")! // Ensure the correct time zone
//    // Define the time components to add
//    var dateComponents = DateComponents()
//    dateComponents.hour = 5
//    dateComponents.minute = 30
//    if let newDate = calendar.date(byAdding: dateComponents, to: date) {
//        let newDateString = dateFormatter.string(from: newDate)
//        print(newDateString)
//        let datee = Date.getDateStringWithDatee(DateFormat.ddMMYYYY1, date: Date.getDate(dateStr: newDateString, format: DateFormat.isoFormat) ?? Date())
//        let time = Date.getDateStringWithDatee(DateFormat.exactTimeFormat1, date: Date.getDate(dateStr: newDateString, format: DateFormat.isoFormat) ?? Date())
//        cell.dateLbl.text = "\(datee), \(time)"
//    } else {
//        print("Error adding time components.")
//    }
