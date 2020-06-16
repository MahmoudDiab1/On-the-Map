//
//  NewsClient.swift
//  Seen
//
//  Created by mahmoud diab on 5/8/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation




class NewsClient:GenericAPIClient
{
    var session: URLSession
    
    init(session:URLSession) {
        self.session=session
    }
    convenience init(session) {
        session=session(c)
    }
    
    func getnews(url:URLRequest,completion:@escaping(Result<Sources:APIRrror>)->Void)
    {
    
        fetch(url: url, model: Sources.self,completion:com
    }
   
}
