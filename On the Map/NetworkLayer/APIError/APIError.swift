 //
 //  APIError.swift
 //  Assesment
 //
 //  Created by mahmoud diab on 5/10/20.
 //  Copyright © 2020 Diab. All rights reserved.
 //

 import Foundation

 enum APIError:Error{
     case errorValue (description:String?)
     case responseUnsuccessful(description: String?)
     case decodingTaskFailure(description: String?)
     case requestFailed(description: String?)
     case jsonConversionFailure(description: String?)
     case postParametersEncodingFalure(description: String?)
     
    
     var errorDescription:String{
         switch self
         {
         case .errorValue(let description):
             return "Error value response - response with error -> description : \(description ?? "No description ")"
         case .requestFailed(let description):
             return "APIError - Request Failed -> description : \(description ?? "No description ")"
         case .responseUnsuccessful(let description):
             return "APIError - Response Unsuccessful status code ->  description : \(description ?? "No description ")"
         case .jsonConversionFailure(let description):
             return "APIError - JSON Conversion Failure ->  description : \(description ?? "No description ")"
         case .decodingTaskFailure(let description):
             return "APIError - decodingtask failure with error -> description : \(description ?? "No description ")"
         case .postParametersEncodingFalure(let description):
             return "APIError - post parameters failure -> description : \(description ?? "No description ")"
         }
     }
     
 }

          

