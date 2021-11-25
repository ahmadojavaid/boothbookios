
//  Bookings.swift
//  BoothBook

//  Created by abbas on 02/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.


import Foundation
import SwiftyJSON

class BookingsManager:BaseManager {
    enum Scope:String {
        case full, minimal
    }
    
    func bookings(scope:Scope? = nil, startDate:Date? = nil, endDate:Date? = nil, bookingId:Int? = nil, completion:@escaping (APIResponseStatus, _ responseData:Data?)->Void){
        
        let format = "yyyy-MM-dd"
        let user = User.current
        
        let key = user?.client_key ?? ""
        let secret = user?.client_secret ?? ""
        
        var endPoint =  "api/v1/get/bookings?key=\(key)&secret=\(secret)"
        if let scope = scope {
            endPoint = endPoint + "&scope=\(scope.rawValue)"
        }
        if let startDate = startDate {
            endPoint = endPoint + "&start=\(startDate.toString(format))"
        }
        if let endDate = endDate {
            endPoint = endPoint + "&end=\(endDate.toString(format))"
        }
        if let bookingId = bookingId {
            endPoint = endPoint + "&booking_id=\(bookingId)"
        }
        
        getRequest(endPoint, parms: nil, header: nil) { (status, data) in
            if status.isSuccess {
                if let json = try? JSON(data: data!) { //, let msg = json["message"] {
                    let msg = json["message"].string ?? ""
                    let bookings = try? (json["bookings"]).rawData()
                    completion(APIResponseStatus(isSuccess: true, code: 200, message: msg), bookings)
                } else {
                    completion(APIResponseStatus.invalidResponse, nil)
                }
            } else {
                completion(status, nil)
            }
        }
    }
    
    func submitLead(_ lead:BookingModel, completion:@escaping (APIResponseStatus)->Void){
        let parms:[String:Any] = [
            "first_name": lead.first_name,  //first_name
            "last_name": lead.last_name,  //last_name
            "company": lead.company,  //company
            "email": lead.email,  //email@gmail.com
            "telephone": lead.telephone,  //03331599972
            "mobile_phone_number": lead.mobile_phone_number,  //03331599972
            "street_address": lead.street_address,  //street_address
            "city": lead.city,  //city
            "postcode": lead.postcode_customer,  //34563
            "event_date": lead.event_time_start.toDate("hh:mm a dd/MM/yyyy")?.toString("yyyy-MM-dd") ?? "",  //2020-5-14
            "event_time_start": lead.event_time_start.toDate("hh:mm a dd/MM/yyyy")?.toString("hh:mm a") ?? "",  //12:00 AM
            "event_time_end": lead.event_time_end.toDate("hh:mm a dd/MM/yyyy")?.toString("hh:mm a") ?? "",  //02:00 Pm
            "event_type": lead.event_type,  //301
            "event_name": lead.event_name,  //event_name
            "venue_name": lead.venue_name,  //venue_name
            "venue_address": lead.venue_address,  //venue_address
            "venue_postcode": lead.venue_postcode,  //34245
            "additional_notes": lead.additional_notes,  //additional_notes
        ]
        
        let user = User.current
        let key = user?.client_key ?? ""
        let secret = user?.client_secret ?? ""
        let endPoint = "api/v1/create/lead?key=\(key)&secret=\(secret)"
        postRequest(endPoint, parms: parms, header: nil) { (status, data) in
            if status.isSuccess {
                let json = (try? JSON(data: data ?? Data())) ?? JSON()
                completion(APIResponseStatus(isSuccess: true, code: status.code, message: json["message"].stringValue))
                
                print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            } else {
                completion(status)
            }
        }
    }
    
    func getEventTypes(completion:@escaping (APIResponseStatus, _ responseData:[EventTypesModel])->Void) {
        let user = User.current
        let key = user?.client_key ?? ""
        let secret = user?.client_secret ?? ""
        let endPoint =  "api/v1/get/event_types?key=\(key)&secret=\(secret)"
        
        getRequest(endPoint, parms: nil, header: nil) { (status, data) in
            if status.isSuccess {
                if let json = try? JSON(data: data!) { //, let msg = json["message"] {
                    let eventTypeArray = json.arrayValue.map({ (jsonDict) -> EventTypesModel in
                        let eType = jsonDict.dictionaryObject as? [String:String] ?? [:]
                        let id = eType["id"] ?? ""
                        let label = eType["label"] ?? ""
                        return EventTypesModel(id: id, label: label)
                    })
                    completion(APIResponseStatus.success, eventTypeArray)
                } else {
                    completion(APIResponseStatus.invalidResponse, [])
                }
            } else {
                //"result": "API key Mismatch",
                //"message": "The API access keys you provided were missing, incorrect, or failed validation."
                completion(status, [])
            }
        }
    }
    
    func getLeadStatus(completion:@escaping (APIResponseStatus, _ responseData:[LeadStatusModel])->Void) {
        let user = User.current
        
        let key = user?.client_key ?? ""
        let secret = user?.client_secret ?? ""
        let endPoint =  "api/v1/get/lead_statuses?key=\(key)&secret=\(secret)"
    
        getRequest(endPoint, parms: nil, header: nil) { (status, data) in
            if status.isSuccess {
                if let json = try? JSON(data: data!) { //, let msg = json["message"] {
                    let leadStatusArray = json.arrayValue.map({ (jsonDict) -> LeadStatusModel in
                        let eType = jsonDict.dictionaryObject as? [String:String] ?? [:]
                        let id = eType["id"] ?? ""
                        let label = eType["label"] ?? ""
                        return LeadStatusModel(id: id, label: label)
                    })
                    completion(APIResponseStatus.success, leadStatusArray)
                } else {
                    completion(APIResponseStatus.invalidResponse, [])
                }
            } else {
                completion(status, [])
            }
        }
    }
}
