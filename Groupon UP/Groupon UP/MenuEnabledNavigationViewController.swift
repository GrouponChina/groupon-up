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
        let grouponGreen = UIColor(red: 120/255, green: 181/255, blue: 72/255, alpha: 1)
        navigationBar.barTintColor = grouponGreen
        navigationItem.rightBarButtonItem?.tintColor = grouponGreen
        navigationBar.tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 20)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if topViewController == self.viewControllers[0] {
            topViewController!.navigationItem.leftBarButtonItem = menuBarButton
        }
    }
    
    var menuBarButton: UIBarButtonItem {
        if _menuBarButton == nil {
            let v = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Plain, target: self.navigationController?.parentViewController, action: "toggleLeftView")

            _menuBarButton = v
        }

        return _menuBarButton
    }
}