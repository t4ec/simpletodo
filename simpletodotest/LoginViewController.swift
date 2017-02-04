//
//  LoginViewController.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = AccessToken.current {
            // nothing
        } else {
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
            view.addSubview(loginButton)
        }
    }
}

