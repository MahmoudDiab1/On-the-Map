//
//  UserClient.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Class Responsbility: Responsible for handling all functions related to location ( Getting ordered location - posting user location)

class LocationClient {
    
    class func getLocationsOrdered(completion: @escaping(Result<[Location],Error>)->()) {
        NetworkEngine.fetch(with: udacityEndPoint.getStudentLocations) { (locations:Result<[Location], Error>) in
            DispatchQueue.main.async {
                   completion(locations) 
            }
        }
    }
    
    class func postUserLocation(userLocationData: Location,completion: @escaping(Result<LocationResponse?,Error>)->()) {
        NetworkEngine.post(with: udacityEndPoint.postLocation, body: userLocationData) { (result:Result<LocationResponse?, Error>) in
            completion(result)
        }
    }
}

