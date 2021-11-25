//
//  Enums.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import UIKit

enum NetworkStatus {
    case connected, disconnected
}

enum ToastType {
    case `default`, error, success
    
    var color: UIColor {
        switch self {
        case .default:
            return UIColor.appGray
        case .error:
            return UIColor.appRed
        case .success:
            return UIColor.appGreen
        }
    }
}

enum AnimationType {
    case fadeIn, fadeOut
}
