//
//  MHCharacterEventsApi.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHCharacterEventsApi: MHBaseApi {
    var characterId:String = ""
    var orderBy:String = "-modified"
    var limit:String = "3"
    var offset:String = "0"
    override func requestMethod()-> MHHttpMethod {
        return MHHttpMethod.GET
    }
    
    override func requestUrl() -> String {
        
        return "/v1/public/characters/\(characterId)/events?orderBy=\(orderBy)&limit=\(limit)&offset=\(offset)"
        
    }
}
