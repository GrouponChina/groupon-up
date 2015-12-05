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
    override func getDealStatusView() -> UIView {
        let v = super.getDealStatusView()
        return v
    }
    
    override func getBottomToolbar() -> UIView {
        let v = UIView()
        v.backgroundColor = UPPrimaryTextColor
        v.alpha = 0.8
        v.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(80)
        }
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
    
    func updateToolbarAndUpStatus() {
//        switch self.selectedDeal.upStatus {
//        case .None:
//            self.toolbarForNone()
//        case .Created:
//            self.toolbarForCreated()
//        case .Active:
//            self.toolbarForActive()
//            self.showRSVP()
//        case .Confirmed, .Redeemed, .Expired:
            self.toolbarWithConfirmedUp()
//            self.showRSVP()
//        }
    }
    
    
    func toolbarForNone() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let createButton = buttonWith(title: "Who's UP", target: self, action: "createUp")
        bar.addSubview(createButton)
        createButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
            make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
    }
    
    func toolbarForCreated() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let updateButton = buttonWith(title: "Update", target: self, action: "updateUp")
        let cancelButton = buttonWith(title: "Cancel", target: self, action: "cancelUp")
        bar.addSubview(updateButton)
        bar.addSubview(cancelButton)
        updateButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
        }
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
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
        bar.addSubview(confirmButton)
        confirmButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
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
        bar.addSubview(chatButton)
        chatButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
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
        debugPrint("implement me: update an Up \(selectedDeal.up!.upId)")
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
