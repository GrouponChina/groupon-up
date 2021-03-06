//
//  MenuEnabledNavigationViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit

class MenuEnabledNavigationViewController: UINavigationController {
    
    private var _menuBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UPTintColor
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 20)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if topViewController == self.viewControllers[0] {
            topViewController!.navigationItem.leftBarButtonItem = menuBarButton
        }
    }
    
    var menuBarButton: UIBarButtonItem {
        if _menuBarButton == nil {
            let v = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self.navigationController?.parentViewController, action: "toggleLeftView")
            //v.tintColor = UIColor.whiteColor()
            _menuBarButton = v
        }

        return _menuBarButton
    }
}