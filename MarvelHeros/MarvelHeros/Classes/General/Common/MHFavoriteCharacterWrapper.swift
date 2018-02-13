//
//  MHFavoriteCharacterWrapper.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

//for simplicity, just store favatite records id into a  plist file

class MHFavoriteCharacterWrapper:NSObject {
    
    let favoritesFileName = "favorites.plist"
    var favoritesRecords:NSMutableArray = NSMutableArray(capacity: 0)
    
    
    
    //use a global singleton to store and sync favorite data
    class var sharedInstance:MHFavoriteCharacterWrapper {
        
        struct Singleton {
            static let instance = MHFavoriteCharacterWrapper()
            //check to load persistented favorite records
            
        }
         //check to load persistented favorite records
        if FileManager.default.fileExists(atPath:  Singleton.instance.getDocumentFolder().appendingPathComponent(Singleton.instance.favoritesFileName)) == true {
            Singleton.instance.favoritesRecords = NSMutableArray(contentsOfFile: Singleton.instance.getDocumentFolder().appendingPathComponent(Singleton.instance.favoritesFileName)) ?? NSMutableArray(capacity: 0)
        }
        return Singleton.instance
    }
    
    //add favorite records
    func addFavoriteCharacter(characterId:String) {
        
        
        self.favoritesRecords.add(characterId)
        self.favoritesRecords.write(toFile: self.getDocumentFolder().appendingPathComponent(self.favoritesFileName), atomically: true)
    }
    
    //remove
    func removeFavoriteCharacter(characterId:String) {
        for record in  self.favoritesRecords {
            if let id = record as? String {
                if id == characterId {
                    self.favoritesRecords.remove(record)
                    self.favoritesRecords.write(toFile: self.getDocumentFolder().appendingPathComponent(self.favoritesFileName), atomically: true)
                    break
                }
            }
            
        }
        
    }
    
    
    //check
    func checkIsFavoriteCharacter(characterId:String) -> Bool {
        
        var flag:Bool = false
        for record in  self.favoritesRecords {
            if let id = record as? String {
                if id == characterId {
                    flag = true
                    break
                }
            }
            
        }
        
        return flag
    }
    
    //get local folde for storing image
    func getDocumentFolder()->NSString {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        
        return docPath
    }
    
}

