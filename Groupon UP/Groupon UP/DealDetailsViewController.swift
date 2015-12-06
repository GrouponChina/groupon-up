//
//  BrowseViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class DealDetailsViewController: DealDetailsBaseViewController {
    private var _dateFormater: NSDateFormatter!
    
    var dateFormatter: NSDateFormatter {
        if _dateFormater == nil {
            _dateFormater = NSDateFormatter()
            _dateFormater.dateStyle = .LongStyle
            _dateFormater.timeStyle = .NoStyle
        }
        return _dateFormater
    }
    
    override func getDealStatusView() -> UIView {
        let v = super.getDealStatusView()
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
        case .Active:
            self.toolbarForActive()
            self.showRSVP()
        case .Confirmed, .Redeemed, .Expired:
            self.toolbarWithConfirmedUp()
            self.showRSVP()
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
        let cancelButton = buttonWith(title: "Cancel", target: self, action: "cancelUp")
        let tips = descriptionLabel(title: "You've created an UP on \(dateFormatter.stringFromDate(self.selectedDeal.up!.date))")
        tips.textAlignment = .Center
        bar.addSubview(updateButton)
        bar.addSubview(cancelButton)
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
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(updateButton)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar.snp_centerX).offset(-UPSpanSize)
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
    
    func showRSVP() {
        // TODO: Implement me
    }

    func createUp() {
        debugPrint("implement me: create an Up for dealId \(selectedDeal.uuid)")
    }
    
    func updateUp() {
        let upView = UPViewController()
        upView.up = self.selectedDeal.up
        navigationController?.pushViewController(upView, animated: true)
    }
    
    func cancelUp() {
        debugPrint("implement me: cancel an Up \(selectedDeal.up!.upId)")
    }
    
    func confirmUP() {
        debugPrint("implement me: set the Up \(selectedDeal.up!.upId)'s open enrollment to false")
    }
    
    func groupChat() {
        debugPrint("implement me: shall we enable group chat function later?")
    }
}
