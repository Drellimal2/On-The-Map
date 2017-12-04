//
//  ParseConv.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation


extension ParseClient {
    
    
    func getLocations(controllerCompletionHandler : @escaping (_ result: [StudentInformation]?, _ error: String?) -> Void){
        let params = [
            ParseClient.JSONParamKeys.Limit : 100,
            ParseClient.JSONParamKeys.Order : "-" + ParseClient.JSONParamKeys.UpdatedAt
            ] as [String : Any]
        
        let urlString = parseURLFromParameters(params)
        let httpMethod = "GET"
        
        let _ = taskMethod(urlString, httpMethod: httpMethod, httpHeaders: [:], httpBody: "", completionHandler: { (data, error) in
            
            
           
            
            guard let result = data![JSONResponseKeys.Results] as? [[String:AnyObject]]  else {
                print("Could not retrieve results")
                controllerCompletionHandler(nil, "Could not retrieve results" )
                return
            }
            
            
            let res = StudentInformation.studentsFromResults(result)
            controllerCompletionHandler(res, nil)
            
        })
        
   
    }
    
    func getLocation(uniqueKey: String, olddata : [String:AnyObject] = [:], controllerCompletionHandler : @escaping (_ result: AnyObject?, _ error: String?) -> Void){
        let params = [
            "where" : dictionaryToJSONString([ParseClient.JSONParamKeys.UniqueKey : uniqueKey as AnyObject])
            ] as [String : Any]
        
        let urlString = parseURLFromParameters(params)
        let httpMethod = "GET"
        
        let _ = taskMethod(urlString, httpMethod: httpMethod, httpHeaders: [:], httpBody: "", completionHandler: { (data, error) in
            
            guard let result = (data)![JSONResponseKeys.Results] as? [[String:AnyObject]]  else {
                print("Could not retrieve previously posted location")
                controllerCompletionHandler(nil, "Could not retrieve previously posted location" )
                return
            }
            
            var ddata = olddata
//            let res = StudentInformation.studentsFromResults(result)
            if result.count > 0{
                ddata[ParseClient.JSONResponseKeys.ObjectID] = result[0][ParseClient.JSONResponseKeys.ObjectID]
            }
            controllerCompletionHandler(ddata as AnyObject, nil)
            
        })
        
        
    }
    
    
    func addLocation(body : [String : AnyObject], update : Bool = false, objectid : String = "", controllerCompletionHandler : @escaping (_ result: AnyObject?, _ error: String?) -> Void){
    
        
        let url = ParseClient.Constants.BaseURL
        let httpMethod : String
        var method = ""
        if update {
            httpMethod = "PUT"
            method = "/" + objectid
            
        }else {
            httpMethod = "POST"
        }
        
        
        
        let JSONBodyString = dictionaryToJSONString(body)
        print(JSONBodyString)
        let httpHeaders = [HeaderFields.ContentType : HeaderValues.ContentTypeJSON]
        
        let _ = taskMethod(url, httpMethod: httpMethod, method: method, httpHeaders: httpHeaders, httpBody: JSONBodyString, completionHandler: { (data, error) in
        
        
            guard error == nil else{
                print("errr")
                controllerCompletionHandler(nil, error!.localizedDescription)
                return
            }
            
            guard let ndata = data else {
                controllerCompletionHandler(nil, "Oops looks like we did not get a confirmation of the post." )
                return
            }
            
            
            var ddata : [String:AnyObject] = [
                "success" : true as AnyObject
            ]
            if !update {
                let objId = ndata[JSONResponseKeys.ObjectID] as! String
                ddata[JSONResponseKeys.ObjectID] = objId as AnyObject
            }
            
            controllerCompletionHandler(ddata as AnyObject, nil)
        
        
        })
  
    }
}
