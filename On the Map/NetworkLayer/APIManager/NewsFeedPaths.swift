
//
//  NewsFeed.swift
//  Seen
//
//  Created by mahmoud diab on 5/8/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation


enum NewsFeed
{
    case topHeadLines
    case Everything
    case Sources
        
}
extension NewsFeed:EndPoint
{
    var base:String{
        return "https://newsapi.org"
    }
    var path:String{
        switch self
        {
        case .topHeadLines:
            return "/v2/top-headlines"
        case .Everything:
            return "/v2/everything"
        case .Sources:
            return "/v2/sources"
        }
    }
}

