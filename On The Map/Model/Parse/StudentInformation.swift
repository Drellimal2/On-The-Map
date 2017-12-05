//
//  StudentInformation.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

struct StudentInformation {
    
    var objectId : String!
    var uniqueKey : String!
    var firstName : String!
    var lastName : String!
    var mapString : String!
    var mediaURL : String!
    var lat : Double!
    var lng : Double!
    
    
    static var studentLocations = [StudentInformation]()
    
    init() {
        // Default Initializer
    }
    
    init(dictionary: [String:Any]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String ?? ""
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String ?? ""
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String ?? ""
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String ?? ""
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String ?? ""
        lat = dictionary[ParseClient.JSONResponseKeys.Lat] as? Double ?? 0.0
        lng = dictionary[ParseClient.JSONResponseKeys.Lng] as? Double ?? 0.0
    }
    static func studentsFromResults(_ results: [[String:Any]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
    
}

extension StudentInformation : Equatable {}

func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
    return lhs.objectId == rhs.objectId
}

