//
//  File.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

      struct account: Decodable {
          var registered: Bool
          var key: String
      }
      
      struct session:  Decodable {
          var id: String
          var expiration: String
      }


   struct Auth:  Decodable {
          var account: account
          var session: session
      }
      
//;;;;;;;;;;;;

 
   

struct UserInformation : Codable {
    let first_name : String
    let last_name : String
    let key : String

}
