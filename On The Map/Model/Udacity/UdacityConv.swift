//
//  UdacityConv.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginPostSession(username : String, password : String, controllerCompletionHandler : @escaping (_ result: AnyObject?, _ error: String?) -> Void){
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
                print("errr")
                controllerCompletionHandler(nil, error!.localizedDescription)
                return
            }
            
            guard let ndata = data else {
                controllerCompletionHandler(nil, "Oops looks like we asked for a session id but didnt get any. Such is life sometimes just have to try again." )
                return
            }
            
            let parsedResult : AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: ndata as! Data, options: .allowFragments) as AnyObject
                
            } catch {
                print("Could not parse session Json")
                controllerCompletionHandler(nil, "Could not parse Json" )

                return
            }
            
            guard let account = parsedResult[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
                print("Could not retrieve account")
                controllerCompletionHandler(nil, "Could not retrieve account" )

                return
            }
            
            guard let account_key = account[UdacityClient.JSONResponseKeys.Account_Key] as? String else {
                print("Could not retrieve account key")
                controllerCompletionHandler(nil, "Could not retrieve retrieve account key" )

                return
            }
            
            UdacityClient.sharedInstance().userKey = account_key
            
            guard let session = parsedResult![UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] else {
                print("Could not retrieve session")
                controllerCompletionHandler(nil, "Could not retrieve session" )
                return
            }
            
            guard let sess_id = session[UdacityClient.JSONResponseKeys.Session_ID] as? String else {
                print("Could not retrieve session id")
                controllerCompletionHandler(nil, "Could not retrieve  session id" )

                return
            }
            
            self.sessionID = sess_id

            let ddata : [String: Any] = [
                Consts.session_id : sess_id,
                Consts.user_id : account_key
            
            ]
            //controllerCompletionHandler(ddata as AnyObject, nil)
            self.getUserDetails(userID: account_key, olddata: ddata, controllerCompletionHandler: controllerCompletionHandler)
            
  
        })
    }
    
    func getUserDetails(userID: String, olddata : [String: Any], controllerCompletionHandler : @escaping (_ result : AnyObject?, _ errorMessage : String?) -> Void){
        
        
        let url = UdacityClient.Constants.BaseURL
        let httpMethod = "GET"
        
        
        
        let method = UdacityClient.Constants.UserMethod + userID
        let httpHeaders : [String:String] = [
            UdacityClient.HeaderFields.Accept : UdacityClient.HeaderValues.ContentTypeJSON,
            UdacityClient.HeaderFields.ContentType : UdacityClient.HeaderValues.ContentTypeJSON
        ]
        
        let _ = taskMethod(url, httpMethod: httpMethod, method: method, httpHeaders: httpHeaders, completionHandler: { (data, error) in
            
            
            guard error == nil else{
                print("errr")
                controllerCompletionHandler(nil, error!.localizedDescription)
                return
            }
            
            guard let ndata = data else {
                controllerCompletionHandler(nil, "Oops looks like we asked for user data but didnt get any. Such is life sometimes just have to try again." )
                return
            }
            
            let parsedResult : AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: ndata as! Data, options: .allowFragments) as AnyObject
                
            } catch {
                print("Could not parse User Data Json")
                controllerCompletionHandler(nil, "Could not parse Json" )
                
                return
            }
            
           
            let newdata = parsedResult[JSONResponseKeys.User] as! [String: AnyObject]
            var ddata = olddata
            ddata[Consts.first_name]  = newdata[JSONResponseKeys.FirstName] as! String
            ddata[Consts.last_name] = newdata[JSONResponseKeys.LastName] as! String
            
            ParseClient.sharedInstance().getLocation(uniqueKey: ddata[Consts.user_id] as! String, olddata: ddata as [String : AnyObject], controllerCompletionHandler: controllerCompletionHandler)
            //controllerCompletionHandler(ddata as AnyObject, nil)

        })
   
    }
    
    func removeSession(sessionID: String,  controllerCompletionHandler : @escaping (_ result : AnyObject?, _ errorMessage : String) -> Void){
        
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        var httpHeaders : [String:String] = [
            UdacityClient.HeaderFields.Accept : UdacityClient.HeaderValues.ContentTypeJSON,
            UdacityClient.HeaderFields.ContentType : UdacityClient.HeaderValues.ContentTypeJSON
        ]
        
        if let xsrfCookie = xsrfCookie {
            httpHeaders[HeaderFields.XSRFToken] = xsrfCookie.value
            
        }
        
        let url = UdacityClient.Constants.BaseURL
        let httpMethod = "DELETE"
        
        
        let _ = taskMethod(url, httpMethod: httpMethod, method: UdacityClient.Constants.SessionMethod, httpHeaders: httpHeaders, completionHandler: { (data, error) in
            
            
            guard error == nil else{
                print("errr")
                controllerCompletionHandler(nil, error!.localizedDescription)
                return
            }
            
            guard let ndata = data else {
                controllerCompletionHandler(nil, "Oops looks like we asked for a session id but didnt get any. Such is life sometimes just have to try again." )
                return
            }
            
            let parsedResult : AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: ndata as! Data, options: .allowFragments) as AnyObject
                
            } catch {
                print("Could not parse logout Json")
                controllerCompletionHandler(nil, "Could not parse logout Json" )
                
                return
            }
            
            print(parsedResult)
            
            
            controllerCompletionHandler(parsedResult as AnyObject, "")
            
            
        })
    }
    
}
