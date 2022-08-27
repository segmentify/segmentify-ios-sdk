//
//  LoginViewController.swift
//  Segmentify-Demo


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
            //SegmentifyManager.sharedManager().sendUserLogin(segmentifyObject: userObj)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Invalid username or password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
