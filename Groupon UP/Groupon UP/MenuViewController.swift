//
//  MenuViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MenuViewController: BaseViewController {
    private var _tableView: UITableView!
    private var _userProfileScreen: ProfileViewController!
    private var _ordersScreen: OrderViewController!
    private var _browseScreen: BrowseViewController!
    private var _upNotificationsScreen: UPListViewController!
    private var _viewControllers: [UIViewController]!
    
    override func addSubviews() {
        view.addSubview(tableView)
    }
    
    override func addLayouts() {
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
    }
    
    override func initializeUI() {
        if let hamburgerVC = (navigationController ?? self).parentViewController as? HamburgerViewController where viewControllers.count > 0 {
            hamburgerVC.centerViewController = viewControllers[1]
        }
        automaticallyAdjustsScrollViewInsets = false
    }
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let reuseId = "command cell"
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(reuseId) {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: reuseId)
        }
        switch indexPath.row {
        case 0:
            // Profile cell
            cell.textLabel?.text = "PROFILE"
        case 1:
            // Browse Deals
            cell.textLabel?.text = "DEALS"
        case 2:
            // Home timeline
            cell.textLabel?.text = "ORDERS"
        case 3:
            // Home timeline
            cell.textLabel?.text = "GROUPON UP"
        default:
            break
        }
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let hamburgerVC = (navigationController ?? self).parentViewController as? HamburgerViewController {
            hamburgerVC.centerViewController = viewControllers[indexPath.row]
            hamburgerVC.closeLeftView()
        }
    }
}

extension MenuViewController {
    var tableView: UITableView {
        if _tableView == nil {
            let v = UITableView()
            v.dataSource = self
            v.delegate = self
            v.tableFooterView = UIView()
            _tableView = v
        }
        return _tableView
    }
    
    var viewControllers: [UIViewController] {
        if _viewControllers == nil {
            _viewControllers = [
                MenuEnabledNavigationViewController(rootViewController: userProfileScreen),
                MenuEnabledNavigationViewController(rootViewController: browseScreen),
                MenuEnabledNavigationViewController(rootViewController: ordersScreen),
                MenuEnabledNavigationViewController(rootViewController: upNotificationsScreen)
            ]
        }
        return _viewControllers
    }

    var userProfileScreen: ProfileViewController {
        if _userProfileScreen == nil {
            let s = ProfileViewController()
            _userProfileScreen = s
        }
        return _userProfileScreen
    }
    
    var ordersScreen: OrderViewController {
        if _ordersScreen == nil {
            let s = OrderViewController()
            _ordersScreen = s
        }
        return _ordersScreen
    }
    
    var browseScreen: BrowseViewController {
        if _browseScreen == nil {
            _browseScreen = BrowseViewController()
        }
        return _browseScreen
    }
    
    var upNotificationsScreen: UPListViewController {
        if _upNotificationsScreen == nil {
            let s = UPListViewController()
            _upNotificationsScreen = s
        }
        return _upNotificationsScreen
    }
}
