//
//  Utils.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation
import UIKit

func dictionaryToJSONString(_ dictionary : [String : AnyObject]) -> String{
    var res = "{"
    var c = 0
    for (key, value) in dictionary{
        res += "\"\(key)\" : "
        if value is [String : AnyObject]{
            res += dictionaryToJSONString(value as! [String : AnyObject])
        } else {
            if let val = value as? String{
                res += "\"\(val as! String)\""
            } else {
                res += String(describing: value)
            }
        }
        
        if (dictionary.count > 1 && c != dictionary.count-1 ){
            res += ","
        }
        
        c += 1
        
    }
    res += "}"
    return res
  
    
}

func alert(title : String, message : String, controller : UIViewController, actions : [UIAlertAction] = []){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if actions.count == 0{
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    } else {
        for action in actions{
            alert.addAction(action)
        }
    }
    controller.present(alert, animated: true, completion: nil)
}

struct Consts {
    
    static let session_id = "session_id"
    static let user_id = "user_id"
    static let info = "info"
    static let first_name = "fname"
    static let last_name = "lname"
    
    static let grey_color = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 0.5)
    
    static let enabled_blue = UIColor(red: 115.0/255.0, green: 200.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    
    static let udacity_sign_up_url = "https://auth.udacity.com/sign-up"
    
}
