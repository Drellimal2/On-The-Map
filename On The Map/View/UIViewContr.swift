//
//  UIViewContr.swift
//  On The Map
//
//  Created by Dane Miller on 11/1/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIViewController
{
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    
    
}
