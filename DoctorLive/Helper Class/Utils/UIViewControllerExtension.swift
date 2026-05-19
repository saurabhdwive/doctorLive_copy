//
//  UIViewControllerExtension.swift
//  Worklopedia
//
//  Created by Jay on 19/01/20.
//  Copyright © 2020 Apponward. All rights reserved.
//

import UIKit
extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
    
    func add(childViewController child: UIViewController, contentView: UIView? = nil) {
        addChild(child)
        let sView = contentView ?? view
        guard let superView = sView else { fatalError("Super view does not exist") }
        child.view.frame = superView.bounds
        superView.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeChildViewController() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func setUnreadMessage(_ count:Int) {
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            if count == 0 {
                tabItem.badgeValue = nil
            } else {
                tabItem.badgeValue = "\(count)"
            }
            
        }
    }
}

extension UINavigationController {
    func resetViewControllersToRoot() {
        guard let topVC = topViewController, viewControllers.count > 1 else {
            return
        }
        
        viewControllers = [topVC]
    }
}
