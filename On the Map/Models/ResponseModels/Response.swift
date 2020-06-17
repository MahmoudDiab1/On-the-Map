//
//  File.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

      struct Account: Decodable {
          var registered: Bool
          var key: String
      }
      
      struct Session: Codable {
          var id: String
          var expiration: String
      }


   struct Auth:  Decodable {
          var account: Account
          var session: Session
      }
      
//;;;;;;;;;;;;



struct UserInformation : Codable {
    let first_name : String
    let last_name : String
    let key : String

}
