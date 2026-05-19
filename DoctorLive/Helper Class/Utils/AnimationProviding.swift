//
//  AnimationProviding.swift
//  Delight-iOS
//
//  Created by Sovit Singh on 09/12/20.
//


import UIKit

protocol AnimationProviding {
    func showAnimated()
    func removeAnimated()
}

extension AnimationProviding where Self: UIViewController {
    func showAnimated() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimated() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool)  in
            if finished {
                self.removeChildViewController()
            }
        })
    }
}
