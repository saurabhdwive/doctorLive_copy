//
//  Enum+Extension.swift
//  DoctorLive
//
//  Created by Kv on 06/09/24.
//

import Foundation

enum BookingSegment: String {
    
    case PENDING     =      "Pending"
    case UPCOMING    =      "Upcoming"
    case PREVIOUS    =      "Previous"
    
}

enum PreviousSegment: String {
    
    case FOLLOW_UP   =      "FollowUp"
    case PREVIOUS    =      "Previous"
    
}

enum PendingSegment: String {
    
    case PENDING     =      "Pending"
    case ACCEPTED    =      "Accepted"
}
