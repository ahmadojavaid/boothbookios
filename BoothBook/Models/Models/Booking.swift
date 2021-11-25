//
//  Bookings.swift
//  BoothBook
//
//  Created by abbas on 03/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import Foundation
import SwiftyJSON

class LeadStatusModel:NSObject {
    var id:String = ""
    var label:String = ""
    
    init(id:String, label:String) {
        self.id = id
        self.label = label
    }
}

class EventTypesModel:NSObject {
    
    var id:String = ""
    var label:String = ""
    
    init(id:String, label:String) {
        self.id = id
        self.label = label
    }
}



class BookingModel:NSObject {
    var key:String
    var secret:String
    var first_name:String
    var last_name:String
    var company:String
    var email:String  // (plain text string - but valid email required)
    var telephone:String
    var mobile_phone_number:String
    var street_address:String
    var city:String
    var postcode_event:String
    var postcode_customer:String
    //var event_date:String //(date in ISO format e.g 2019-09-22)
    var event_time_start:String //(must be formatted as number and am/pm e.g. 7am)
    var event_time_end:String //(must be formatted as number and am/pm e.g. 9pm)
    var event_type:String //(Integer -  use **Event Type ENDPOINT:String to find integer value)
    var event_name:String
    var venue_name:String
    var venue_address:String
    var venue_postcode:String
    //var pipeline_status:String //(Requires option set by **Pipeline Status ENDPOINT**)
    var additional_notes:String
    required init(
        key:String,
        secret:String,
        first_name:String,
        last_name:String,
        company:String,
        email:String,
        telephone:String,
        mobile_phone_number:String,
        street_address:String,
        city:String,
        postcode_event:String, // Updated
        postcode_customer:String, // New
        //event_date:String,
        event_time_start:String,
        event_time_end:String,
        event_type:String,
        event_name:String,
        venue_name:String,
        venue_address:String,
        venue_postcode:String,
        //pipeline_status:String,
        additional_notes:String
        ) {
        self.key = key
        self.secret = secret
        self.first_name = first_name
        self.last_name = last_name
        self.company = company
        self.email = email
        self.telephone = telephone
        self.mobile_phone_number = mobile_phone_number
        self.street_address = street_address
        self.city = city
        self.postcode_event = postcode_event
        self.postcode_customer = postcode_customer
        self.event_time_start = event_time_start
        self.event_time_end = event_time_end
        self.event_type = event_type
        self.event_name = event_name
        self.venue_name = venue_name
        self.venue_address = venue_address
        self.venue_postcode = venue_postcode
        //self.pipeline_status = pipeline_status
        self.additional_notes = additional_notes
    }
    override init() {
        key = ""
        secret = ""
        first_name = ""
        last_name = ""
        company = ""
        email = ""
        telephone = ""
        mobile_phone_number = ""
        street_address = ""
        city = ""
        postcode_event = ""
        postcode_customer = ""
        event_time_start = ""
        event_time_end = ""
        event_type = ""
        event_name = ""
        venue_name = ""
        venue_address = ""
        venue_postcode = ""
        //pipeline_status = ""
        additional_notes = ""
    }
}

class Booking: NSObject, NSCoding {
    var responseData:Data?
    var responseDict:[String:JSON] {
        if let responseData = responseData, let json = try? JSON(data: responseData) {
            return json.dictionaryValue
        }
        return [:]
    }

    var json:JSON = JSON()
    enum Keys: String,CodingKey {
        case created_iso,
        staff,
        customer,
        status,
        changed_iso,
        venue,
        notes,
        id,
        event,
        signature_required,
        price,
        packages,
        extras,
        created,
        changed,
        rep,
        phone,
        email
    }
    
    init(_ bookingJson:inout JSON) {
        json = bookingJson
    }
    init(_ responseData:Data) {
        self.responseData = responseData
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(responseData,forKey:"responseData")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.responseData = aDecoder.decodeObject(forKey: "responseData") as? Data
    }
    
    static var current:Booking? = Booking.currentBookings()
    
    private static func currentBookings() -> Booking? {
            var booking: Booking?
            let fileManager = FileManager.default
            let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let fullPath = paths[0].appendingPathComponent("BookingData")
            print("fullPath : \(fullPath)")
            do {
                let data = try Data(contentsOf: fullPath)
                booking = NSKeyedUnarchiver.unarchiveObject(with: data) as? Booking
                return booking
            }
            catch {
                return nil
            }
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("BookingData")
        print("fullPath : \(fullPath)")
        try? data.write(to: fullPath, options: .atomic)
    }
    
    func clear() {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("BookingData")
        try? fileManager.removeItem(at: fullPath)
    }
    
    static func bookingList(bookingJsonList:[JSON]) -> [Booking] {
        var bookings:[Booking]=[]
        for booking in bookingJsonList {
            var booking = booking
            bookings.append(Booking(&booking))
        }
        return bookings
    }
    
    func all() -> [Booking] {
        let bookingJsonList = Array(self.responseDict.values)
        var bookings:[Booking]=[]
        for booking in bookingJsonList {
            var booking = booking
            bookings.append(Booking(&booking))
        }
        return bookings
    }
    
    func append(newBooking: JSON){
        var newBookingJson = self.responseDict
        newBookingJson["0"] = newBooking
        self.responseData = try? JSON(newBookingJson).rawData()
        self.save()
    }
    
    subscript(key: Keys) -> JSON {
        get {
            return json[key.rawValue]
        }
        set(value) {
            json[key.rawValue] = value
        }
    }
    
}

class Staff: NSObject {
    var json:JSON = JSON()
    enum Keys: String,CodingKey {
        case written
    }
    
    init(_ staffJson:inout JSON) {
        json = staffJson
    }
    subscript(key: Keys) -> JSON {
        get {
            return json[key.rawValue]
        }
        set(value) {
            json[key.rawValue] = value
        }
    }
}

class Customer: NSObject {
    var json:JSON = JSON()
    enum Keys: String,CodingKey {
        case first_name,
        company,
        customer_country,
        last_name,
        customer_city,
        customer_street_address,
        customer_postcode
    }
    
    init(_ customerJson:inout JSON) {
        json = customerJson
    }
    subscript(key: Keys) -> JSON {
        get {
            return json[key.rawValue]
        }
        set(value) {
            json[key.rawValue] = value
        }
    }
}

class Venue: NSObject {
    var json:JSON = JSON()
    enum Keys: String,CodingKey {
        case business_country, // : "United Kingdom"
        venue_name, // : "Buckrell Hotel"
        venue_postcode, // : "EX14 3PG"
        venue_address // : "Buckerell Village, Weston, Honiton"
    }
    
    init(_ venueJson:inout JSON) {
        json = venueJson
    }
    subscript(key: Keys) -> JSON {
        get {
            return json[key.rawValue]
        }
        set(value) {
            json[key.rawValue] = value
        }
    }
}
/////////////////

class Notes: NSObject {
    var json:JSON = JSON()
    enum Keys: String,CodingKey {
        case notes_admin, //: "None"
        notes_customer //: "None"
    }
    
    init(_ notesJson:inout JSON) {
        json = notesJson
    }
    subscript(key: Keys) -> JSON {
        get {
            return json[key.rawValue]
        }
        set(value) {
            json[key.rawValue] = value
        }
    }
}


class Event: NSObject {
    var json:JSON = JSON()
    enum Keys: String,CodingKey {
        case event_name, //: "Joe & Jenny"
        event_time_end_formatted, //: "10:30pm"
        event_date_us, //: "Thursday Jan 31st 2019"
        event_time_start, //: "70200"
        event_date_uk, //: "Thursday 31st Jan 2019"
        event_time_end, //: "81000"
        event_date_iso, //: "2019-01-31"
        event_time_start_formatted //: "7:30pm"
    }
    
    init(_ eventJson:inout JSON) {
        json = eventJson
    }
    subscript(key: Keys) -> JSON {
        get {
            return json[key.rawValue]
        }
        set(value) {
            json[key.rawValue] = value
        }
    }
}


class Price: NSObject {
    var json:JSON = JSON()
    enum Keys: String,CodingKey {
        case total, //: "1270.60"
        total_override //: null
    }
    
    init(_ priceJson:inout JSON) {
        json = priceJson
    }
    subscript(key: Keys) -> JSON {
        get {
            return json[key.rawValue]
        }
        set(value) {
            json[key.rawValue] = value
        }
    }
}
