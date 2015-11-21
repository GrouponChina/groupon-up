//
//  ProfileViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: BaseViewController {
    var _logoutButton: UIBarButtonItem!
    
    override func addSubviews() {
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    override func initializeUI() {
        title = PFUser.currentUser()?.username
    }
}

extension ProfileViewController {
    func didPressedLogOutButton() {
        PFUser.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ProfileViewController {
    var logoutButton: UIBarButtonItem {
        if _logoutButton == nil {
            let v = UIBarButtonItem(title: "Log Out", style: .Done, target: self, action: "didPressedLogOutButton")
            _logoutButton = v
        }
        return _logoutButton
    }
}
