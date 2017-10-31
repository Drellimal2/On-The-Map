//
//  ParseConstants.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation

extension ParseClient{
    
    
    struct Constants {
        
        
        // Since all the methods reference this url
        static let BaseURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        
     
        
    }
    
    
    
    
    struct HeaderValues {
        
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentTypeJSON = "application/json"
        
    }
    
    struct HeaderFields {
        
        static let AppID = "X-Parse-Application-Id"
        static let RestKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
        
    }
    
    
    struct JSONParamKeys {
        
        static let ObjectID = "objectId"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Lat = "latitude"
        static let Lng = "longitude"
        static let UniqueKey = "uniqueKey"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
        static let Limit = "limit"
        static let Order = "order"
        
        
    }
    
    
    struct JSONResponseKeys {
        
        static let Results = "results"
        
        static let ObjectID = "objectId"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Lat = "latitude"
        static let Lng = "longitude"
        static let UniqueKey = "uniqueKey"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        
        //Not using these now but just incase I decide to use them later
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
    }
    
}
