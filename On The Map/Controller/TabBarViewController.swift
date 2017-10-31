//
//  ViewController.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBAction func newPin(_ sender: Any) {
        print("NewPin")
    }
    
    @IBAction func refresh(_ sender: Any) {
        print("refresh")
        let selCont = self.selectedViewController
        if selCont is MapsViewController{
            (selCont as! MapsViewController).refresh()
        }
        
        if selCont is ListViewController{
            (selCont as! ListViewController).refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    

    

}
