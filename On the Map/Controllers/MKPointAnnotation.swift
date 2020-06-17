//
//  Capital.swift
//  On the Map
//
//  Created by mahmoud diab on 6/15/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
import MapKit


class Capital : NSObject, MKAnnotation {
//    MKAnnotation is protocole that containt 3 items 1 is requiered to implement (coordinate) of type       CLLocationCoordinate2D and other 2 items is optional to implement ..title and info of type String.
    var title:String?
    var info:String
    var coordinate:CLLocationCoordinate2D
    
    init(title:String,info:String,coordinate:CLLocationCoordinate2D)  {
        
        self.title = title
        self.info = info
        self.coordinate =  coordinate
        
    }
    
}
