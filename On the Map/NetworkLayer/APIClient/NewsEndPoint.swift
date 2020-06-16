    //
    //  NewsEndPoint.swift
    //  Assesment
    //
    //  Created by mahmoud diab on 5/10/20.
    //  Copyright © 2020 Diab. All rights reserved.
    //
    
    import Foundation
    
    enum NewsEndPoint:EndPoint
    {
        case getSearshResults(searchText:String)
        case getTopHeadlines
    }
    extension NewsEndPoint
    {
        var schema: String{
            switch self{
            default:
                return"https"
            }
        }
        
        var base: String{
            switch self{
            default:
                return "newsapi.org"
            }
        }
        
        var path: String{
            switch self {
            case .getSearshResults:
                return "/v2/everything"
            case .getTopHeadlines:
                return "/v2/top-headlines"
            }
        }
        var parameters: [URLQueryItem]{
            switch self {
            case .getSearshResults(let searchText):
                return[URLQueryItem(name: "apiKey", value:"1a779402052e4290838adc06ecd31d37"),
                       URLQueryItem(name: "q", value: searchText)]
            case .getTopHeadlines:
                return [URLQueryItem(name: "apiKey", value: "1a779402052e4290838adc06ecd31d37")]
            }
        }
        
        var method: String{
            switch self {
            case .getSearshResults:
                return "GET"
            case .getTopHeadlines:
                  return "GET"
            }
        }
        
        
    }
