
//  LogInManager.swift
//  BoothBook

//  Created by abbas on 02/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.


import Foundation

class LogInManager:BaseManager {
    func logIn(userName:String, password:String, completion:@escaping (APIResponseStatus?, User?)->Void){
        let endPoint = "api/v1/login?username=\(userName)&password=\(password)"
        print("myurlll")
        print(endPoint)
        getRequest(endPoint, parms: nil, header: nil) { (status, data) in
            if status.isSuccess {
                let response = try? JSONDecoder().decode(User.self, from: data!)
                if let response = response {
                    let status = APIResponseStatus(isSuccess: response.success ?? false, code: 200, message: response.msg ?? "")
                    completion(status, response)
                } else {
                    completion(APIResponseStatus.invalidResponse, nil)
                }
            } else {
                completion(status, nil)
            }
        }
    }
}
