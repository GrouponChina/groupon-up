//
//  UpListTableViewCell.swift
//  Groupon UP
//
//  Created by Ping Zhang on 12/5/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class UpListTableViewCell: UITableViewCell {
    private var _dealImage: UIImageView!
    private var _dealNameLabel: UILabel!
    private var _upStatusLabel: UILabel!
    private var _upDatelabel: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addLayout()
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addSubviews() {
        contentView.addSubview(dealImage)
        contentView.addSubview(dealNameLabel)
        contentView.addSubview(upStatusLabel)
        contentView.addSubview(upDatelabel)
    }
    
    func addLayout() {
        dealImage.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.width.equalTo(80)
            make.height.equalTo(100)
            make.bottom.equalTo(contentView)
        }
        
        dealNameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(4)
            make.left.equalTo(dealImage.snp_right).offset(UpListCell.span)
            make.right.equalTo(contentView).offset(-8)
        }

        upStatusLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dealNameLabel.snp_bottom)
            make.left.equalTo(dealNameLabel)
            make.right.greaterThanOrEqualTo(contentView).offset(-8)
        }
        
        upDatelabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(upStatusLabel.snp_bottom)
            make.left.equalTo(dealNameLabel)
            make.right.greaterThanOrEqualTo(contentView).offset(-8)
            make.bottom.lessThanOrEqualTo(contentView).offset(-8)
        }
        
        contentView.layer.borderColor = UIColor.blackColor().CGColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 3
        contentView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(10.5, 15, 0.5, CGFloat(15)))
        }
    }
    
    func setUpInfo(up: UpInvitation, upType: UpType) {
        if let associatedDeal = up.associatedDeal {
            dealImage.af_setImageWithURL(NSURL(string: associatedDeal.dealImages.sidebarImageUrl)!)
            dealNameLabel.text = associatedDeal.title
            let upDate = up.date.description
            let dataRange = upDate.startIndex..<upDate.startIndex.advancedBy(10)
            upDatelabel.text = "Up date: " + upDate.substringWithRange(dataRange)
            
            switch upType {
            case .Inviting:
                let acceptedBy = up.acceptedByUsers.joinWithSeparator(", ")
                upStatusLabel.text = "Accepted by " + acceptedBy
            case .Invited:
                upStatusLabel.text = "Created by " + up.createdByUsername
            }
        }
    }
}

extension UpListTableViewCell {
    var dealImage: UIImageView {
        if _dealImage == nil {
            _dealImage = UIImageView()
        }
        return _dealImage
    }
    
    var dealNameLabel: UILabel {
        if _dealNameLabel == nil {
            _dealNameLabel = UILabel()
            _dealNameLabel.font = UpListCell.titleFont
            _dealNameLabel.numberOfLines = 2
        }
        return _dealNameLabel
    }
    
    var upStatusLabel: UILabel {
        if _upStatusLabel == nil {
            _upStatusLabel = UILabel()
            _upStatusLabel.numberOfLines = 2
            _upStatusLabel.font = UpListCell.otherFont
            _upStatusLabel.textColor = UpListCell.otherFontColor
        }
        return _upStatusLabel
    }
    
    var upDatelabel: UILabel {
        if _upDatelabel == nil {
            _upDatelabel = UILabel()
            _upDatelabel.numberOfLines = 1
            _upDatelabel.font = UpListCell.otherFont
            _upDatelabel.textColor = UpListCell.otherFontColor
        }
        return _upDatelabel
    }
}