//
//  ParseConv.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation


extension ParseClient {
    
    
    func getLocations(completionHandler : @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
        let params = [
            ParseClient.JSONParamKeys.Limit : 100,
            ParseClient.JSONParamKeys.Order : "-" + ParseClient.JSONParamKeys.UpdatedAt
            ] as [String : Any]
        
        let urlString = parseURLFromParameters(params)
        print(urlString)
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
}
