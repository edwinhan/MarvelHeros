//
//  MHBaseApi.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/12.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

typealias MHRequestCompletedHandler = (_ data: Data?, _ response: URLResponse?, _ error: String?) -> Void

enum MHHttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

//string MD5 extension
extension String {
    var md5 : String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String(format: hash as String)
    }
}

class MHBaseApi: NSObject {
    var urlString:String = ""
    //unsigned integer for creating timeStamp
    var tsCounter:CC_LONG64 = 0
    
    //func for creating unsigned long timestamp
    func marvelTimeStamp () -> String {
        self.tsCounter = self.tsCounter + 1
        
        return String(format: "%lu",self.tsCounter)
    }
    
    //func for creating MD5 hash for marvel API
    func marvelMD5HashFromTimeStamp (ts:String) -> String {
        let str:String = ts + MHConstants.MH_MARVEL_PRIVATE_KEY + MHConstants.MH_MARVEL_PUBLIC_KEY
        return str.md5
    }
    
    //for quick print API detail info in console
    override var description: String {
        get {
            let argumentString : String = self.requestArgument() == nil ? "" : "\(self.requestArgument()!)"
            
            let request_description:String = "<\(self.classForCoder): {URL: \(self.urlString)}, \n {method: \(self.requestMethod())}, \n  {arguments: \(argumentString)}>"
            
            return request_description
        }
    }
    
    
    //ovverride this func to add additional headers if need
    func requestHeaderFieldValueDictionary () -> Dictionary<String,String>? {
        let headers = [
            "application/json": "content-Type",
            "UTF-8": "charset"
            ]
        return headers
    }
    
    //http method type, override this func to specify a new method
    func requestMethod()-> MHHttpMethod {
        return MHHttpMethod.POST
    }
    
    //ovverride this func toprovide new timeout interval if need
    func requestTimeOutInterval () -> TimeInterval {
        return 30
    }
    
    //ovverride this func to provide request url for a specific API
    func requestUrl() -> String {
        return ""
    }
    
    //ovverride this func to provide arguments for a specific API
    func requestArgument () -> Dictionary<String,String>? {
        return nil
    }
    
    //this function will combine all request info and send our request to fetch info
    func requestWithCompletedHandler(responseHandler:@escaping MHRequestCompletedHandler) {
        
        //format url
        urlString = MHConstants.MH_MARVEL_BASE_URL + self.requestUrl()
        
        //appending authorization emelments
        let ts:String = self.marvelTimeStamp()
    
        urlString = urlString + "&apikey=\(MHConstants.MH_MARVEL_PUBLIC_KEY)&hash=\(self.marvelMD5HashFromTimeStamp(ts: ts))&ts=\(ts)"
        
        if let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            
            // init basic request
            var request: URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: self.requestTimeOutInterval())
            
            // add http headers
            if let headers = self.requestHeaderFieldValueDictionary() {
                for header in headers {
                    request.addValue(header.key, forHTTPHeaderField: header.value)
                }
            }
            
            //set http method
            request.httpMethod = self.requestMethod().rawValue
            
            //set http body if there are any
            if let argument = self.requestArgument() {
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: argument, options: [])
                    request.httpBody = jsonData
                } catch {
                    //send error back
                    responseHandler(nil, nil, "\(error.localizedDescription)")
                }
            }
            
            
            //init url session
            let config: URLSessionConfiguration = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = self.requestTimeOutInterval()
            let urlSession =  URLSession(configuration: config)
            
            
            let task = urlSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                print("request: \(self.description)")
                print("response: \(String(describing: response))")
                print("error: \(String(describing: error?.localizedDescription))")
                if (error != nil) {
                    //send error back
                    responseHandler(nil, nil, "\(String(describing: error?.localizedDescription))")
                } else {
                    var errorMessage:String = ""
                    
                    if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                        // handle by status code
                        let statusCode: Int = httpResponse.statusCode
                        if (statusCode != 200 || data == nil) {
                            errorMessage = httpResponse.description
                        }
                        
                    } else {
                        errorMessage = "Server internal error"
                    }
                    
                    if (errorMessage == "") {
                        responseHandler(data!, response!, nil)
                    } else {
                        responseHandler(data, response, errorMessage)
                    }
                    
                }
                
                
            })
            
            //start request
            task.resume()
            
            
        }
        else {
            //send error back
            responseHandler(nil, nil, "Invalid URL: \(urlString)")
        }
    }
}
