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
        let url = URL(string: urlString)
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
    
    
    
    
    
    
}
