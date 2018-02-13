//
//  MHCharacterDetailApi.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHCharacterDetailApi: MHBaseApi {
    var id:String = ""
    
    override func requestMethod()-> MHHttpMethod {
        return MHHttpMethod.GET
    }
    
    override func requestUrl() -> String {
        
        return "/v1/public/characters/\(id)?"
        
    }
}
