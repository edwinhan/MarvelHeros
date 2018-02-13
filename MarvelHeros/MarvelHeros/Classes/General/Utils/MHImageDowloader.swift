//
//  MHImageDowloader.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHImageDowloader: NSObject {
    
    //get local folde for storing image
    class func getImageFolder()->NSString {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        
        return docPath
    }
    
    //load image from local, if not exists, download image from url
    class func loadImage(imageName:String,imageUrl:String,completionHandler:@escaping ((UIImage?)->Void))->Void {
        
        //check to load image from local cache
        if FileManager.default.fileExists(atPath:  MHImageDowloader.getImageFolder().appendingPathComponent(imageName)) {
            if let image:UIImage = UIImage(contentsOfFile: MHImageDowloader.getImageFolder().appendingPathComponent(imageName)) {
                completionHandler(image)
            } else {
                completionHandler(UIImage(named: "imageNotFound.jpg"))
            }
             
        } else {
            //load image from url if image dosen't cached
            DispatchQueue.global().async {
                do {
                    if let url = URL(string: imageUrl) {
                        let data:NSData = try NSData(contentsOf: url)
                        
                        //cache file
                        data.write(toFile: MHImageDowloader.getImageFolder().appendingPathComponent(imageName), atomically: true)
                        let image = UIImage(data: data as Data)
                        DispatchQueue.main.sync() {
                            
                            completionHandler(image)
                        }
                    }
                    
                    
                } catch {
                    //TODO: show error message
                    DispatchQueue.main.sync() {
                        
                        completionHandler(UIImage(named: "imageNotFound.jpg"))
                    }
                }
                
                
            }

        }
        
    }
    
}
