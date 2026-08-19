// //
// //  LoaderController.swift
// //  AfriPayChat
// //  Created by Ashok kumar on 3/5/21.
// //  Copyright © 2020 Apponward Technologies Pvt Ltd. All rights reserved.
// //

// import Foundation
// import UIKit

// class LoaderController: NSObject {
    
//     static let sharedInstance = LoaderController()
//     private let activityIndicator = UIActivityIndicatorView()
    
//     private func setupLoader() {
//          removeLoader()
//         activityIndicator.hidesWhenStopped = true
//         if #available(iOS 13.0, *) {
//         activityIndicator.style = .large
//     } else {
//     // Fallback on earlier versions
//     }
//         activityIndicator.color = .gray
//     }
    
//     func showLoader(view: UIView) {
//         setupLoader()
//         let holdingView = view
        
//         DispatchQueue.main.async {
//             self.activityIndicator.center = holdingView.center
//             self.activityIndicator.startAnimating()
//             holdingView.addSubview(self.activityIndicator)
//             UIApplication.shared.beginIgnoringInteractionEvents()
//         }
//     }
    
//     func removeLoader() {
//         DispatchQueue.main.async {
//             self.activityIndicator.stopAnimating()
//             self.activityIndicator.removeFromSuperview()
//             UIApplication.shared.endIgnoringInteractionEvents()
//         }
//     }
// }



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
    
    private var containerView = UIView()
    private var progressView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private var loadingLabel = UILabel()
    
    private func setupLoader() {
        removeLoader()
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.color = .white
    }
    
    func showLoader(view: UIView) {
        setupLoader()
        
        DispatchQueue.main.async {
            self.loadingLabel.textAlignment = .center
            self.loadingLabel.textColor = .white
            self.loadingLabel.text = "Loading..."
            self.loadingLabel.font = UIFont.systemFont(ofSize: 14)
            
            self.containerView.frame = view.bounds
            self.containerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3) // 0xffffff, 0.3
            self.containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.progressView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            self.progressView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            self.progressView.backgroundColor = UIColor(red: 0x44/255.0, green: 0x44/255.0, blue: 0x44/255.0, alpha: 0.7) // 0x444444, 0.7
            self.progressView.clipsToBounds = true
            self.progressView.layer.cornerRadius = 10
            self.progressView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
            
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            self.activityIndicator.center = CGPoint(x: self.progressView.bounds.width / 2, y: self.progressView.bounds.height / 2 - 10)
            
            self.loadingLabel.frame = CGRect(x: 0, y: self.activityIndicator.frame.maxY + 5, width: self.progressView.bounds.width, height: 20)
            
            self.progressView.addSubview(self.activityIndicator)
            self.progressView.addSubview(self.loadingLabel)
            self.containerView.addSubview(self.progressView)
            
            view.addSubview(self.containerView)
            view.bringSubviewToFront(self.containerView)
            
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
