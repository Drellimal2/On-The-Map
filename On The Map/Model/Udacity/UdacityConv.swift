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
        
        let JSONBodyDictionary = [ UdacityClient.JSONParamKeys.Udacity : [
            UdacityClient.JSONParamKeys.Username : username as AnyObject,
                UdacityClient.JSONParamKeys.Password : password as AnyObject
            ] as AnyObject
        ]
        
        let JSONBodyString = dictionaryToJSONString(JSONBodyDictionary)
        
        
        let httpHeaders : [String:String] = [
            UdacityClient.HeaderFields.Accept : UdacityClient.HeaderValues.ContentTypeJSON,
            UdacityClient.HeaderFields.ContentType : UdacityClient.HeaderValues.ContentTypeJSON
        ]
        
        let _ = taskMethod(url, httpMethod: httpMethod, method: UdacityClient.Constants.SessionMethod, httpHeaders: httpHeaders, httpBody: JSONBodyString, completionHandler: { (data, error) in
            
            
            guard error == nil else{
                return
            }
            
            guard let ndata = data else {
                return
            }
            
            let parsedResult : AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: ndata as! Data, options: .allowFragments) as AnyObject
                
            } catch {
                print("Could not parse Json")
                return
            }
            
            guard let account = parsedResult[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
                print("Could not retrieve account")
                return
            }
            
            guard let account_key = account[UdacityClient.JSONResponseKeys.Account_Key] as? String else {
                print("Could not retrieve account key")
                return
            }
            
            UdacityClient.sharedInstance().userKey = account_key
            
            guard let session = parsedResult![UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] else {
                print("Could not retrieve session")
                return
            }
            
            guard let sess_id = session[UdacityClient.JSONResponseKeys.Session_ID] as? String else {
                print("Could not retrieve session id")
                return
            }
            
            UdacityClient.sharedInstance().sessionID = sess_id

            
            
            print(UdacityClient.sharedInstance().sessionID)
  
        })
        
        
            
        
        
        
    }
    
    
    
}
