//
//  MHHeroListViewModel.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/12.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHHeroListViewModel: NSObject {
    var offset:UInt32 = 0
    var limit:UInt32 = 20
    var total:UInt32 = 0
    
    var nameFilter:String = ""
    
    //data source for heros list
    var arrayHeros:[MHCharacterModel] = []
    
    func loadHerosWithCompletionHandler(handler:@escaping ((Bool,String?)->Void))->Void {
        let charactersApi = MHCharactersApi()
        charactersApi.offset = "\(self.offset)"
        charactersApi.limit = "\(self.limit)"
        charactersApi.name = self.nameFilter
        charactersApi.requestWithCompletedHandler(responseHandler: {(data: Data?, response: URLResponse?, error: String?) in
            
            if (error == nil) {
                var jsonData: NSDictionary?
                
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    // parse json data payload
                    //print("jsonData:\(String(describing: jsonData))")
                    if let data = jsonData?["data"] as? NSDictionary {
                        let arrayResults:[MHCharacterModel] = self.parseJSONData(jsonData: data)
                        //data fetched for load more
                        if self.offset > 0 {
                            self.arrayHeros = self.arrayHeros + arrayResults
                        } else {
                            //data fetched for reload first page
                            self.arrayHeros.removeAll()
                            self.arrayHeros = arrayResults
                        }
                    }
                    
                    handler(true, nil)
                }
                catch let err as NSError {
                    
                    handler(false, err.localizedDescription)
                }
            } else {
                handler(false, error)
            }
            
            
        })
    }
    
    func parseJSONData(jsonData:NSDictionary?)->[MHCharacterModel] {
        
        var arr:[MHCharacterModel] = []
        
        //validate json data
        guard let payload = jsonData as? [String : Any] else {
            return arr
        }
        guard let results = payload["results"] as? [NSDictionary] else {
            return arr
        }
        
        if let totalCount = payload["total"] as? UInt32 {
            self.total = totalCount
        }
        
        
        for characterDic in results {
            let character:MHCharacterModel = MHCharacterModel()
            
            
            //validate data
            guard let id = characterDic["id"] as? UInt32 else {
                continue
            }
            guard let modifiedString = characterDic["modified"] as? String else {
                continue
            }
            
            guard let nameString = characterDic["name"] as? String else {
                continue
            }
    
            character.id = "\(id)"
            character.modifiedDate = modifiedString
            character.name = nameString
            
            //check thumbnail
            if let thumbnail = characterDic["thumbnail"] as? [String:Any] {
                 character.thumbnailPath = thumbnail["path"] as? String  ?? ""
                 character.thumbnailExtension = thumbnail["extension"] as? String  ?? ""
            }
           
            //check description
            if let description = characterDic["description"] as? String {
                character.characterDescription = description
            }
            
            arr.append(character)
            
        }
        return arr
    }
    
}
