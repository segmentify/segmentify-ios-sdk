//
//  LoginViewController.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 1.02.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit
import Segmentify

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginVisitorButton: UIButton!
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // login button corner radius
        loginButton.layer.cornerRadius = 7
        // login visitor corner radius
        loginVisitorButton.layer.cornerRadius = 7
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.returnKeyType = .done
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if lblUsername.text == "Segmentify" && lblPassword.text == "Password" {
            let userObj = UserModel()
            userObj.username = "test"
            userObj.email = "test@segmentify.com"
            SegmentifyManager.sharedManager().sendUserLogin(segmentifyObject: userObj)
            
            let user2Obj = UserChangeModel()
            user2Obj.userId = "123456789"
            SegmentifyManager.sharedManager().sendChangeUser(segmentifyObject: user2Obj)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Invalid username or password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
