//
//  HomeVC+Model.swift
//  DoctorLive
//
//  Created by Kv on 06/09/24.
//

import Foundation
import UIKit

//PENDING
struct PendingBookingData {
    
    var Pending: [PendingBooking]?
    var Accepted: [AcceptedBooking]?
    
    init(Pending: [PendingBooking] = [PendingBooking](), Accepted: [AcceptedBooking] = [AcceptedBooking]()) {
        self.Pending = Pending
        self.Accepted = Accepted
    }
}

struct PendingBooking {
    
    var patientName: String?
    var gender: String?
    var age: String?
    var bookingId: String?
    var Date: String?
    var reasonForCall: String?
    
    init(patientName: String = EMPTY, gender: String = EMPTY, age: String = EMPTY, bookingId: String = EMPTY, Date: String = EMPTY, reasonForCall: String = EMPTY) {
        self.patientName = patientName
        self.gender = gender
        self.age = age
        self.bookingId = bookingId
        self.Date = Date
        self.reasonForCall = reasonForCall
    }
}

struct AcceptedBooking {
    
    var patientName: String?
    var gender: String?
    var age: String?
    var bookingId: String?
    var Date: String?
    var reasonForCall: String?
    
    init(patientName: String = EMPTY, gender: String = EMPTY, age: String = EMPTY, bookingId: String = EMPTY, Date: String = EMPTY, reasonForCall: String = EMPTY) {
        self.patientName = patientName
        self.gender = gender
        self.age = age
        self.bookingId = bookingId
        self.Date = Date
        self.reasonForCall = reasonForCall
    }
}

//UPCOMING
struct UpcomingBooking{
    
    var patientName: String?
    var mobile: String?
    var gender: String?
    var age: String?
    var bookingId: String?
    var date: String?
    var reasonForCall: String?
    var sinchId: String?
    var userId: String?
    var chatCount: String?
    
    init(patientName: String = EMPTY, mobile: String = EMPTY, gender: String = EMPTY, age: String = EMPTY, bookingId: String = EMPTY, date: String = EMPTY, reasonForCall: String = EMPTY, sinchId: String = EMPTY, userId: String = EMPTY, chatCount: String = EMPTY) {
        self.patientName = patientName
        self.mobile = mobile
        self.gender = gender
        self.age = age
        self.bookingId = bookingId
        self.date = date
        self.reasonForCall = reasonForCall
        self.sinchId = sinchId
        self.userId = userId
        self.chatCount = chatCount
    }
}

//PREVIOUS
struct PreviousBookingData {
    
    var FollowUp: [FollowUpBooking]?
    var Previous: [PreviousBooking]?
    
    init(FollowUp: [FollowUpBooking] = [FollowUpBooking](), Previous: [PreviousBooking] = [PreviousBooking]()) {
        self.FollowUp = FollowUp
        self.Previous = Previous
    }
}

struct FollowUpBooking {
    
    var patientName: String?
    var gender: String?
    var age: String?
    var bookingId: String?
    var date: String?
    var reasonForCall: String?
    var price: String?
    var followUpDate: String?
    var sinchKey: String?
    var prescription: String?
    var chatCount: String?
    var mobile: String?
    var chatMode: String?
    var rating: String?
    var bookingStatus: String?
    var userId: String?
    
    init(patientName: String = EMPTY, gender: String = EMPTY, age: String = EMPTY, bookingId: String = EMPTY, date: String = EMPTY, reasonForCall: String = EMPTY, price: String = EMPTY, followUpDate: String = EMPTY, sinchKey: String = EMPTY, prescription: String = EMPTY, chatCount: String = EMPTY, mobile: String = EMPTY, chatMode: String = EMPTY, rating: String = EMPTY, bookingStatus: String = EMPTY, userId: String = EMPTY) {
        self.patientName = patientName
        self.gender = gender
        self.age = age
        self.bookingId = bookingId
        self.date = date
        self.reasonForCall = reasonForCall
        self.price = price
        self.followUpDate = followUpDate
        self.sinchKey = sinchKey
        self.prescription = prescription
        self.chatCount = chatCount
        self.mobile = mobile
        self.chatMode = chatMode
        self.rating = rating
        self.bookingStatus = bookingStatus
        self.userId = userId
    }
}

struct PreviousBooking {
    
    var patientName: String?
    var gender: String?
    var age: String?
    var bookingId: String?
    var date: String?
    var reasonForCall: String?
    var price: String?
    var followUpDate: String?
    var sinchKey: String?
    var prescription: String?
    var chatCount: String?
    var mobile: String?
    var chatMode: String?
    var rating: String?
    var bookingStatus: String?
    var userId: String?
    
    init(patientName: String = EMPTY, gender: String = EMPTY, age: String = EMPTY, bookingId: String = EMPTY, date: String = EMPTY, reasonForCall: String = EMPTY, price: String = EMPTY, followUpDate: String = EMPTY, sinchKey: String = EMPTY, prescription: String = EMPTY, chatCount: String = EMPTY, mobile: String = EMPTY, chatMode: String = EMPTY, rating: String = EMPTY, bookingStatus: String = EMPTY, userId: String = EMPTY) {
        self.patientName = patientName
        self.gender = gender
        self.age = age
        self.bookingId = bookingId
        self.date = date
        self.reasonForCall = reasonForCall
        self.price = price
        self.followUpDate = followUpDate
        self.sinchKey = sinchKey
        self.prescription = prescription
        self.chatCount = chatCount
        self.mobile = mobile
        self.chatMode = chatMode
        self.rating = rating
        self.bookingStatus = bookingStatus
        self.userId = userId
    }
}
