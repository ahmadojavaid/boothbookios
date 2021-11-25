//
//  Location.swift
//  BoothBook
//
//  Created by abbas on 3/3/20.
//  Copyright © 2020 SSA Soft. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    var latitude:Double = 0
    var longitude:Double = 0
    
    static let current = Location()
    static let classRoom:Location = {
        let loc = Location()
        loc.loadData()
        return loc
    }()
    
    init(){
        
    }
    
    init(lat:CLLocationDegrees, long:CLLocationDegrees) {
        self.update(lat:lat, long:long)
    }
    
    func update(lat:CLLocationDegrees, long:CLLocationDegrees) {
        self.latitude = Double(lat)
        self.longitude = Double(long)
    }
    
    func save() {
        UserDefaults.standard.set(latitude, forKey: "CurrentLatitude")
        UserDefaults.standard.set(longitude, forKey: "CurrentLongitude")
    }
    
    fileprivate func loadData(){
        self.latitude = UserDefaults.standard.double(forKey: "CurrentLatitude")
        self.longitude = UserDefaults.standard.double(forKey: "CurrentLongitude")
    }
    
    func debugDescription(){
        print("locations = \(latitude) \(longitude)")
    }
}
