//
//  Endpoint.swift
//  Seen
//
//  Created by mahmoud diab on 5/5/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

protocol Endpoint
{
    var base:String{get}
    var path:String{get}
   
}
extension Endpoint
{
    var urlComponents:URLComponents {
        
        urlComponents.base=base
        urlComponents.path=path
        
    }
}
var urlComponents: URLComponents? {
       guard var components = URLComponents(string: base) else { return nil }
       components.path = path
       return components
   }
   var request: URLRequest? {
       guard let url = urlComponents?.url ?? URL(string: "\(self.base)\(self.path)") else { return nil }
       let request = URLRequest(url: url)
       return request
   }
