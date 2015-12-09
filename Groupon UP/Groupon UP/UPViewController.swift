//
//  UPViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class UPViewController: BaseViewController, UITextFieldDelegate {
    var deal: Deal!
    var rsvpUsers: [PFUser?] = []

    private var _upContentView: UIView!
    private var _rsvpTableView: UITableView!
    private var _datePickerView: UIDatePicker!

    private var _messageLabel: UILabel!
    private var _message: UITextView!
    private var _grouponUPDateLabel: UILabel!
    private var _grouponUPDate: UITextField!
//    private var _rsvpTableViewLabel: UILabel!
    private var _bottomToolbar: UIView!

    override func refreshUI() {
        super.refreshUI()
        initData()
        renderToolBar()
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

//        upContentView.addSubview(rsvpTableViewLabel)

        view.addSubview(bottomToolbar)
    }

    override func addLayouts() {
        bottomToolbar.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }

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

//        rsvpTableViewLabel.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(grouponUPDate.snp_bottom).offset(UPContainerMargin)
//            make.left.equalTo(upContentView.snp_left).offset(UPContainerMargin)
//            make.right.equalTo(upContentView.snp_right).offset(-UPContainerMargin)
//            make.height.equalTo(30)
//        }
    }

    func initData() {
        makeGetRsvpUsersRequest()
    }

    func renderToolBar() {
        let bar = bottomToolbar

        bar.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }

        let saveButton = buttonWith(title: "Save", target: self, action: "saveUP")

        bar.addSubview(saveButton)

        saveButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bar).offset(UPSpanSize)
            make.bottom.equalTo(bar).offset(-UPSpanSize)
            make.left.equalTo(bar.snp_centerX).offset(UPSpanSize)
            make.right.equalTo(bar).offset(-UPSpanSize)
        }

        if self.deal.up != nil {
            let deleteButton = buttonWith(title: "DELETE UP", target: self, action: "onDeleteButton")

            deleteButton.backgroundColor = UPDangerZoneColor
            bar.addSubview(deleteButton)
            deleteButton.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(saveButton)
                make.left.equalTo(bar).offset(UPSpanSize)
                make.right.equalTo(bar.snp_centerX).offset(-UPSpanSize)
                make.bottom.equalTo(bar).offset(-UPSpanSize)
            }
        }
    }
}

extension UPViewController {
    func makeGetRsvpUsersRequest() {
        self.rsvpUsers = [PFUser.currentUser(), PFUser.currentUser(), PFUser.currentUser()]
    }
}

extension UPViewController {
    var upContentView: UIView {
        if _upContentView == nil {
            _upContentView = UIView()
        }

        return _upContentView
    }

    var datePickerView: UIDatePicker {
        if _datePickerView == nil {
            _datePickerView = UIDatePicker()
            _datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
            _datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        }

        return _datePickerView
    }
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
            v.text = self.deal.up?.message

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

            v.delegate = self
            v.addTarget(self, action: "grouponUPDateEditingDidBegin:", forControlEvents: UIControlEvents.EditingDidBegin)

            if let currentUp = self.deal.up?.date {
                datePickerView.setDate(currentUp, animated: false)
                updateDatePickerViewDate(datePickerView, textField:v)
            }

            _grouponUPDate = v
        }
        
        return _grouponUPDate
    }

    var bottomToolbar: UIView! {
        if _bottomToolbar == nil {
            _bottomToolbar = getBottomToolbar()
        }
        return _bottomToolbar
    }
}

// MARK: event handlers
extension UPViewController {
    func grouponUPDateEditingDidBegin(sender:UITextField) {
        sender.inputView = datePickerView

        let doneButton:UIButton = UIButton (frame: CGRectMake(100, 100, 100, 44))
        doneButton.tintColor = UPTintColor
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "onDatePickerDoneButton", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UPPrimaryTextColor

        sender.inputAccessoryView = doneButton
    }

    func datePickerValueChanged(sender:UIDatePicker) {
        updateDatePickerViewDate(sender, textField: grouponUPDate)
    }

    func onDatePickerDoneButton() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        self.grouponUPDate.text = dateFormatter.stringFromDate(self.datePickerView.date)

        self.grouponUPDate.resignFirstResponder()
    }

    func onDeleteButton() {
        self.deal.up?.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.deal.up = nil
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                print("[ERROR] Unable to delete Groupon UP: \(error)")
            }
        }
    }

    func saveUP() {
        if self.deal.up != nil {
            self.deal.up!.message = self.message.text
            self.deal.up!.date = self.datePickerView.date
        } else {
            if let currentUser = PFUser.currentUser() {
                self.deal.up = UpInvitation(className: "UpInvitation", dictionary: [
                    "message": self.message.text,
                    "date": self.datePickerView.date,
                    "dealId": self.deal.uuid,
                    "openEnroll": true,
                    "createdBy": currentUser,
                    "rsvps": []
                    ])
            }
        }

        print("Saving object...")
        self.deal.up!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Groupon UP saved!")
            } else {
                print("[ERROR] Unable to save Groupon UP: \(error?.description)")
            }
        }

        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: helper functions
extension UPViewController {
    func updateDatePickerViewDate(sender:UIDatePicker, textField:UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        textField.text = dateFormatter.stringFromDate(sender.date)
    }

    func getBottomToolbar() -> UIView {
        let v = UIView()
        v.backgroundColor = UPPrimaryTextColor
        v.alpha = 0.8

        return v
    }

    private func buttonWith(title title: String, target: AnyObject?, action: Selector) -> UIButton {
        let button = UIButton(type: .Custom)
        button.setTitle(title, forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = UPTintColor

        return button
    }
}