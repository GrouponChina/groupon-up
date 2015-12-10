//
//  DealTableViewCell.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import AlamofireImage

class DealTableViewCell: UITableViewCell {
    private var _cellContentView: UIView!
    private var _dealImageView: UIImageView!
    private var _dealInfo: UIView!
    private var _dealTitle: UILabel!
    private var _dealDivision: UILabel!
    private var _value: UILabel!
    private var _soldQuantityMessage: UILabel!
    private var _dealPrice: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addLayout()
    }
    
    func addSubviews() {
        addSubview(cellContentView)

        cellContentView.addSubview(dealImageView)
        cellContentView.addSubview(dealInfo)
        
        dealInfo.addSubview(dealTitle)
        dealInfo.addSubview(dealDivision)
        dealInfo.addSubview(value)
        dealInfo.addSubview(soldQuantityMessage)
        dealInfo.addSubview(dealPrice)
    }
    
    func addLayout() {
        cellContentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(UPDeal.offset)
            make.left.equalTo(self).offset(UPDeal.offset)
            make.right.equalTo(self).offset(-UPDeal.offset)
            make.bottom.equalTo(self).offset(-UPDeal.offset)
            make.height.equalTo(285)
        }

        dealImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cellContentView)
            make.left.equalTo(cellContentView)
            make.right.equalTo(cellContentView)
            make.height.equalTo(UPDeal.imageHeight)
            make.bottom.lessThanOrEqualTo(self).offset(-UPDeal.dealInfoHeight)
        }
        
        dealInfo.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dealImageView.snp_bottom)
            make.left.equalTo(dealImageView.snp_left)
            make.right.equalTo(dealImageView.snp_right)
        }
        
        dealTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dealInfo).offset(UPDeal.titleOffset)
            make.left.equalTo(dealInfo).offset(UPDeal.titleOffset)
            make.right.equalTo(dealInfo).offset(-UPDeal.titleOffset)
        }
        
        dealDivision.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(soldQuantityMessage.snp_top).offset(-2)
            make.left.equalTo(dealTitle.snp_left)
            make.height.equalTo(UPDeal.divisionHeight)
        }
        
        value.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(dealPrice.snp_top)
            make.right.equalTo(dealTitle.snp_right)
            make.height.equalTo(UPDeal.valueHeight)
        }
        
        soldQuantityMessage.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cellContentView.snp_bottom).offset(-12)
            make.left.equalTo(dealDivision.snp_left)
        }
        
        dealPrice.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(dealTitle.snp_right)
            make.bottom.equalTo(cellContentView.snp_bottom).offset(-UPDeal.offset)
        }
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
    }
    
    
    func setDeal(deal: Deal) {
        let imageNsUrl = NSURL(string: deal.dealImages.grid6ImageUrl)!
        dealImageView.af_setImageWithURL(imageNsUrl)
        
        dealTitle.text = deal.announcementTitle
        
        dealDivision.text = deal.divisionId
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: deal.value)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        value.attributedText = attributeString
        
        soldQuantityMessage.text = deal.soldQuantityMessage + " Bought"
        dealPrice.text = deal.price
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension DealTableViewCell {
    var cellContentView: UIView {
        if _cellContentView == nil {
            _cellContentView = UIView()
            _cellContentView.backgroundColor = UIColor.whiteColor()

            _cellContentView.layer.shadowColor = UIColor.grayColor().CGColor
            _cellContentView.layer.shadowOpacity = 1
            _cellContentView.layer.shadowOffset = CGSizeZero
            _cellContentView.layer.shadowRadius = 2

            _cellContentView.translatesAutoresizingMaskIntoConstraints = true
        }
        return _cellContentView
    }

    var dealImageView: UIImageView {
        if _dealImageView == nil {
            _dealImageView = UIImageView()
            _dealImageView.contentMode = .ScaleToFill
        }

        return _dealImageView
    }
    
    var dealInfo: UIView {
        if _dealInfo == nil {
            _dealInfo = UIView()
            _dealInfo.backgroundColor = UIColor.whiteColor()
        }
        return _dealInfo
    }
    
    var dealTitle: UILabel {
        if _dealTitle == nil {
            _dealTitle = UILabel()
            _dealTitle.font = UPDeal.titleFont
            _dealTitle.numberOfLines = 2
        }
        return _dealTitle
    }
    
    var dealDivision: UILabel {
        if _dealDivision == nil {
            _dealDivision = UILabel()
            _dealDivision.font = UPDeal.otherFont
            _dealDivision.textColor = UPDeal.otherFontColor
        }
        return _dealDivision
    }
    
    var value: UILabel {
        if _value == nil {
            _value = UILabel()
            _value.font = UPDeal.otherFont
            _value.textColor = UPDeal.otherFontColor
        }
        return _value
    }
    
    var soldQuantityMessage: UILabel {
        if _soldQuantityMessage == nil {
            _soldQuantityMessage = UILabel()
            _soldQuantityMessage.font = UPDeal.otherFont
            _soldQuantityMessage.textColor = UPDeal.otherFontColor
        }
        return _soldQuantityMessage
    }
    
    var dealPrice: UILabel {
        if _dealPrice == nil {
            _dealPrice = UILabel()
            _dealPrice.font = UPDeal.priceFont
            _dealPrice.textColor = UPDeal.priceFontColor
        }
        return _dealPrice
    }
}