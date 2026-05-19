//
//  CommonResponse.swift
//  Healthcare
//
//  Created by mobulous on 19/05/21.
//

import Foundation
struct CommonResponse: Decodable {
    let status: Int?
    let statusMessage: String?
    let tokenStatus: Bool?
    let msg: String?
    let app_timer: Int?
    let timer_status: String?
    let expireTimestamp : String?
    let isSubscribed : Int?
    let type : String?
}
