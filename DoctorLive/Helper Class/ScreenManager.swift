//
//  ScreenManager.swift
//  Quizlok
//
//  Created by Inshad Ansari on 04/01/21.
//

import Foundation
import UIKit


class ScreenManager {
        class func mainStoryboard() -> UIStoryboard {
            return UIStoryboard(name: "Main", bundle: nil)
        }
        
        class func loginSignupStoryboard() -> UIStoryboard {
            return UIStoryboard(name: "Login_SignUP", bundle: nil)
        }
        
        class func remainingStoryboard() -> UIStoryboard {
            return UIStoryboard(name: "RemainingStoryboard", bundle: nil)
        }
        
     class func animateScrollViewHorizontally(destinationPoint destination: CGPoint, andScrollView scrollView: UIScrollView, andAnimationMargin margin: CGFloat) {
            
            var change: Int = 0;
            let diffx: CGFloat = destination.x - scrollView.contentOffset.x;
            var _: CGFloat = destination.y - scrollView.contentOffset.y;
            
            if(diffx < 0) {
                
                change = 1
            }
            else {
                
                change = 2
                
            }
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3);
            UIView.setAnimationCurve(.easeIn);
            switch (change) {
                
            case 1:
                scrollView.contentOffset = CGPoint(x: destination.x - margin, y: destination.y);
            case 2:
                scrollView.contentOffset = CGPoint(x: destination.x + margin, y: destination.y);
            default:
                return;
            }
            
            UIView.commitAnimations();
            
            let firstDelay: Double  = 0.3;
            let startTime: DispatchTime = DispatchTime.now() + Double(Int64(firstDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: startTime, execute: {
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2);
                UIView.setAnimationCurve(.linear);
                switch (change) {
                    
                case 1:
                    scrollView.contentOffset = CGPoint(x: destination.x + margin, y: destination.y);
                case 2:
                    scrollView.contentOffset = CGPoint(x: destination.x - margin, y: destination.y);
                default:
                    return;
                }
                
                UIView.commitAnimations();
                let secondDelay: Double  = 0.2;
                let startTimeSecond: DispatchTime = DispatchTime.now() + Double(Int64(secondDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: startTimeSecond, execute: {
                    
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationDuration(0.1);
                    UIView.setAnimationCurve(.easeInOut);
                    scrollView.contentOffset = CGPoint(x: destination.x, y: destination.y);
                    UIView.commitAnimations();
                    
                })
            })
        }
     } 
