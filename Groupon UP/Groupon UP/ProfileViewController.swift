//
//  ProfileViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import CoreLocation

class ProfileViewController: BaseViewController {
    private var _logoutButton: UIBarButtonItem!
    private var _userProfile: UIImageView!
    private var _usernameLabel: UILabel!
    private var _locationLabel: UILabel!
    private let profileImageDimension = 100
    private var _locationManager: CLLocationManager!
    private var _locationIndicator: UIImageView!
    private var _numberOfGroupons: UILabel!
    private var _groupons: UILabel!
    private var _numberOfUps: UILabel!
    private var _ups: UILabel!
    
    private lazy var filter = RoundedCornersFilter(radius: 5)
    
    override func addSubviews() {
        navigationItem.rightBarButtonItem = logoutButton
        view.addSubview(userProfile)
        view.addSubview(usernameLabel)
        view.addSubview(locationIndicator)
        view.addSubview(locationLabel)
        view.addSubview(numberOfGroupons)
        view.addSubview(groupons)
        view.addSubview(numberOfUps)
        view.addSubview(ups)
    }
    
    override func addLayouts() {
        userProfile.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(50)
            make.centerX.equalTo(view)
            make.width.equalTo(profileImageDimension)
            make.height.equalTo(profileImageDimension)
        }
        usernameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userProfile.snp_bottom).offset(UPSpanSize)
            make.centerX.equalTo(view)
        }
        locationIndicator.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(usernameLabel.snp_bottom).offset(UPSpanSize)
            make.right.equalTo(locationLabel.snp_left)
            make.height.equalTo(locationLabel.snp_height)
            make.width.equalTo(locationLabel.snp_height)
        }
        locationLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(usernameLabel.snp_bottom).offset(UPSpanSize)
            make.centerX.equalTo(view)
        }
        numberOfGroupons.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(locationLabel.snp_bottom).offset(30)
            make.left.equalTo(view).offset(80)
        }
        groupons.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(numberOfGroupons.snp_bottom).offset(8)
            make.centerX.equalTo(numberOfGroupons)
        }
        numberOfUps.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(locationLabel.snp_bottom).offset(30)
            make.right.equalTo(view).offset(-80)
        }
        ups.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(numberOfUps.snp_bottom).offset(8)
            make.centerX.equalTo(numberOfUps)
        }
    }
    
    override func refreshUI() {
        if let user = PFUser.currentUser() {
            if let email = user.email {
                userProfile.af_setImageWithURL(UserClient.getAvatarUrlFor(email: email), filter: filter)
            }
            usernameLabel.text = user.username
            Order.findOrdersByUserId(user.objectId!) { (orders: [Order], error: NSError?) in
                self.numberOfGroupons.text = orders.count.description
            }
            UpInvitation.fetchUpInvitationFor(user: user) { (ups: [UpInvitation]?, error: NSError?) in
                if let ups = ups {
                    self.numberOfUps.text = ups.count.description
                }
            }
        }
        locationLabel.text = "Chicago, IL"
        switch CLLocationManager.authorizationStatus() {
            case .AuthorizedWhenInUse, .Authorized:
                locationManager
            case .NotDetermined:
                locationManager.requestAlwaysAuthorization()
            case .Restricted, .Denied:
                let alertController = UIAlertController(
                    title: "Background Location Access Disabled",
                    message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func initializeUI() {
        title = "PROFILE"
    }
}

extension ProfileViewController {
    func didPressedLogOutButton() {
        PFUser.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func composeStrings(left: String, right: String) -> NSAttributedString {
        let countText = NSMutableAttributedString(string: left, attributes: [NSForegroundColorAttributeName: UPSecondaryTextColor, NSFontAttributeName: UPContentFont])
        countText.appendAttributedString(NSAttributedString(string: " " + right, attributes: [NSForegroundColorAttributeName: UPPrimaryTextColor, NSFontAttributeName: UPContentFont]))
        return countText
    }
}

extension ProfileViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations[0]) { (places, error) -> Void in
            if let error = error {
                NSLog("Geocode failed with error: %@", error)
            }
            if let placemark = places?[0] {
                self.locationLabel.attributedText = self.composeStrings(placemark.locality! + ",", right: placemark.administrativeArea!)
            }
        }
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
    
    var userProfile: UIImageView {
        if _userProfile == nil {
            let v = UIImageView()
            v.af_setImageWithURL(NSURL(string: "https://www.gravatar.com/avatar?s=200")!, filter: filter)
            _userProfile = v
        }
        return _userProfile
    }
    
    var usernameLabel: UILabel {
        if _usernameLabel == nil {
            let v = UILabel()
            _usernameLabel = v
        }
        return _usernameLabel
    }
    
    var numberOfGroupons: UILabel {
        if _numberOfGroupons == nil {
            _numberOfGroupons = UILabel()
            _numberOfGroupons.text = "0"
        }
        return _numberOfGroupons
    }
    var groupons: UILabel {
        if _groupons == nil {
            _groupons = UILabel()
            _groupons.text = "Groupons"
        }
        return _groupons
    }
    var numberOfUps: UILabel {
        if _numberOfUps == nil {
            _numberOfUps = UILabel()
            _numberOfUps.text = "0"
        }
        return _numberOfUps
    }
    var ups: UILabel {
        if _ups == nil {
            _ups = UILabel()
            _ups.text = "UPs"
        }
        return _ups
    }
    
    var locationLabel: UILabel {
        if _locationLabel == nil {
            let v = UILabel()
            v.textAlignment = .Center
            _locationLabel = v
        }
        return _locationLabel
    }
    
    var locationIndicator: UIImageView {
        if _locationIndicator == nil {
            _locationIndicator = UIImageView(image: UIImage(named: "map")!)
        }
        return _locationIndicator
    }
    var locationManager: CLLocationManager {
        if _locationManager == nil {
            let manager = CLLocationManager()
            manager.delegate = self
            manager.distanceFilter = kCLDistanceFilterNone
            manager.desiredAccuracy = kCLLocationAccuracyBest
            _locationManager = manager
        }
        return _locationManager
    }
}
