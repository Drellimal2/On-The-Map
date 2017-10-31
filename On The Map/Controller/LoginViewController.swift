//
//  LoginViewController.swift
//  On The Map
//
//  Created by Dane Miller on 10/29/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    
    var usernameText  = ""
    var passwordText = ""
    
    @IBAction func loginUdacity(_ sender: Any) {
        guard ( emailTextField.text!.isEmpty || emailTextField.text!.isEmpty )  else {
            setUIEnabled(false)
            usernameText = emailTextField.text!
            passwordText = passwordTextField.text!
            print("HI")
            UdacityClient.sharedInstance().loginPostSession(username: usernameText, password: passwordText)
            setUIEnabled(true)
            print("a")
            print(UdacityClient.sharedInstance().sessionID!)
            return
        }
        errorTextView.text = "Email and Password Fields cannot be empty"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        errorTextView.text = ""
//
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
}
