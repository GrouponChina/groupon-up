//
//  UPViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class UPViewController: BaseViewController {
    var up: UpInvitation!
    var rsvpUsers: [PFUser?] = []

    private var _upContentView: UIView!
    private var _rsvpTableView: UITableView!

    private var _messageLabel: UILabel!
    private var _message: UITextView!
    private var _grouponUPDateLabel: UILabel!
    private var _grouponUPDate: UITextField!
    private var _rsvpTableViewLabel: UILabel!

    override func refreshUI() {
        super.refreshUI()
        initData()
    }

    override func initializeUI() {
        title = "Groupon UP Detail"
        view.backgroundColor = UIColor.whiteColor()
    }

    override func addSubviews() {
        view.addSubview(upContentView)

        upContentView.addSubview(messageLabel)
        upContentView.addSubview(message)
        upContentView.addSubview(grouponUPDateLabel)
        upContentView.addSubview(grouponUPDate)

        upContentView.addSubview(rsvpTableViewLabel)
    }

    override func addLayouts() {
        upContentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(400)
        }

        messageLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(upContentView).offset(UPContainerMargin)
            make.left.equalTo(upContentView).offset(UPContainerMargin)
            make.right.equalTo(upContentView).offset(-UPContainerMargin)
            make.height.equalTo(30)
        }

        message.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(messageLabel.snp_bottom).offset(UPContainerMargin)
            make.left.equalTo(upContentView).offset(UPContainerMargin)
            make.right.equalTo(upContentView).offset(-UPContainerMargin)
            make.height.equalTo(120)
        }

        grouponUPDateLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(message.snp_bottom).offset(UPContainerMargin)
            make.left.equalTo(upContentView).offset(UPContainerMargin)
            make.right.equalTo(upContentView).offset(-UPContainerMargin)
            make.height.equalTo(30)
        }

        grouponUPDate.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(grouponUPDateLabel.snp_bottom).offset(8)
            make.left.equalTo(upContentView).offset(UPContainerMargin)
            make.right.equalTo(upContentView).offset(-UPContainerMargin)
            make.height.equalTo(30)
        }

        rsvpTableViewLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(grouponUPDate.snp_bottom).offset(UPContainerMargin)
            make.left.equalTo(upContentView.snp_left).offset(UPContainerMargin)
            make.right.equalTo(upContentView.snp_right).offset(-UPContainerMargin)
            make.height.equalTo(30)
        }
    }

    func initData() {
        makeGetRsvpUsersRequest()
    }
}

extension UPViewController {
    func makeGetRsvpUsersRequest() {
        self.rsvpUsers = [PFUser.currentUser(), PFUser.currentUser(), PFUser.currentUser()]
    }
}

//extension UPViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.rsvpUsers.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let reuseId = "RSVPUserCell"
//        let cell: RSVPUserCell
//        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? RSVPUserCell {
//            cell = reuseCell
//        }
//        else {
//            cell = RSVPUserCell(style: .Subtitle, reuseIdentifier: reuseId)
//        }
//
//        let rsvpUser = self.rsvpUsers[indexPath.row]
//        cell.setUser(rsvpUser)
//
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
////        let dealDetailView = DealDetailsViewController()
////        dealDetailView.selectedDeal = self.rsvpUsers[indexPath.row]
////        navigationController?.pushViewController(dealDetailView, animated: true)
//    }
//}

//extension UPViewController {
//    var rsvpTableView: UITableView {
//        if _rsvpTableView == nil {
//            _rsvpTableView = UITableView()
//            _rsvpTableView.delegate = self
//            _rsvpTableView.dataSource = self
//            _rsvpTableView.separatorStyle = UITableViewCellSeparatorStyle.None
//            _rsvpTableView.estimatedRowHeight = 100
//            _rsvpTableView.rowHeight = UITableViewAutomaticDimension
//        }
//        return _rsvpTableView
//    }
//}

extension UPViewController {
    var upContentView: UIView {
        if _upContentView == nil {
            _upContentView = UIView()
        }

        return _upContentView
    }

//    var rsvpTableView: UITableView {
//        if _rsvpTableView == nil {
//            _rsvpTableView = UITableView()
//        }
//
//        return _rsvpTableView
//    }
}

extension UPViewController {
    var messageLabel: UILabel {
        if _messageLabel == nil {
            let v = UILabel()
            v.text = "What's UP"
            _messageLabel = v
        }

        return _messageLabel
    }

    var message: UITextView {
        if _message == nil {
            let v = UITextView()
            v.layer.borderWidth = UPBorderWidth
            v.layer.borderColor = UIColor.lightGrayColor().CGColor
            v.layer.cornerRadius = UPBorderRadius
            v.text = up.message
            _message = v
        }

        return _message
    }

    var grouponUPDateLabel: UILabel {
        if _grouponUPDateLabel == nil {
            let v = UILabel()
            v.text = "When's UP"
            _grouponUPDateLabel = v
        }
        
        return _grouponUPDateLabel
    }

    var grouponUPDate: UITextField {
        if _grouponUPDate == nil {
            let v = UITextField()
            v.layer.borderWidth = UPBorderWidth
            v.layer.borderColor = UIColor.lightGrayColor().CGColor
            v.layer.cornerRadius = UPBorderRadius
            v.text = "Dec 5, 2015"
            _grouponUPDate = v
        }
        
        return _grouponUPDate
    }

    var rsvpTableViewLabel: UILabel {
        if _rsvpTableViewLabel == nil {
            let v = UILabel()
            v.text = "Who's UP"
            _rsvpTableViewLabel = v
        }
        
        return _rsvpTableViewLabel
    }
}