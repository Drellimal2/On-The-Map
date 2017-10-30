//
//  UdacityConv.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginPostSession(username : String, password : String){
        let url = UdacityClient.Constants.BaseURL
        let httpMethod = "POST"
        let httpHeaders : [String:String] = [
            UdacityClient.HeaderFields.Accept : UdacityClient.HeaderValues.ContentTypeJSON,
            UdacityClient.HeaderFields.ContentType : UdacityClient.HeaderValues.ContentTypeJSON
        ]
        
        let _ = taskMethod(url, httpMethod: httpMethod, method: UdacityClient.Constants.SessionMethod, httpHeaders: httpHeaders, completionHandler: { (data, error) in
                            
            if error == nil {
                print(data!)
            }
            
            
            
        })
        
        
            
        
        
        
    }
    
    
    
}
