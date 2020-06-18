//
// Account.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

struct Account: Decodable {
    var registered: Bool
    var key: String

    static var account = Account(registered: false, key: "")
}
struct Session: Codable {
    var id: String
    var expiration: String
    static var loggedSession = Session(id:"", expiration:"")
}
struct Auth:  Decodable {
    var account: Account
    var session: Session
}
struct UserInformation : Codable {
    let firstName : String
    let lastName : String
    let key : String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName  = "first_name"
        case key
    }
}
