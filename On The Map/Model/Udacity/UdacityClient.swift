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
    var userID : Int? = nil
    
    override init() {
        super.init()
    }
    
    func taskMethod(_ url: String, httpMethod : String, method : String, httpHeaders : [String : String], completionHandler : @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: url + method)!)
        request.httpMethod = httpMethod
        
        for (key, value) in httpHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else { // Handle error…
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
        
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
        
        
        
    }
    
    
    
    
}
