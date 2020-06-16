//
//  EndPoint.swift
//  Assesment
//
//  Created by mahmoud diab on 5/10/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

protocol EndPoint {
    
//  schema HTTP or HTTPS
    var schema:String{get}
    
//  base EX:www.news.com
    var base:String{get}
    
//  path EX: /worldnews
    var path:String{get}
    
//  [ QueryItem(name:"api-key" , value:"API-Key"
    var parameters:[URLQueryItem]{get}
    
//  method EX: GET POST DELETE PUT
    var method:String{get}
}

