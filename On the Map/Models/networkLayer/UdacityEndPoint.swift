//
//  EndPoint.swift
//  On the Map
//
//  Created by mahmoud diab on 6/15/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
//https://onthemap-api.udacity.com/v1/session
//To authenticate Udacity API requests, you need to get a session ID. This is accomplished by using Udacity’s session method:
 
enum udacityEndPoint :EndPoint {
    
    case getSessionId
    case deleteSessionId
    case getUserInfo(id:String)
}
extension udacityEndPoint {
    
    var scheme: String {
        switch self {
        case .getSessionId,.deleteSessionId,.getUserInfo:
            return "https" 
        }
    }
    var host: String {
        switch self {
        case .getSessionId,.deleteSessionId,.getUserInfo:
            return "onthemap-api.udacity.com"
       
        }
    }
    
    var path: String {
        switch  self {
        case .getSessionId,.deleteSessionId:
            return "/v1/session"
        case .getUserInfo(let id):
            return "/v1/users/\(id))"
            
        }
    }
    
    var method: String{
        switch  self {
        case .getSessionId:
            return "POST"
        case .deleteSessionId :
            return "DELETE"
        case .getUserInfo :
            return "GET"
        }
    } 
}


