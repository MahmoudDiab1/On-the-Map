//
//  NetworkEngine.swift
//  Assesment
//
//  Created by mahmoud diab on 5/10/20.
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

class NetworkEngine
{
    /// excutes web calls  and will decode the  json response to codable object provided
    /// -Parameters
    // endpoint : The request of type Endpoint to make a request against
    // completion : Json object decoded to codable type if success and error in case failure

    // 1
    func fetch <T:Decodable>(with endpoint:EndPoint,completion:@escaping(Result<T,APIError>)->Void )
    {
        //2
        var components=URLComponents()
        components.scheme=endpoint.schema
        components.host=endpoint.base
        components.path=endpoint.path
        components.queryItems=endpoint.parameters
        
        //3
        guard let url=components.url else { return }
        //4
        var request=URLRequest(url:url)
        request.httpMethod=endpoint.method
        print(request)

        //5
        let session=URLSession(configuration: .default)
        let dataTask=session.dataTask(with: request){data,response,error in
            
            //6
            guard error == nil
            else{
                completion(.failure(.errorValue(description: "1")))
              
                return
                }
            guard response != nil , let data = data
            else{
                completion(.failure(.errorValue(description: "2")))
                return
                }
            
            DispatchQueue.main.async {
              if let genericModel = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(genericModel))
              }
              else {
                completion(.failure(.decodingTaskFailure(description: "3")))
                }
            }
        }
//8
        dataTask.resume()
    }
    
    
    
    

}

