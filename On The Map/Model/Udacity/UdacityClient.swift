//
//  UdacityClient.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation

class UdacityClient : NSObject{
    
    // shared session
    var session = URLSession.shared
    
    
    // authentication state
    var sessionID : String? = nil
    var userKey : String? = nil
    
    override init() {
        super.init()
    }
    
    func taskMethod(_ url: String, httpMethod : String, method : String, httpHeaders : [String : String], httpBody : String = "", completionHandler : @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: url + method)!)
        request.httpMethod = httpMethod
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        
        for (key, value) in httpHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else { // Handle error…
                sendError("There was an error with your request: \(error!)")
                return
            }
//            print(String(data: data!, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("No go with the info, try again. Looking for 200 to continue.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("Hmmmn we received NO DATA!!!! Only panic a little and try again.")

                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            completionHandler(newData as AnyObject, nil)
        
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
        
        
        
    }
    
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> String {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!.absoluteString
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
