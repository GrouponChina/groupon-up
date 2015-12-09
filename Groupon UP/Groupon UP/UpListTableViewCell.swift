//
//  UpListTableViewCell.swift
//  Groupon UP
//
//  Created by Ping Zhang on 12/5/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

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
        self.addSubview(contentView)
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
            make.right.equalTo(contentView).offset(-UPDeal.offset)
        }

        upDatelabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(dealNameLabel)
            make.right.greaterThanOrEqualTo(contentView).offset(-UPDeal.offset)
            make.bottom.equalTo(contentView).offset(-4)
        }

        upStatusLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(dealNameLabel)
            make.right.greaterThanOrEqualTo(contentView).offset(-UPDeal.offset)
            make.bottom.equalTo(upDatelabel.snp_top)
        }

        contentView.backgroundColor = UPDeal.backgroundColor
        contentView.layer.shadowColor = UIColor.grayColor().CGColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSizeZero
        contentView.layer.shadowRadius = 3

        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self)
        }
    }
    
    func setDeal(deal: Deal) {
        let size = CGSize(width: 80, height: 100)
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: size,
            radius: 0.0
        )
        dealImage.af_setImageWithURL(
            NSURL(string: deal.dealImages.sidebarImageUrl)!,
            filter: filter
        )
        
        dealNameLabel.text = deal.title
        
        upStatusLabel.text = deal.shortAnnouncementTitle
        upDatelabel.text = deal.expiresAt
        upDatelabel.textColor = UPUrgencyOrange
    }
    
    
    func setUpInfo(up: UpInvitation, upType: UpType) {
        let size = CGSize(width: 80, height: 100)
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: size,
            radius: 0.0
        )
        
        if up.associatedDeal == nil {
            DealClient.getDealByDealId(up.dealId) { (deal: Deal?, _) in
                if let deal = deal {
                    up.associatedDeal = deal
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dealImage.af_setImageWithURL(
                            NSURL(string: up.associatedDeal!.dealImages.sidebarImageUrl)!,
                            filter: filter
                        )
                        self.dealNameLabel.text = up.associatedDeal!.title
                    }
                }
            }
        }
        else {
            dealImage.af_setImageWithURL(
                NSURL(string: up.associatedDeal!.dealImages.sidebarImageUrl)!,
                filter: filter
            )
            dealNameLabel.text = up.associatedDeal!.title
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        upDatelabel.text = dateFormatter.stringFromDate(up.date)
        
        switch upType {
        case .Inviting:
            let usernames = up.rsvps.map({ return $0.username! })
            if usernames.isEmpty {
                self.upStatusLabel.text = "Pending"
            } else {
                let acceptedBy = usernames.joinWithSeparator(", ")
                self.upStatusLabel.text = "Accepted by " + acceptedBy
            }
        case .Invited:
            upStatusLabel.text = "Created by " + up.createdBy.username!
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