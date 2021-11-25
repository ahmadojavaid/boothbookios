//
//  APIManagerBase.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias APIResponseClousure = (_ status: APIResponseStatus, _ response: Data?) -> Void

class BaseManager:NSObject {
    
    var headers: HTTPHeaders {
        //Reachability.forInternetConnection()
        return ["Content-Type": "application/json"]
    }
    var headersAJSON: HTTPHeaders {
        return ["Accept": "application/json"]
    }
    var headersACJSON: HTTPHeaders {
        return ["Content-Type": "application/json",
                      "Accept": "application/json"]
    }
    var headersACJSONAuth: HTTPHeaders {
        return ["Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer \(User.current?.client_secret ?? "")"]
    }
    
    var isNetworkReachable: Bool {
        guard let reachability = Reachability.forInternetConnection() else { return true }
        return reachability.isReachable()
    }
    
    var sessionManager: SessionManager
    var user: User?
    var basePath: String {
        return UserLogin().baseURL
    }
    
    
    override init() {
        sessionManager = Alamofire.SessionManager.default
        sessionManager.adapter = APIMiddleware()
        self.user = nil
    }
}

extension BaseManager {
    /// HTTP GET type request
    func getRequestWithAuth(_ endPoint: String, completion: @escaping APIResponseClousure) {
        let urlString = basePath + endPoint
        let urlStringg = urlString.replacingOccurrences(of: " ", with: "%20").trimmed

        guard let url = URL(string: urlStringg) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }
        
        sessionManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).response { (response) in
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            let status = APIResponseStatus(isSuccess: true, code: 200, message: "")
            return completion(status, value)
        }
    }
    
    func postRequestWithAuth(_ endPoint: String, parameters:[String:Any]? = nil, completion: @escaping APIResponseClousure) {
        let urlString = basePath + endPoint
        guard let url = URL(string: urlString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }
        
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).response { (response) in
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            let status = APIResponseStatus(isSuccess: true, code: 200, message: "")
            return completion(status, value)
        }
    }
    
    
    func getRequest(_ endPoint: String, parms:[String:Any]?, header:HTTPHeaders?, completion: @escaping APIResponseClousure) {
        let urlString = basePath + endPoint
        print("urlString: \(urlString)")
        guard let url = URL(string: urlString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }
        
        Alamofire.request(url, method: .get, parameters: parms, encoding: JSONEncoding.default, headers: header).response { (response) in
            //print("Response: \(String(data: response.data ?? Data(), encoding: .utf8))")
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            return completion(APIResponseStatus.success, value)
        }
    }
    
    func postRequest(_ method: String, parms:[String:Any]?, header:HTTPHeaders?, completion: @escaping APIResponseClousure) {
        let urlString = basePath + method
        print("urlString: \(urlString)")
        guard let url = URL(string: urlString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        print(url)
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }

        Alamofire.request(url, method: .post, parameters: parms, encoding: JSONEncoding.default, headers: header ?? headersACJSON).response { (response) in
            
            //guard let data = response.data else { return }
            //print("Error: \(response.error?.localizedDescription)")
            //print("Response Data:" + (String(data: data, encoding: .utf8) ?? ""))
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            let status = APIResponseStatus(isSuccess: true, code: 200, message: "")
            return completion(status, value)
        }
    }
    
    func postRequestRowBody(_ method: String, parms:[String:Any]?, header:HTTPHeaders?, body:String, completion: @escaping APIResponseClousure) {
        let urlString = basePath + method
        guard let encodedString = urlString.removingPercentEncoding else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        guard let url = URL(string: encodedString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        if let url2 = URL(string: encodedString) {
            print("URL Conversion Failed")
        }
        print(url)
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }
        
        Alamofire.request(url, method: .post, parameters: parms, encoding: body, headers: header).response { (response) in
            
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            let status = APIResponseStatus(isSuccess: true, code: 200, message: "")
            return completion(status, value)
        }
    }
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        let httpBody = data(using: .utf8, allowLossyConversion: false)
        request.httpBody = httpBody
        return request
    }
    
}

