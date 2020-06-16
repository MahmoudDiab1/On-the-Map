//
//  headers.swift
//  Seen
//
//  Created by mahmoud diab on 5/8/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

enum headers
{
    case contentType(String)
    case Accept(String)
    case APIKey(String)
    
    var httpHeader:(field:String,value:String)
    {
        switch self
        {
        case .contentType(let contentType):
            return (field:"Content-type",value:contentType)
            
        case .Accept(let value):
            return(field:"Accept",value:value)
     
        case .APIKey(let key):
            return(field:"APIKey",value:key)
            
        }
    }
    
}
