//
//  EndPoint.swift
//  On the Map
//
//  Created by mahmoud diab on 6/15/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Enum responsbility: Encapsulate urlComponents for different sources in separate way (scheme-host-path-queryItems-method).

enum udacityEndPoint :EndPoint {
    case getSessionId
    case deleteSessionId
    case getUserInfo(id:String)
    case  getStudentLocations
    case postLocation
}

extension udacityEndPoint {
    var scheme: String {
        switch self {
        case .getSessionId,.deleteSessionId,.getUserInfo,.getStudentLocations,.postLocation:
            return "https" 
        }
    }
    
    
    var host: String {
        switch self {
        case .getSessionId,.deleteSessionId,.getUserInfo,.getStudentLocations,.postLocation:
            return "onthemap-api.udacity.com"
        }
    }
    
    var path: String {
        switch self {
        case .getSessionId,.deleteSessionId:
            return "/v1/session"
        case .getUserInfo(let id):
            return "/v1/users/\(id)"
        case .getStudentLocations:
            return "/v1/StudentLocation"
        case .postLocation:
            return "/v1/StudentLocation"
            
        }
    }
    
    var method: String {
        switch self {
        case .getSessionId, .postLocation:
            return "POST"
        case .deleteSessionId :
            return "DELETE"
        case .getUserInfo, .getStudentLocations :
            return "GET"
            
        }
    }
    
    
    var query : [URLQueryItem] {
        switch self {
            
        case .getStudentLocations:
            return [URLQueryItem(name: "order", value: "-updatedAt"),
                    URLQueryItem(name: "limit", value: "100")
            ]
        case .getSessionId, .deleteSessionId, .getUserInfo, .postLocation :
            return []
        }
    }
    
}


