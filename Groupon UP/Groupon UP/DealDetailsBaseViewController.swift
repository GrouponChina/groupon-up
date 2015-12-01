//
//  DealDetailsBaseViewController.swift
//  Groupon UP
//
//  Created by Ping Zhang on 11/29/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit

class DealDetailsBaseViewController: BaseViewController {
    private var _scrollView: UIScrollView!
    private var _anchorView: UIView!
    private var _contentView: UIView!
    
    private var _dealImageView: UIImageView!
    private var _dealInfo: UIView!
    private var _dealTitle: UILabel!
    private var _dealExpireDate: UILabel!
    private var _dealStatusView: UIView!
    private var _bottomToolbar: UIView!
    
    var selectedDeal: Deal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubviews() {
        view.addSubview(anchorView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)

        contentView.addSubview(dealImageView)
        contentView.addSubview(dealInfo)
        dealInfo.addSubview(dealTitle)
        dealInfo.addSubview(dealExpireDate)
        contentView.addSubview(dealStatusView)
        view.addSubview(bottomToolbar)
    }
    
    override func addLayouts() {
        view.backgroundColor = UIColor.whiteColor()
        bottomToolbar.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        anchorView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom)//.offset(64) //Nav bar height without hardcoded??
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(bottomToolbar.snp_top)
        }
        
        scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(anchorView.snp_top)
            make.left.equalTo(anchorView.snp_left)
            make.right.equalTo(anchorView.snp_right)
            make.bottom.equalTo(anchorView.snp_bottom)
        }
        
        //tell scrollView the framesize it should be
        //this is not the constaints of contentView
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView)
            make.left.equalTo(scrollView)
            make.right.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
        }
        //this is used to constraint the contentView
        contentView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(anchorView)
        }
        
        dealImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(UPDealDetailsBase.offset)
            make.left.equalTo(contentView).offset(UPDealDetailsBase.offset)
            make.right.equalTo(contentView).offset(-UPDealDetailsBase.offset)
            make.height.equalTo(UPDealDetailsBase.imageHeight)
        }
        dealInfo.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dealImageView.snp_bottom)
            make.left.equalTo(dealImageView.snp_left)
            make.right.equalTo(dealImageView.snp_right)
            make.height.equalTo(UPDealDetailsBase.dealInfoHeight)
        }
        dealTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dealInfo).offset(UPDealDetailsBase.titleOffset)
            make.left.equalTo(dealInfo).offset(UPDealDetailsBase.titleOffset)
            make.right.equalTo(dealInfo).offset(-UPDealDetailsBase.titleOffset)
        }
        dealExpireDate.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dealTitle.snp_bottom).offset(UPDealDetailsBase.subOffset)
            make.right.equalTo(dealTitle.snp_right)
        }
        
        dealStatusView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dealInfo.snp_bottom)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    override func initializeUI() {
        setDeal(selectedDeal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DealDetailsBaseViewController {
    func setDeal(deal: Deal) {
        let imageNsUrl = NSURL(string: deal.dealImages.grid6ImageUrl)!
        dealImageView.af_setImageWithURL(imageNsUrl)
        dealTitle.text = deal.announcementTitle
        dealExpireDate.text = deal.expiresAt
    }
}

extension DealDetailsBaseViewController {
    var scrollView: UIScrollView {
        if _scrollView == nil {
            _scrollView = UIScrollView()
        }
        return _scrollView
    }
    
    var anchorView: UIView {
        if _anchorView == nil {
            _anchorView = UIView()
        }
        return _anchorView
    }
    
    var contentView: UIView {
        if _contentView == nil {
            _contentView = UIView()
        }
        return _contentView
    }
}

extension DealDetailsBaseViewController {
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
            _dealTitle.font = UPDealDetailsBase.titleFont
            _dealTitle.numberOfLines = 2
        }
        return _dealTitle
    }
    
    var dealExpireDate: UILabel {
        if _dealExpireDate == nil {
            _dealExpireDate = UILabel()
            _dealExpireDate.font = UPDealDetailsBase.expiredAtFont
            _dealExpireDate.textColor = UPDealDetailsBase.expiredAtFontColor
        }
        return _dealExpireDate
    }
    
    var dealStatusView: UIView! {
        if _dealStatusView == nil {
            _dealStatusView = getDealStatusView()
        }
        return _dealStatusView
    }
    
    var bottomToolbar: UIView! {
        if _bottomToolbar == nil {
            _bottomToolbar = getBottomToolbar()
        }
        return _bottomToolbar
    }
    
    // Override point for providing a deal specific status view
    func getDealStatusView() -> UIView {
        return UIView()
    }
    
    func getBottomToolbar() -> UIView {
        return UIView()
    }
}
