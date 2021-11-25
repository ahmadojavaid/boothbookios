//
//  UIColor+Extension.swift
//  Sharjah Book Festival
//
//  Created by Zuhair Hussain on 28/02/2018.
//  Copyright © 2018 Zuhair Hussain. All rights reserved.
//

import UIKit

extension UIColor {
    static var sbGrey: UIColor {
        return UIColor(red: 122/255, green: 122/255, blue: 122/255, alpha: 1)
    }
    static var sbDarkGrey: UIColor {
        return UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    }
    static var sbPink: UIColor {
        return UIColor(red: 222/255, green: 36/255, blue: 92/255, alpha: 1)
    }
    static var sbGreen: UIColor {
        return UIColor(red: 117/255, green: 184/255, blue: 78/255, alpha: 1)
    }
    static var appGreen: UIColor {
        return UIColor(red: 0/255, green: 150/255, blue: 76/255, alpha: 1)
    }
    static var appRed: UIColor {
        return UIColor(red: 168 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
    }
    static var appGray: UIColor {
        return UIColor(red: 61 / 255, green: 61 / 255, blue: 61 / 255, alpha: 1)
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
