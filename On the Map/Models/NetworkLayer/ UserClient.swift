//
//  APIClient.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Class Responsbility: Responsible for handling all functions related to user (AuthenticateLogin - Getting userData - ConfirmLogout )

class UserClient{
//   Authentication ( Get session ID ) ----> login authentication
    class func authenticate ( userName:String, password:String, completion: @escaping(Result<Auth?, Error>)->()) {
        let body = Udacity(udacity: .init(username: userName, password: password))
        NetworkEngine.post(with: udacityEndPoint.getSessionId, body: body) { (result:Result<Auth?, Error>) in
            completion(result)
        }
    }
    
//    Get user information
    class func getUserDataRequest(userName:String,password:String, completion:@escaping(Result<UserInformation?, Error>)->() ){
        authenticate(userName: userName, password: password) { (result:Result<Auth?, Error>) in
            switch result {
            case .success(let data):
                let authData = data
                
                NetworkEngine.fetch(with: udacityEndPoint.getUserInfo(id: (authData?.account.key)!)) { (result:Result<UserInformation?, Error>) in
                    completion(result)
                }
                
            case .failed(let error):
                completion(.failed(error))
            }
        }
    }
//    delete user Data ---> logout
    class func delete ( )  {
        
        
        let shared = udacityEndPoint.deleteSessionId
        var components = URLComponents()
        components.scheme = shared.scheme
        components.host = shared.host
        components.path = shared.path
        guard let urlString = components.url  else {return}
        var urlRequest = URLRequest(url: urlString)
        urlRequest.httpMethod = shared.method
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            urlRequest.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            guard  let dataDeletedJSON =  String(data:newData , encoding: .utf8) else {return} 
            print("_________Deleted json \(dataDeletedJSON)")
                 
        }
        task.resume()
    }
    
    
}
