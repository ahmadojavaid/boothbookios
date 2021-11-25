//
//  LeadFormSettingsModel.swift
//  BoothBook
//
//  Created by abbas on 06/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class LeadFormSettingsModel:NSObject {
    var logoImage:UIImage?
    var listMataData:[[(String, String, Bool?, Bool?)]] = [
        [("Aditional Notes","Aditional Notes", true, true),
         ("Contact Permission","Contact Permission", true, true)],
        [("Form Text Colour","000000",nil, nil),
         ("Form Background Color", "ffffff",nil, nil),
         ("Font","OpenSans",nil, nil),
         ("Submit Text", "Submit",nil, nil),
         ("Submit Text Color", "ffffff",nil, nil),
         ("Submit Button Color", "333333",nil, nil),
         ("Logo","Add",nil, nil)],
        [("Thank you, your form has been submitted. Ready to book now?", "Book Now",true, nil)],
        [("First Name", "First Name",true, true),
         ("Last Name", "Last Name",true, true),
         ("Company Name","Company Name",true, true),
         ("Email","Email",true, true),
         ("Telephone","Telephone",true, true),
         ("Mobile Phone","Mobile Phone",true, true),
         ("Address","Address",true, true),
         ("City","City",true, true),
         ("Event Post Code","Post Code",true, true)],
        [("Customer Post Code", "Post Code",true, true),
         ("Event Start Time", "Event Start Time",true, true),
         ("Event End Time", "Event End Time",true, true),
         ("Event Type", "Event Type",true, true),
         ("Event Name", "Event Name",true, true),
         ("Max Budget", "Max Budget",true, true)],
        [("Venue Name", "Venue Name",true, true),
         ("Venue Address", "Venue Address",true, true),
         ("Venue Post Code", "Venue Post Code",true, true),
         ("Save", "",nil, nil)
        ]
    ]
    
    override init() {
        super.init()
    }
    /*
    enum Section:NSString {
        case aditionalNotes = "0",
        design = "1",
        onSubmit = "2",
        customerDetails = "3",
        customerDetailsTwo = "4"
    }
    
    subscript(key: Section) -> [(String, String, Bool?, Bool?)] {
        get {
            return listMataData[key.rawValue.integerValue]
        }
        set(value) {
            listMataData[key.rawValue.integerValue] = value
        }
    }
    */
    subscript(key: Int) -> (String, String, Bool?, Bool?) {
        get {
            let col = Int(key/10)
            let row = key % 10
            return listMataData[col][row]
        }
        set(value) {
            let col = Int(key/10)
            let row = key % 10
            listMataData[col][row] = value
        }
    }
    
    static var current: LeadFormSettingsModel! {
        get {
            let leadFormSettingsModel = LeadFormSettingsModel()
            for (col, listData) in leadFormSettingsModel.listMataData.enumerated() {
                for (row, _ ) in listData.enumerated() {
                    if let data = UserDefaults.standard.value(forKey: "listMataData0\(col)\(row)") as? String {
                        leadFormSettingsModel.listMataData[col][row].0 = data
                    }
                    else {
                        return leadFormSettingsModel
                    }
                    leadFormSettingsModel.listMataData[col][row].1 = UserDefaults.standard.value(forKey: "listMataData1\(col)\(row)") as! String
                    leadFormSettingsModel.listMataData[col][row].2 = UserDefaults.standard.value(forKey: "listMataData2\(col)\(row)") as? Bool
                    leadFormSettingsModel.listMataData[col][row].3 = UserDefaults.standard.value(forKey: "listMataData3\(col)\(row)") as? Bool
                }
            }
            if let imageData = UserDefaults.standard.value(forKey: "LogoImage") as? Data {
                leadFormSettingsModel.logoImage = UIImage(data: imageData)!
            }
            return leadFormSettingsModel
        }
    }
    
    func save() {
        for (col, listData) in listMataData.enumerated() {
            for (row, data) in listData.enumerated() {
                UserDefaults.standard.set(data.0, forKey: "listMataData0\(col)\(row)")
                UserDefaults.standard.set(data.1, forKey: "listMataData1\(col)\(row)")
                UserDefaults.standard.set(data.2, forKey: "listMataData2\(col)\(row)")
                UserDefaults.standard.set(data.3, forKey: "listMataData3\(col)\(row)")
            }
        }
        if let image = logoImage {
            let imageData = image.jpegData(compressionQuality: 0.1)
            UserDefaults.standard.set(imageData, forKey: "LogoImage")
        }
    }
    
    func clear() {
        UserDefaults.standard.set(nil, forKey: "LeadFormSettingsModel")
        UserDefaults.standard.set(nil, forKey: "LogoImage")
    }
}

