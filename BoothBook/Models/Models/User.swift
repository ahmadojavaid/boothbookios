
//  User.swift
//  UniversityKorner

//  Created by Naveed on 7/31/18.
//  Copyright © 2018 Ali Bajwa. All rights reserved.


import UIKit
//import ObjectMapper

class User:NSObject, Codable, NSCoding {
    var active:Bool?
    var success: Bool?
    var client_key: String?
    var client_secret: String?
    var msg:String?
    var role: String?
    var uid: String?
    
    override init() {
        super.init()
    }
        
    enum CodingKeys: String,CodingKey {
        case active,
        client_key,
        client_secret,
        msg,
        role,
        success,
        uid
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.client_key = try? values.decodeIfPresent(String.self, forKey: .client_key)
        self.client_secret = try? values.decodeIfPresent(String.self, forKey: .client_secret)
        self.msg = try? values.decodeIfPresent(String.self, forKey: .msg)
        self.role = try? values.decodeIfPresent(String.self, forKey: .role)
        self.uid = try? values.decodeIfPresent(String.self, forKey: .uid)
        self.active = try? values.decodeIfPresent(Bool.self, forKey: .active)
        self.success = try? values.decodeIfPresent(Bool.self, forKey: .success)
    }

    required init?(coder aDecoder: NSCoder){
        self.active = aDecoder.decodeObject(forKey: "active") as? Bool
        self.client_key = aDecoder.decodeObject(forKey: "client_key") as? String
        self.client_secret = aDecoder.decodeObject(forKey: "client_secret") as? String
        self.msg = aDecoder.decodeObject(forKey: "msg") as? String
        self.role = aDecoder.decodeObject(forKey: "role") as? String
        self.client_key = aDecoder.decodeObject(forKey: "client_key") as? String
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.success = aDecoder.decodeObject(forKey: "success") as? Bool
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(active,forKey:"active")
        aCoder.encode(client_key,forKey:"client_key")
        aCoder.encode(client_secret,forKey:"client_secret")
        aCoder.encode(msg,forKey:"msg")
        aCoder.encode(role,forKey:"role")
        aCoder.encode(client_key,forKey:"client_key")
        aCoder.encode(uid,forKey:"uid")
        aCoder.encode(success,forKey:"success")
    }
        
    class var current: User? {
        get {
            var user: User?
            let fileManager = FileManager.default
            let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let fullPath = paths[0].appendingPathComponent("data")
            print("fullPath : \(fullPath)")
            do {
                let data = try Data(contentsOf: fullPath)
                user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User
                return user
            }
            catch {
                return nil
            }
        }
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("data")
        print("fullPath : \(fullPath)")
        try? data.write(to: fullPath, options: .atomic)
    }
    
    func clear() {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("data")
        try? fileManager.removeItem(at: fullPath)
    }
}

