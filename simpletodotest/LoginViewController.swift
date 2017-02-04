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
            loginButton.delegate = self
            view.addSubview(loginButton)
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .success:
            performSegue(withIdentifier: "Log in", sender: self)
        default: return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        return
    }
}

