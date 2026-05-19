//
//  LoaderController.swift
//  AfriPayChat
//  Created by Ashok kumar on 3/5/21.
//  Copyright © 2020 Apponward Technologies Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

class LoaderController: NSObject {
    
    static let sharedInstance = LoaderController()
    private let activityIndicator = UIActivityIndicatorView()
    
    private func setupLoader() {
         removeLoader()
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
        activityIndicator.style = .large
    } else {
    // Fallback on earlier versions
    }
        activityIndicator.color = .gray
    }
    
    func showLoader(view: UIView) {
        setupLoader()
        let holdingView = view
        
        DispatchQueue.main.async {
            self.activityIndicator.center = holdingView.center
            self.activityIndicator.startAnimating()
            holdingView.addSubview(self.activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
