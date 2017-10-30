//
//  Utils.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation


func dictionaryToJSONString(_ dictionary : [String : AnyObject]) -> String{
    var res = "{"
    var c = 0
    for (key, value) in dictionary{
        res += "\"\(key)\" : "
        if value is [String : AnyObject]{
            res += dictionaryToJSONString(value as! [String : AnyObject])
        } else {
            res += "\"\(value as! String)\""
        }
        
        if (dictionary.count > 1 && c != dictionary.count-1 ){
            res += ","
        }
        
        c += 1
        
    }
    res += "}"
    return res
  
    
}
