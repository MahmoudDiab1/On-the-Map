//
//  Request.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
struct Udacity: Encodable {
    let udacity: User
}
struct User: Encodable {
    let username: String
    let password: String
}
