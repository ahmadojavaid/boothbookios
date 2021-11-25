//
//  TabBarViewController.swift
//  BoothBook
//
//  Created by abbas on 26/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let barIcons = ["bar_calender", "bar_leads", "bar_leadCapture", "bar_settings"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tab1 = BookingsFilterViewController(nibName: "BookingsFilterViewController", bundle: .main)
        let tab2 = LeadsViewController(nibName: "LeadsViewController", bundle: .main)
        let tab3 = LeadCaptureFormViewController(nibName: "LeadCaptureFormViewController", bundle: .main)
        tab3.hidesBottomBarWhenPushed = true
        let tab4 = SettingsViewController(nibName: "SettingsViewController", bundle: .main)
        
        let nav1 = UINavigationController(rootViewController: tab1)
        let nav2 = UINavigationController(rootViewController: tab2)
        let nav3 = UINavigationController(rootViewController: tab3)
        let nav4 = UINavigationController(rootViewController: tab4)
        
        self.setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        for (id, icon) in barIcons.enumerated() {
            self.tabBar.items?[id].image = UIImage(named: icon)
        }
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 0.8472281678, alpha: 1)
        self.tabBar.barTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.7999122739, green: 0.8000505567, blue: 0.799903512, alpha: 1)
        self.tabBar.addShadow()
    }
}

extension UIViewController {
    func isLogedin(){
        let isLogedin = UserDefaults.standard.bool(forKey: "isLogedin")
        if !isLogedin {
            let vc = LogInViewController(nibName: "LogInViewController", bundle: .main)
            vc.modalTransitionStyle = .flipHorizontal
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
