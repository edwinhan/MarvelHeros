//
//  MHCharactersApi.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/12.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHCharactersApi: MHBaseApi {
    var orderBy:String = "-modified"
    var limit:String = "20"
    var offset:String = "0"
    var name:String = ""
    override func requestMethod()-> MHHttpMethod {
        return MHHttpMethod.GET
    }
    
    override func requestUrl() -> String {
        var parameter:String = "orderBy=\(orderBy)&limit=\(limit)&offset=\(offset)"
        if(name != "") {
            parameter = "nameStartsWith=\(name)&\(parameter)"
        }
        
        return "/v1/public/characters?\(parameter)"
        
    }
    
}
