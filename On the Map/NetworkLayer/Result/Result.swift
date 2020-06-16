//
//  Result.swift
//  Seen
//
//  Created by mahmoud diab on 5/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//use enum to declare two cases (data recieved successfully it should be generic type to contain any response model)
//and (Error in case of recieving error instead of data response) it should be of any type that must implment Error protocol) //APIERRor
enum Result <T,U> where U:Error
{
    case success(T)
    case failure(U)
}


