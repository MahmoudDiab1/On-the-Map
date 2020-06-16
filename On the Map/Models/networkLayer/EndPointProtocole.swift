//
//  EndPointProtocole.swift
//  On the Map
//
//  Created by mahmoud diab on 6/15/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

protocol  EndPoint { 
    var scheme:String{get}
    var path:String{get}
    var host:String{get}
    var method:String{get} 
}
  
