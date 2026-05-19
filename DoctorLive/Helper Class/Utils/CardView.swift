//
//  CardView.swift
//  SampleProject
//
//  Created by Admin on 19/04/21.
//

import Foundation
import UIKit

class CardView: UIView {
    @IBInspectable var cornerrdius: CGFloat = 15
    @IBInspectable var shadowoffsetwidth: CGFloat = 0
    @IBInspectable var shadowoffsetheight: CGFloat = 0
    @IBInspectable var shadowcolor: UIColor = UIColor.lightGray
    @IBInspectable var shadowopacity: CGFloat = 0.1
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerrdius
        layer.shadowColor = shadowcolor.cgColor
        layer.shadowOffset = CGSize(width: shadowoffsetwidth, height: shadowoffsetheight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerrdius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowopacity)
        layer.shadowColor = UIColor.black.cgColor
    }
}
