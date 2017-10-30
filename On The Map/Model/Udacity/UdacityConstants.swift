//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation


extension UdacityClient {
    
    struct Constants {
        
        
        // Since all the methods reference this url
        static let BaseURL = "https://www.udacity.com/api"
        
        static let SessionMethod = "/session"
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
    }
    
    
    
    
    struct HeaderValues {
        
        
        static let ContentTypeJSON = "application/json"
        
    }
    
    struct HeaderFields {
        
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        
    }
    
    
    struct JSONParamKeys {
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
     
    }
    
    
    struct JSONResponseKeys {
        
        static let Account = "account"
        static let Account_Registered = "registered"
        static let Account_Key = "key"
        
        static let Session = "session"
        static let Session_ID = "id"
        static let Session_Exp = "expiration"
        
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Key = "key"
        static let NickName = "nickname"
        

        
    }
    
    
    
    
    
}
