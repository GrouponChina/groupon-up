//
//  BrowseViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse
import SnapKit

class DealDetailsViewController: DealDetailsBaseViewController {
    var messages = [(PFUser, String)]()
    var buyItNow = ""
    var timer: NSTimer?
    var alert: UIAlertView!

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
        let v = UITableView()
        v.scrollEnabled = false
        v.dataSource = self
        v.delegate = self
        v.rowHeight = 90
        return v
    }
    
    override func getBottomToolbar() -> UIView {
        let v = UIView()
        v.backgroundColor = UPPrimaryTextColor
        v.alpha = 0.8
        return v
    }

    override func refreshUI() {
        self.updateToolbarAndUpStatus()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
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
        if buyItNow == "buy" {
            self.toolbarForBuy()
            self.showDealDescription()
        } else if buyItNow == "success" {
            self.toolbarForSuccess()
            self.showDealDescription()
        } else {
            if let up = selectedDeal.up where up.createdBy != PFUser.currentUser() {
                self.toolbarForRSVP()
                self.showChat(nil)
            } else {
                switch self.selectedDeal.upStatus {
                case .None:
                    self.toolbarForNone()
                    self.clearChat()
                case .Active, .Confirmed, .Redeemed, .Expired:
                    self.toolbarForCreated()
                    self.showChat(nil)
                }
            }
        }
    }

    func toolbarForSuccess() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let createButton = buttonWith(title: "Order confirmed!", target: self, action: "onSuccessButton")
        bar.addSubview(createButton)
        
        createButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
    }

    func toolbarForBuy() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let createButton = buttonWith(title: "Instant Buy!", target: self, action: "onBuyButton:")
        bar.addSubview(createButton)

        createButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
    }
    
    func toolbarForNone() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let createButton = buttonWith(title: "Groupon UP", target: self, action: "createUp")
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
    
    func toolbarForRSVP() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let chatButton = buttonWith(title: "Chat", target: self, action: "groupChat")
        let rsvpButton = buttonWith(title: "RSVP", target: self, action: "rsvp:")
        let deleteRsvpButton = buttonWith(title: "RAGE QUIT", target: self, action: "deleteRsvp:")
        deleteRsvpButton.backgroundColor = UPDangerZoneColor
        let tips = descriptionLabel(title: "\(selectedDeal.up!.createdBy.username!) created an UP on \(dateFormatter.stringFromDate(self.selectedDeal.up!.date))")
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
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar.snp_centerX).offset(-UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
        }
        if !selectedDeal.up!.rsvps.contains(PFUser.currentUser()!) {
            bar.addSubview(rsvpButton)
            rsvpButton.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
                make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
                make.right.equalTo(bar).offset(-UPSpanSize)
                make.bottom.equalTo(bar).offset(-UPSpanSize)
            }
        } else {
            bar.addSubview(deleteRsvpButton)
            deleteRsvpButton.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
                make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
                make.right.equalTo(bar).offset(-UPSpanSize)
                make.bottom.equalTo(bar).offset(-UPSpanSize)
            }
        }
    }
    
    func toolbarForCreated() {
        let bar = bottomToolbar
        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
        let chatButton = buttonWith(title: "Chat", target: self, action: "groupChat")
        let updateButton = buttonWith(title: "Update", target: self, action: "updateUp")
        let tips = descriptionLabel(title: "You've created an UP on \(dateFormatter.stringFromDate(self.selectedDeal.up!.date))")
        tips.textAlignment = .Center
        bar.addSubview(updateButton)
        bar.addSubview(chatButton)
        bar.addSubview(tips)
        tips.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
        chatButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar.snp_centerX).offset(-UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
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
        let chatButton = buttonWith(title: "Chat", target: self, action: "groupChat")
        let confirmButton = buttonWith(title: "Let's Rock", target: self, action: "confirmUp")
        let tips = descriptionLabel(title: "You've created an UP on \(dateFormatter.stringFromDate(self.selectedDeal.up!.date))")
        tips.textAlignment = .Center
        bar.addSubview(confirmButton)
        bar.addSubview(chatButton)
        bar.addSubview(tips)
        tips.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }
        chatButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
            make.left.equalTo(bar).offset(UPSpanSize)
            make.right.equalTo(bar.snp_centerX).offset(-UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
        }
        confirmButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(tips.snp_bottom).offset(UPSpanSize)
            make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
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
    
    func showChatAndScrollToBottom() {
        debugPrint("refreshing...")
        self.showChat({ () -> Void in
            self.scrollToBottom()
        })
    }

    func showChat(callback: (() -> Void)?) {
        showUPMessage { () -> Void in
            self.refreshChat()
            callback?()
        }
    }
    
    func clearChat() {
        messages.removeAll()
        refreshChat()
    }
    
    func refreshChat() {
        let tableView = self.dealStatusView as! UITableView
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
        tableView.snp_updateConstraints(closure: { (make) -> Void in
            make.height.equalTo(tableView.contentSize.height)
        })
    }
    
    func showDealDescription() {
        let tableView = self.dealStatusView as! UITableView
        tableView.separatorStyle = .None
        self.messages = [(PFUser.currentUser()!, selectedDeal.finePrint)]
        tableView.reloadData()
        tableView.snp_updateConstraints(closure: { (make) -> Void in
            make.height.equalTo(tableView.contentSize.height)
        })
    }

    func showUPMessage(callback: () -> Void) {
        messages.removeAll()
        if let up = selectedDeal.up {
            messages.append((up.createdBy, up.message))
            showRSVP(callback)
        }
    }

    func showRSVP(callback: () -> Void) {
        selectedDeal.up?.rsvps.forEach({ (rsvp) -> () in
            messages.append((rsvp, "I'm UP"))
        })
        showChatLog(callback)
    }
    
    func showChatLog(callback: () -> Void) {
        ChatLog.fetchChatFor(invitation: selectedDeal.up!) { (chatLogs, error) -> Void in
            if let chatLogs = chatLogs {
                chatLogs.forEach({ (chatLog) -> () in
                    self.messages.append((chatLog.user, chatLog.message))
                })
            }
            callback()
        }
    }

    func onSuccessButton() {
        buyItNow = ""
        refreshUI()
    }
    
    func onBuyButton(sender: UIButton) {
        let order = PFObject(className:"Order")
        order["userID"] = PFUser.currentUser()?.objectId
        order["dealID"] = self.selectedDeal.uuid
        sender.setTitle("Confirming...", forState: .Normal)
        sender.enabled = false
        order.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.buyItNow = "success"
                self.refreshUI()
            } else {
                print("[ERROR] Unable to submit the order: \(error)")
            }
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
        selectedDeal.up?.openEnroll = false
        selectedDeal.up?.saveInBackground()
    }
    
    func groupChat() {
        alert = UIAlertView(title: "Leave a message", message: "", delegate: self, cancelButtonTitle:"Cancel")
        alert.delegate = self
        alert.addButtonWithTitle("Send")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.textFieldAtIndex(0)!.placeholder = "Your message here ..."
        alert.show()
    }

    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex{
        case 1:
            let message = alert.textFieldAtIndex(0)!.text!
            if !message.isEmpty {
                let newChatLog = ChatLog(className: "Chat", dictionary: [
                    "user": PFUser.currentUser()!,
                    "message": message,
                    "invitation": self.selectedDeal.up!
                    ])
                newChatLog.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if self.timer == nil {
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "showChatAndScrollToBottom", userInfo: nil, repeats: true)
                    }
                    self.scrollToBottom()
                })
            }
        default:
            print("Whatever!")
        }
    }

    func rsvp(sender: UIButton) {
        sender.enabled = false
        let me = PFUser.currentUser()!
        if !selectedDeal.up!.rsvps.contains(me) {
            selectedDeal.up!.rsvps.append(me)
            selectedDeal.up!.saveInBackgroundWithBlock({ (success, error) -> Void in
                self.updateToolbarAndUpStatus()
            })
        }
    }

    func deleteRsvp(sender: UIButton) {
        sender.enabled = false
        let me = PFUser.currentUser()!
        if selectedDeal.up!.rsvps.contains(me) {
            selectedDeal.up!.rsvps = selectedDeal.up!.rsvps.filter() {$0 != me}
            selectedDeal.up!.saveInBackgroundWithBlock({ (success, error) -> Void in
                self.updateToolbarAndUpStatus()
            })
        }
    }
}

extension DealDetailsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if buyItNow == "buy" || buyItNow == "success" {
            return 180.0
        }
        else {
            return 90
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if buyItNow == "buy" || buyItNow == "success" {
            let (_, message) = messages[indexPath.row]
            let cell = UITableViewCell()
            cell.addSubview(dealFinePrint)
            dealFinePrint.snp_makeConstraints { (make)->  Void in
                make.top.equalTo(cell)
                make.left.equalTo(cell).offset(4)
                make.right.equalTo(cell).offset(4)
                make.bottom.equalTo(cell)
            }
            dealFinePrint.text = message
            return cell
        } else {
            let (user, message) = messages[indexPath.row]
            let cell = ChatMessageTableViewCell(style: .Default, reuseIdentifier: nil)
            cell.initializeWith(user: user, message: message)
            return cell
        }
    }
}

extension DealDetailsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: helper
extension DealDetailsViewController {
    func scrollToBottom() {
        UIView.animateWithDuration(0.2, animations: {() -> Void in
            let offset = self.scrollView.contentSize.height - self.scrollView.bounds.size.height
            debugPrint(offset)
            if offset > 0 {
                let bottomOffset: CGPoint = CGPointMake(0, offset)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
}