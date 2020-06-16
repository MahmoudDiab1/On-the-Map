//
//  Account.swift
//  On the Map
//
//  Created by mahmoud diab on 6/15/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//
//let udacity = [userData]()
struct userData : Encodable {
    let userName:String
    let password:String
    
    enum CodingKeys: String, CodingKey {
       case userName = "username"
       case password
    }
}
