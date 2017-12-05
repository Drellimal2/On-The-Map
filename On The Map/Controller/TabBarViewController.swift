//
//  ViewController.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var newPinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let parseCli = ParseClient.sharedInstance()
    
    let udacityCli = UdacityClient.sharedInstance()
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func newPin(_ sender: Any) {
        print("NewPin")
    }
    
    @IBAction func refresh(_ sender: Any) {
        update()
        print("refresh")
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        setUIEnabled(false)
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction(title : "Ok", style: .default){ UIAlertAction in

            self.udacityCli.removeSession(controllerCompletionHandler: {(data, error) in
                
                if let data = data {
                    print(data)
                    
                    self.appdelegate.user_id = nil
                    self.appdelegate.userInfo = nil
                    performUIUpdatesOnMain{
                        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
                    }
                } else {
                    
                    alert(title: "Oops", message: error , controller: self)
                    performUIUpdatesOnMain {
                        self.setUIEnabled(true)
                    }
                }
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
                
            })
        }
        
        let actions = [confirmAction, noAction]
        
        alert(title : "Logout", message: "Are you sure you want to logout?", controller: self, actions: actions)
        
    }
    
    func update(){
        parseCli.getLocations { (data, error) in
            if let data = data {
                StudentInformation.studentLocations = data
                let selCont = self.selectedViewController
                if selCont is MapsViewController{
                    (selCont as! MapsViewController).refresh()
                }
                
                if selCont is ListViewController{
                    (selCont as! ListViewController).refresh()
                }
            } else {
                performUIUpdatesOnMain {
                    alert(title: "Oops", message: error ?? "Something went wrong", controller: self.selectedViewController!)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    

}

extension TabBarViewController {
    func setUIEnabled(_ enabled: Bool) {
        logoutButton.isEnabled = enabled
        newPinButton.isEnabled = enabled
        refreshButton.isEnabled = enabled
        
    }
    
}
