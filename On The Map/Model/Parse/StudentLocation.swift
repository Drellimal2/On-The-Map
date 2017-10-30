//
//  StudentLocation.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

struct StudentLocation {
    
    let objectId : String
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let lat : Float
    let lng : Float
    
    
    
    
}

extension StudentLocation : Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.objectId == rhs.objectId
}

