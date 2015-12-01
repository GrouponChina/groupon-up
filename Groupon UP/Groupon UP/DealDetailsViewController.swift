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
        let v = UIToolbar()
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
        let bar = bottomToolbar as! UIToolbar
        let createButton = UIBarButtonItem(title: "Who's UP", style: .Plain, target: self, action: "createUp")
        bar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            createButton
        ]
    }
    
    func toolbarForCreated() {
        let bar = bottomToolbar as! UIToolbar
        let updateButton = UIBarButtonItem(title: "Update", style: .Plain, target: self, action: "updateUp")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelUp")
        bar.items = [
            updateButton,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            cancelButton
        ]
    }
    
    func toolbarForActive() {
        let bar = bottomToolbar as! UIToolbar
        let confirmButton = UIBarButtonItem(title: "Let's Rock", style: .Plain, target: self, action: "confirmUp")
        bar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            confirmButton
        ]
    }
    
    func toolbarWithConfirmedUp() {
        let bar = bottomToolbar as! UIToolbar
        let chatButton = UIBarButtonItem(title: "Group Chat", style: .Plain, target: self, action: "groupChat")
        bar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            chatButton
        ]
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
