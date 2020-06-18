//
//  UserClient.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Class Responsbility: Responsible for handling all functions related to user (AuthenticateLogin - Getting userData - ConfirmLogout )
class UserClient{
    
    
    //   Authentication (Get session ID)-> login authentication
    class func authenticate ( userName:String, password:String, completion: @escaping(Result<Auth?, Error>)->()) {
        let body = Udacity(udacity: .init(username: userName, password: password))
        NetworkEngine.post(with: udacityEndPoint.getSessionId, body: body) { (result:Result<Auth?, Error>) in
            completion(result)
        }
    }
    
    //    Get user information
    class func getUserDataRequest(userKey:String, completion:@escaping(Result<UserInformation?, Error>)->() ){
        NetworkEngine.fetch(with: udacityEndPoint.getUserInfo(id: userKey)) { (result:Result<UserInformation?, Error>) in
            completion(result)
        }
        
    }
    
    
    
    //    delete user Data ---> logout
    class func studentLogout(deleteSessionId: String, expireAt: String, completion: @escaping (Bool?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        request.httpBody = "{\"id\": \"\(deleteSessionId)\", \"expiration\": \"\(expireAt)\"}".data(using: .utf8)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            do{
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        }
        task.resume()
        
    }
    
    
}
