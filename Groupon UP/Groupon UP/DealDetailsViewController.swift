//
//  BrowseViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import SnapKit

class DealDetailsViewController: DealDetailsBaseViewController {
    var messages = [(PFUser, String, NSDate)]()
    private var _dateFormater: NSDateFormatter!
    private lazy var filter = RoundedCornersFilter(radius: 5)

    var dateFormatter: NSDateFormatter {
        if _dateFormater == nil {
            _dateFormater = NSDateFormatter()
            _dateFormater.dateStyle = .LongStyle
            _dateFormater.timeStyle = .NoStyle
        }
        return _dateFormater
    }
    
    override func getDealStatusView() -> UIView {
        let v = UITableView()
        v.scrollEnabled = false
        v.dataSource = self
        return v
    }
    
    override func getBottomToolbar() -> UIView {
        let v = UIView()
        v.backgroundColor = UPPrimaryTextColor
        v.alpha = 0.8
        return v
    }

    override func refreshUI() {
        super.refreshUI()

        if let _ = selectedDeal.up {
            self.updateToolbarAndUpStatus()
        } else {
            selectedDeal.getUpCreatedByUser(PFUser.currentUser()!.objectId!) {_,_ in
                self.updateToolbarAndUpStatus()
            }
        }
    }
}

extension DealDetailsViewController {
    private func buttonWith(title title: String, target: AnyObject?, action: Selector) -> UIButton {
        let button = UIButton(type: .Custom)
        button.setTitle(title, forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = UPTintColor
        return button
    }
    
    private func descriptionLabel(title title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = UPTextColorOnDardBackground
        label.font = UIFont(name: "Avenir-Hair", size: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }

    func updateToolbarAndUpStatus() {
        switch self.selectedDeal.upStatus {
        case .None:
            self.toolbarForNone()
        case .Created:
            self.toolbarForCreated()
            self.showChat()
        case .Active:
            self.toolbarForActive()
            self.showChat()
        case .Confirmed, .Redeemed, .Expired:
            self.toolbarWithConfirmedUp()
            self.showChat()
        }
    }
    
    
    func toolbarForNone() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let createButton = buttonWith(title: "Who's UP", target: self, action: "createUp")
        let label = descriptionLabel(title: "More people, more fun!")
        bar.addSubview(createButton)
        bar.addSubview(label)
        createButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
            make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
        label.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bar)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar.snp_centerX).offset(-UPSpanSize)
        }
    }
    
    func toolbarForCreated() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let updateButton = buttonWith(title: "Update", target: self, action: "updateUp")
        let tips = descriptionLabel(title: "You've created an UP on \(dateFormatter.stringFromDate(self.selectedDeal.up!.date))")
        tips.textAlignment = .Center
        bar.addSubview(updateButton)
        bar.addSubview(tips)
        tips.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
        updateButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
            make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
        }
    }
    
    func toolbarForActive() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let confirmButton = buttonWith(title: "Let's Rock", target: self, action: "confirmUp")
        let tips = descriptionLabel(title: "You've created an UP on \(dateFormatter.stringFromDate(self.selectedDeal.up!.date))")
        tips.textAlignment = .Center
        bar.addSubview(confirmButton)
        bar.addSubview(tips)
        tips.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
        confirmButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
    }
    
    func toolbarWithConfirmedUp() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let chatButton = buttonWith(title: "Group Chat", target: self, action: "groupChat")
        let tips = descriptionLabel(title: "We're UP to go on \(dateFormatter.stringFromDate(self.selectedDeal.up!.date))!")
        tips.textAlignment = .Center
        bar.addSubview(chatButton)
        bar.addSubview(tips)
        tips.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
        chatButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
    }

    func showChat() {
        showUPMessage { () -> Void in
            let tableView = self.dealStatusView as! UITableView
            tableView.reloadData()
            tableView.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(tableView.contentSize.height)
            })
        }
    }

    func showUPMessage(callback: () -> Void) {
        messages.removeAll()
        if let up = selectedDeal.up {
            messages.append((UserCache.getUserForId(up.createdByUserId), up.message, up.object.createdAt!))
            if let _ = up.rsvps {
                showRSVP()
                callback()
            } else {
                up.fetchEnrolledUsers({ (rsvps, error) -> Void in
                    if let _ = rsvps {
                        self.showRSVP()
                        callback()
                    }
                })
            }
        }
    }

    func showRSVP() {
        if let rsvps = selectedDeal.up?.rsvps {
            rsvps.sort({ (left, right) -> Bool in
                left.object.createdAt!.timeIntervalSince1970 < right.object.createdAt!.timeIntervalSince1970
            }).forEach({ (rsvp) -> () in
                messages.append((UserCache.getUserForId(rsvp.userId), "I'm UP", rsvp.object.createdAt!))
            })
        }
    }

    func createUp() {
        let upView = UPViewController()
        upView.deal = self.selectedDeal
        navigationController?.pushViewController(upView, animated: true)
    }
    
    func updateUp() {
        let upView = UPViewController()
        upView.deal = self.selectedDeal
        navigationController?.pushViewController(upView, animated: true)
    }
    
    func confirmUP() {
        debugPrint("implement me: set the Up \(selectedDeal.up!.upId)'s open enrollment to false")
    }
    
    func groupChat() {
        debugPrint("implement me: shall we enable group chat function later?")
    }
}

extension DealDetailsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let (user, msg, date) = messages[indexPath.row]
        let reuseId = "messsageCell"
        let cell: UITableViewCell!
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(reuseId) {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: reuseId)
        }
        cell.imageView?.af_setImageWithURL(NSURL(string: "https://www.gravatar.com/avatar?s=200")!)
        user.fetchIfNeededInBackgroundWithBlock({ (fetchedUser, error) -> Void in
            cell.imageView?.af_setImageWithURL(NSURL(string: "https://www.gravatar.com/avatar/\(user.email!.md5())?s=200")!, filter: self.filter)
            cell.textLabel?.text = user.username
        })
        cell.detailTextLabel?.text = msg + "-" + dateFormatter.stringFromDate(date)
        return cell
    }
}