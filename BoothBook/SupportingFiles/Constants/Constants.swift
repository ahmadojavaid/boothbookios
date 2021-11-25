//
//  Constants.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import UIKit

struct Constants {
    static let baseURL = UserLogin().baseURL
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    static var safeArea: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
    }
}

class DateFormat {
    static let event_date_iso = "yyyy-MM-dd"
}
