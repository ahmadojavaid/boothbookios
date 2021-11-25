//
//  Strings.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import Foundation

enum Strings: String {
    case movies = "Movies"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
}

enum ErrorMessages: String {
    case noNetwork = "Internet connection appears offline"
    case unknown = "Unable to communicate"
    case invalidRequest = "Invalid request"
    case invalidResponse = "Invalid response"
    case success = "Request completed successfully"
    
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
