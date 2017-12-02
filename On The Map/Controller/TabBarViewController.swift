//
//  ViewController.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let parseCli = ParseClient.sharedInstance()
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func newPin(_ sender: Any) {
        print("NewPin")
    }
    
    @IBAction func refresh(_ sender: Any) {
        update()
        print("refresh")
        let selCont = self.selectedViewController
        if selCont is MapsViewController{
            (selCont as! MapsViewController).refresh()
        }

        if selCont is ListViewController{
            (selCont as! ListViewController).refresh()
        }
        
    }
    
    func update(){
        parseCli.getLocations { (data, error) in
            if let data = data {
                self.appdelegate.students = data
            } else {
                alert(title: "Oops", message: error ?? "Something went wrong", controller: self)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }


    

    

}
