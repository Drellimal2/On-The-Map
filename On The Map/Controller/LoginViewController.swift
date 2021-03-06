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
    
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var actInd = MyActInd.sharedInstance()
    
    let UdacityCli = UdacityClient.sharedInstance()
    var usernameText  = ""
    var passwordText = ""
    
    @IBAction func loginUdacity(_ sender: Any) {
        guard ( emailTextField.text!.isEmpty || emailTextField.text!.isEmpty )  else {
            actInd.show(self.view)
            setUIEnabled(false)
            usernameText = emailTextField.text!
            passwordText = passwordTextField.text!
            UdacityCli.loginPostSession(username: usernameText, password: passwordText,  controllerCompletionHandler: { data, error in
                performUIUpdatesOnMain {
                    if let error = error {
                        print(error)
                        self.showError(error)
                    } else {
                        let ndata = data as! [String : Any]
                        print("DATA")
                        print(ndata)
                        self.delegate.user_id = ndata[Consts.user_id] as? String
                        self.delegate.userInfo = ndata[Consts.info] as? StudentInformation
                        self.completeLogin()
                    }
                    self.setUIEnabled(true)
                    self.actInd.hide()

                }
            })
            return
        }
        errorTextView.text = "Email and Password Fields cannot be empty"
        
    }
    
    
    private func completeLogin(){
        
        errorTextView.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapsNavigationController") as! UINavigationController
        
        present(controller, animated: true, completion: nil)
        
        
    }
    
    @IBAction func signUp(_ sender : Any) {
        let app = UIApplication.shared
        app.open(NSURL(string: Consts.udacity_sign_up_url)! as URL)
    }

}

extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            errorTextView.text = ""
        }
    }
    
    func showError(_ errorMsg: String?) {
        if let errorMsg = errorMsg {
            errorTextView.text = errorMsg
        }
    }
    
    
}
