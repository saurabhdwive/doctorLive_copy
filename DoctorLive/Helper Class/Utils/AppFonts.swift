//
//  AppFonts.swift
//  JustBite
//
//  Created by Aman on 04/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

enum AppFontName: String{
    case poppins     = "Poppins"
}


enum AppFont:String{
    
    case Regular           = "Regular"
    case Bold              = "Bold"
    case Medium            = "Medium"
    case SemiBold          = "SemiBold"
    case Italic            = "Italic"
    
    
    func size(_ name: AppFontName,size:CGFloat) -> UIFont{
        let fontName = self.fullFontName(name.rawValue)
        
        if let font = UIFont(name: fontName, size: size ){
            return font
        }
        return UIFont.systemFont(ofSize: size)//fatalError("Font '\(fullFontName)' does not exist.")
    }
    
    fileprivate func fullFontName(_ fontName:String)->String{
        return rawValue.isEmpty ? fontName : fontName + "-" + rawValue
    }
    
    func with(fontName : AppFontName,_ size: CGFloat) -> UIFont{
        return self.size(fontName, size: size)
    }
}



import UIKit

struct staticAppFont {
    //MARK: - Constant fonts
    public static let textFieldsFonts  = AppFont.Regular.size(AppFontName.poppins, size: 17)
}
