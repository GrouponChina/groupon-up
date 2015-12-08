//
//  ChatMessageTableViewCell.swift
//  Groupon UP
//
//  Created by XueYan on 12/7/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ChatMessageTableViewCell: UITableViewCell {
    private var _messageLabel: UILabel!
    private var _usernameLabel: UILabel!
    private var _avatarImageView: UIImageView!
    private lazy var filter = RoundedCornersFilter(radius: 5)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(messageLabel)
        addSubview(usernameLabel)
        addSubview(avatarImageView)
    }

    func addLayout(leftAlign: Bool) {
        avatarImageView.snp_remakeConstraints { (make) -> Void in
            if leftAlign {
                make.left.equalTo(self).offset(UPSpanSize)
            } else {
                make.right.equalTo(self).offset(-UPSpanSize)
            }
            make.top.equalTo(self).offset(UPSpanSize)
            make.bottom.equalTo(self).offset(-UPSpanSize)
            make.width.equalTo(avatarImageView.snp_height)
        }

        usernameLabel.snp_remakeConstraints { (make) -> Void in
            if leftAlign {
                make.left.equalTo(avatarImageView.snp_right).offset(UPSpanSize)
            } else {
                make.right.equalTo(avatarImageView.snp_left).offset(-UPSpanSize)
            }
            make.top.equalTo(avatarImageView)
        }

        messageLabel.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(usernameLabel.snp_bottom).offset(UPSpanSize)
            if leftAlign {
                make.left.equalTo(usernameLabel)
            } else {
                make.right.equalTo(usernameLabel)
            }
        }
    }

    func initializeWith(user user: PFUser, message: String) {
        user.fetchIfNeededInBackgroundWithBlock({ (fetchedUser, error) -> Void in
            self.avatarImageView.af_setImageWithURL(UserClient.getAvatarUrlFor(email: user.email!), filter: self.filter)
            self.usernameLabel.text = user.username
        })
        messageLabel.text = message
        addLayout(user == PFUser.currentUser())
    }
}

extension ChatMessageTableViewCell {
    var messageLabel: UILabel! {
        if _messageLabel == nil {
            let v = UILabel()
            v.font = UIFont(name: "Avenir", size: 15)
            _messageLabel = v
        }
        return _messageLabel
    }

    var usernameLabel: UILabel! {
        if _usernameLabel == nil {
            let v = UILabel()
            v.font = UIFont(name: "Avenir-Heavy", size: 17)
            _usernameLabel = v
        }
        return _usernameLabel
    }

    var avatarImageView: UIImageView! {
        if _avatarImageView == nil {
            let v = UIImageView()
            v.af_setImageWithURL(UserClient.getAvatarUrl(), filter: filter)
            _avatarImageView = v
        }
        return _avatarImageView
    }
}
