//
//  AppConfig.swift
//  Sharjah Book Festival
//
//  Created by Zuhair Hussain on 28/02/2018.
//  Copyright © 2018 Zuhair Hussain. All rights reserved.
//

import UIKit

class AppConfig {
    static let shared = AppConfig()
    
    var arabicFont = UIFont(name: "A_Nefel_Adeti", size: 22)
    
    let leftMenuWidth: CGFloat = (284 / 375) * UIScreen.main.bounds.width
}
