//
//  File.swift
//  On the Map
//
//  Created by mahmoud diab on 6/16/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
 
//MARK:- Enum responsbility: Encapsulate Generic types.
enum Result <T,U> where U:Error {
    case success(T)
    case failed(U)
}

//MARK:- Class Responsbility: Encapsulate Generic functions like post - fetch used by other functions in network layer.
class NetworkEngine {
    
    //    Generic post request
    
    class func post< ResponseModel:Decodable, RequestType:Encodable>(with endPoint:EndPoint, body:RequestType, completion : @escaping(Result<ResponseModel?,Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.path = endPoint.path
        guard let urlString = components.url  else {return}
        var urlRequest = URLRequest(url: urlString)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        } catch let error {
            print(error.localizedDescription)
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = endPoint.method
        print(urlRequest)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard var data = data else {
                DispatchQueue.main.async { completion(.failed(error!))  }
                return
            }
            if components.path.contains("session") {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            do {
                let dataObject = try JSONDecoder().decode(ResponseModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataObject))
                    print("_________dataObject\(dataObject)")
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failed(error))
                }
            }
        }
        task.resume()
    }
    
    
    //    Generic get Request
    class func fetch< ResponseModel:Decodable>(with endPoint:EndPoint, completion : @escaping(Result<ResponseModel,Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.path = endPoint.path
        components.queryItems = endPoint.query
        guard let urlString = components.url  else {return}
        var urlRequest = URLRequest(url: urlString)
        urlRequest.httpMethod = endPoint.method
        print("____urlRequest \(urlRequest)")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard var data = data else {
                DispatchQueue.main.async { completion(.failed(error!))  }
                return
            }
            if components.path.contains("users") {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            do {
                let dataObject = try JSONDecoder().decode(ResponseModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataObject))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failed(error))
                }
            }
        }
        task.resume()
    }
    
}




























