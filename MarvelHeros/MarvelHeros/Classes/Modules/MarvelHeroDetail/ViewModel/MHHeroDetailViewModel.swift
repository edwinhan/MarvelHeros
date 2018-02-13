//
//  MHHeroDetailViewModel.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHHeroDetailViewModel: NSObject {

    //detail data model a  specific character
    var detailModel:MHCharacterDetailModel = MHCharacterDetailModel()
    
    
    
    func loadCharacterComicsWithCompletionHandler(handler:@escaping ((Bool,String?)->Void))->Void {
        let comicsApi = MHCharacterComicsApi()
        comicsApi.characterId = self.detailModel.characterModel?.id ?? ""
        if comicsApi.characterId == "" {
            handler(false, "Character Id must't be null")
        }
        comicsApi.requestWithCompletedHandler(responseHandler: {(data: Data?, response: URLResponse?, error: String?) in
            
            if (error == nil) {
                var jsonData: NSDictionary?
                
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    // parse json data payload
                    print("jsonData:\(String(describing: jsonData))")
                    if let data = jsonData?["data"] as? NSDictionary {
                        
                        self.parseComicsJSONData(jsonData: data)
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
    
    func loadCharacterSeriesWithCompletionHandler(handler:@escaping ((Bool,String?)->Void))->Void {
        let seriesApi = MHCharacterSeriesApi()
        seriesApi.characterId = self.detailModel.characterModel?.id ?? ""
        if seriesApi.characterId == "" {
            handler(false, "Character Id must't be null")
        }
        seriesApi.requestWithCompletedHandler(responseHandler: {(data: Data?, response: URLResponse?, error: String?) in
            
            if (error == nil) {
                var jsonData: NSDictionary?
                
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    // parse json data payload
                    //print("jsonData:\(String(describing: jsonData))")
                    if let data = jsonData?["data"] as? NSDictionary {
                        
                        self.parseSeriesJSONData(jsonData: data)
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
    
    
    func loadCharacterStoriesWithCompletionHandler(handler:@escaping ((Bool,String?)->Void))->Void {
        let storiesApi = MHCharacterStoriesApi()
        storiesApi.characterId = self.detailModel.characterModel?.id ?? ""
        if storiesApi.characterId == "" {
            handler(false, "Character Id must't be null")
        }
        storiesApi.requestWithCompletedHandler(responseHandler: {(data: Data?, response: URLResponse?, error: String?) in
            
            if (error == nil) {
                var jsonData: NSDictionary?
                
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    // parse json data payload
                    //print("jsonData:\(String(describing: jsonData))")
                    if let data = jsonData?["data"] as? NSDictionary {
                        
                        self.parseStoriesJSONData(jsonData: data)
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
    
    
    func loadCharacterEventsWithCompletionHandler(handler:@escaping ((Bool,String?)->Void))->Void {
        let eventsApi = MHCharacterEventsApi()
        eventsApi.characterId = self.detailModel.characterModel?.id ?? ""
        if eventsApi.characterId == "" {
            handler(false, "Character Id must't be null")
        }
        eventsApi.requestWithCompletedHandler(responseHandler: {(data: Data?, response: URLResponse?, error: String?) in
            
            if (error == nil) {
                var jsonData: NSDictionary?
                
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    // parse json data payload
                    print("jsonData:\(String(describing: jsonData))")
                    if let data = jsonData?["data"] as? NSDictionary {
                        
                        self.parseEventsJSONData(jsonData: data)
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
    
    
    func parseComicsJSONData(jsonData:NSDictionary?) {
        
        //validate json data
        guard let payload = jsonData as? [String : Any] else {
            return
        }
        guard let results = payload["results"] as? [NSDictionary] else {
            return
        }
        
       detailModel.arrayComics.removeAll()
        
        
        for comicsDic in results {
            let comics:MHCharacterComicsModel = MHCharacterComicsModel()
            
            
            //validate data
            guard let title = comicsDic["title"] as? String else {
                continue
            }
            guard let description = comicsDic["description"] as? String else {
                continue
            }
            
            
            
            comics.itemName = title
            comics.itemDescription = description
            
            detailModel.arrayComics.append(comics)
            
        }
    }
    
    
    func parseSeriesJSONData(jsonData:NSDictionary?) {
        
        //validate json data
        guard let payload = jsonData as? [String : Any] else {
            return
        }
        guard let results = payload["results"] as? [NSDictionary] else {
            return
        }
        
        detailModel.arraySeries.removeAll()
        
        
        for dic in results {
            let series:MHCharacterSeriesModel = MHCharacterSeriesModel()
            
            
            //validate data
            guard let title = dic["title"] as? String else {
                continue
            }
            guard let description = dic["description"] as? String else {
                continue
            }
            
            
            
            series.itemName = title
            series.itemDescription = description
            
            detailModel.arraySeries.append(series)
            
        }
    }
    
    
    func parseStoriesJSONData(jsonData:NSDictionary?) {
        
        //validate json data
        guard let payload = jsonData as? [String : Any] else {
            return
        }
        guard let results = payload["results"] as? [NSDictionary] else {
            return
        }
        
        detailModel.arrayStories.removeAll()
        
        
        for dic in results {
            let stories:MHCharacterStoriesModel = MHCharacterStoriesModel()
            
            
            //validate data
            guard let title = dic["title"] as? String else {
                continue
            }
            guard let description = dic["description"] as? String else {
                continue
            }
            
            
            
            stories.itemName = title
            stories.itemDescription = description
            
            detailModel.arrayStories.append(stories)
            
        }
    }
    
    func parseEventsJSONData(jsonData:NSDictionary?) {
        
        //validate json data
        guard let payload = jsonData as? [String : Any] else {
            return
        }
        guard let results = payload["results"] as? [NSDictionary] else {
            return
        }
        
        detailModel.arrayEvents.removeAll()
        
        
        for dic in results {
            let events:MHCharacterEventsModel = MHCharacterEventsModel()
            
            
            //validate data
            guard let title = dic["title"] as? String else {
                continue
            }
            guard let description = dic["description"] as? String else {
                continue
            }
            
            
            
            events.itemName = title
            events.itemDescription = description
            
            detailModel.arrayEvents.append(events)
            
        }
    }
}
