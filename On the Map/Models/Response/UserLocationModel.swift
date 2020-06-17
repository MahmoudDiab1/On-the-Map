//
//  userLocationModel.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
 
struct Locations: Codable {
    var results: [Location]
}

 
struct Location: Codable {
    let createdAt, firstName, lastName: String
    let latitude, longitude: Double
    let mapString: String
    let mediaURL: String
    let objectID, uniqueKey, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case createdAt, firstName, lastName, latitude, longitude, mapString, mediaURL
        case objectID = "objectId"
        case uniqueKey, updatedAt
    }
}

//MARK: struct for TableViewCell
struct StudentTableView {
    var studentName: String
    var studentURL: String
    
    static var student = [StudentTableView]()
}



struct LocationResponse: Decodable {
    let createdAt, objectID: String

    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectID = "objectId"
    }
}

