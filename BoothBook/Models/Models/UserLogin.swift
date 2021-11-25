//
//  UserLogin.swift
//  BoothBook
//
//  Created by abbas on 02/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import Foundation
class UserLogin: NSObject {
    var userName:String
    var password:String
    var baseURL:String
    
    
    override init() {
        userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        password = UserDefaults.standard.string(forKey: "password") ?? ""
        baseURL = UserDefaults.standard.string(forKey: "baseURL") ?? "https://"
    }
    
    init(userName:String, password:String, baseUrl:String){
        self.userName = userName
        self.password = password
        self.baseURL = baseUrl
    }
    
    func save(){
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(baseURL, forKey: "baseURL")
    }
    
    func load() {
        userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        password = UserDefaults.standard.string(forKey: "password") ?? ""
        baseURL = UserDefaults.standard.string(forKey: "baseURL") ?? "https://"
    }
}
