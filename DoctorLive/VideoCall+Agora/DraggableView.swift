//
//  DraggableView.swift
//  Pre-Edits
//
//  Created by Richard Stockdale on 03/06/2016.
//  Copyright © 2016 Junction Seven. All rights reserved.
//

import Foundation
import UIKit

class DraggableView: UIView {
    
    let panGesture = UIPanGestureRecognizer()
    let pinchGesture = UIPinchGestureRecognizer()
    
    var firstX: CGFloat? // For panning
    var firstY: CGFloat? // For panning
    var lastScale: CGFloat? // For pinching
    
    override func awakeFromNib() {
        setUpGestureRecognisers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGestureRecognisers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpGestureRecognisers()
    }
    
    private func setUpGestureRecognisers () {
        panGesture.addTarget(self, action: #selector(DraggableView.panGestureChanged))
        pinchGesture.addTarget(self, action: #selector(DraggableView.pinchGestureChanged))
        
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
    }
    
    @objc func panGestureChanged(_ gesture: UIPanGestureRecognizer) {
        guard gesture.view != nil else { return }
        guard gesture.state == .changed || gesture.state == .ended else { return }
        
        let translation = gesture.translation(in: self.superview)
        var newX = self.center.x + translation.x
        var newY = self.center.y + translation.y
        
        // Limit panning within certain bounds
        newX = max(self.bounds.width / 2, min(self.superview!.bounds.width - self.bounds.width / 2, newX))
        newY = max(self.bounds.height / 2, min(self.superview!.bounds.height - self.bounds.height / 2, newY))
        
        self.center = CGPoint(x: newX, y: newY)
        gesture.setTranslation(CGPoint.zero, in: self.superview)
        
        if gesture.state == .ended {
            // Snap to specific positions based on final location
            let snapThreshold = self.superview!.bounds.width / 2
            if newX >= snapThreshold {
                UIView.animate(withDuration: 0.3) {
                    self.center = CGPoint(x: self.superview!.bounds.width - 20 - self.bounds.width / 2, y: newY)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.center = CGPoint(x: self.bounds.width / 2 + 20, y: newY)
                }
            }
        }
    }

    
    @objc func pinchGestureChanged () {
        if pinchGesture.state == UIGestureRecognizer.State.began {
            lastScale = 1.0
        }
        
        if lastScale != nil {
            let scale = 1.0 - (lastScale! - pinchGesture.scale)
            
            let newTransform: CGAffineTransform = CGAffineTransformScale(self.transform, scale, scale)
            
            // Only apply the changes if this view is shorter than the super view
            print(self.frame.size.height)
            
            if shouldViewSizeChange(height: self.frame.size.height) {
                self.transform = newTransform
                lastScale = pinchGesture.scale
            }
        }
    }
    
    func shouldViewSizeChange (height: CGFloat) -> Bool {
        let maxHeight: CGFloat = self.superview!.frame.size.height
        let minHeight: CGFloat = 140.0 // Any smaller than this and it's hard to pinch
        
        if height > minHeight && height < maxHeight {
            return true
        }
        else {
            if height > maxHeight && pinchGesture.scale < lastScale! {
                return true;
            }
            if height < minHeight && pinchGesture.scale > lastScale! {
                return true
            }
            
            return false
        }
    }
}
