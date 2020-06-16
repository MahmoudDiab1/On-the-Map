//
//  APIClient.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

class APIClient {
     
    
    class func authenticate ( userName:String, password:String, completion: @escaping(Result<Auth?, Error>)->()) {
        let body = Udacity(udacity: .init(username: userName, password: password))
        NetworkEngine.post(with: udacityEndPoint.getSessionId, body: body) { (result:Result<Auth?, Error>) in
            completion(result)
        }
    }
     
    class func getUserDataRequest(userName:String,password:String, completion:@escaping(Result<UserInformation?, Error>)->() ){
        authenticate(userName: userName, password: password) { (result:Result<Auth?, Error>) in
            switch result {
            case .success(let data):
                let authData = data
           
                NetworkEngine.fetch(with: udacityEndPoint.getUserInfo(id: (authData?.account.key)!)) { (result:Result<UserInformation?, Error>) in
                      print(result)
                    completion(result)
                   
                }
            case .failed(let error):
                print(error)
            }
        }
  
    }
    
    class func 
         
}
