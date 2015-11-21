//
//  LoginViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import SwiftSpinner

class LoginViewController: PFLogInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fields = PFLogInFields(rawValue: PFLogInFields.LogInButton.rawValue | PFLogInFields.UsernameAndPassword.rawValue)
        delegate = self
    }
}

extension LoginViewController: PFLogInViewControllerDelegate {
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        logInController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        let message = error?.localizedDescription ?? "Login Failed"
        SwiftSpinner.show(message).addTapHandler({ () -> () in
            SwiftSpinner.hide()
        }, subtitle: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        return true
    }
}

