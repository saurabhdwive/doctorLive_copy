//
//  AppLoader.swift
//  Open
//
//  Created by Ram Mani  on 18/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit
class AppLoader{
    
    static func showLoader() {
        SKActivityIndicator.show("", userInteractionStatus: false)
    }
    static func hideLoader() {
        SKActivityIndicator.dismiss()
    }
}
