//
// Locations.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

struct Locations: Codable {
    var results: [StudentInformation ]
}
//student information class
struct StudentInformation : Codable {
    var firstName:String
    var lastName: String
    var latitude:Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    let uniqueKey:String
    
    static var studentLocation = StudentInformation ( firstName: "", lastName: "", latitude: 0.0, longitude: 0.0, mapString: "", mediaURL:"",uniqueKey: "")
}

struct LocationResponse: Decodable {
    let createdAt, objectID: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectID = "objectId"
    }
}


struct StudentTableData {
    var studentName: String
    var studentURL: String
    static var student = [StudentTableData]()
}
