//
//  Utilities.swift
//  Sharjah Book Festival
//
//  Created by Zuhair Hussain on 01/03/2018.
//  Copyright © 2018 Zuhair Hussain. All rights reserved.
//

import UIKit

class Utilities {
    static let shared = Utilities()
    
    func navigationController(withRootController controller: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.sbDarkGrey
        
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.layer.shadowColor = UIColor(red: 170/255, green: 170/255, blue: 190/255, alpha: 1).cgColor
        navController.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navController.navigationBar.layer.shadowRadius = 8.0
        navController.navigationBar.layer.shadowOpacity = 0.5
        navController.navigationBar.layer.masksToBounds = false
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.sbDarkGrey,
            //NSAttributedString.Key.font: SBLanguage.shared.currentLanguage == "ar" ? AppConfig.shared.arabicFont : UIFont.systemFont(ofSize: 17)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        return navController
    }
    
    
}
