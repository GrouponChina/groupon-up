//
//  ViewController.swift
//  Groupon UP
//
//  Created by Chang Liu on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class InitialViewController: UIViewController {
    
    var deals = [Deal]()
    
    override func viewDidLoad() {
        DealClient.getDivisionDeals { (deals: [Deal]!) -> Void in
            self.deals = deals
        }
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if PFUser.currentUser() == nil {
            presentViewController(LoginViewController(), animated: true, completion: nil)
        } else {
            let rootViewController = HamburgerViewController()
            rootViewController.leftViewController = UINavigationController(rootViewController: MenuViewController())
            presentViewController(rootViewController, animated: true, completion: nil)
        }

    }
}

