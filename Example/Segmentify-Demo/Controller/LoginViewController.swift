//
//  LoginViewController.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 1.02.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit
import Segmentify

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginVisitorButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // login button corner radius
        loginButton.layer.cornerRadius = 7
        // login visitor corner radius
        loginVisitorButton.layer.cornerRadius = 7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let userObj = UserModel()
        userObj.username = "test"
        userObj.email = "test@segmentify.com"
        SegmentifyManager.sharedManager().sendUserLogin(segmentifyObject: userObj)
        
        let user2Obj = UserChangeModel()
        user2Obj.userId = "123456"
        SegmentifyManager.sharedManager().sendChangeUser(segmentifyObject: user2Obj)
    }
}
