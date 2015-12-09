//
//  BrowseViewController.swift
//  Groupon UP
//
//  Created by Ping Zhang on 12/7/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import SnapKit
import Alamofire
import SwiftyJSON

class BrowseViewController: UIViewController {
    private var _tableView: UITableView!
    private var _refreshController: UIRefreshControl!
    var deals: [Deal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    
    func addSubViews() {
        view.addSubview(tableView)
        tableView.addSubview(refreshController)
    }
    
    func addLayout() {
        navigationItem.title = "GROUPON"
        view.backgroundColor = UIColor.whiteColor()
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
        }
    }
    
    func initData() {
        makeGetDealsRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BrowseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseId = "DealTableViewCell"
        let cell: DealTableViewCell
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? DealTableViewCell {
            cell = reuseCell
        }
        else {
            cell = DealTableViewCell(style: .Subtitle, reuseIdentifier: reuseId)
        }
        let deal = deals[indexPath.row]
        cell.setDeal(deal)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dealDetailView = DealDetailsViewController()
        dealDetailView.selectedDeal = deals[indexPath.row]
        dealDetailView.buyItNow = true
        navigationController?.pushViewController(dealDetailView, animated: true)
    }
}

extension BrowseViewController {
    var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView()
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            _tableView.estimatedRowHeight = 300
            _tableView.rowHeight = UITableViewAutomaticDimension
        }
        return _tableView
    }
    
    var refreshController: UIRefreshControl {
        if _refreshController == nil {
            _refreshController = UIRefreshControl()
            _refreshController.tintColor = UIColor.whiteColor()
            _refreshController.addTarget(self, action: "refreshView", forControlEvents: .ValueChanged)
        }
        return _refreshController
    }
}

extension BrowseViewController {
    func makeGetDealsRequest() {
        DealClient.getDivisionDeals { (deals: [Deal]!) -> Void in
            self.deals = deals
            self.tableView.reloadData()
        }
    }
    
    func fakeDeals() -> [Deal] {
        let deal = Deal()
        
        deal.uuid = "5b1d966e-78b0-214c-1de7-0ce7b1eb0323"
        deal.title = "Medieval Times – Tournament Dinner and Show with Optional VIP Package through January 31"
        deal.announcementTitle = "Medieval Times – Tournament Dinner and Show with Optional VIP Package Up to 49% Off"
        deal.shortAnnouncementTitle = "Medieval Times"
        deal.soldQuantity = "1000"
        deal.soldQuantityMessage = "1,000 +"
        deal.status = "Open"
        deal.price = "$26.00"
        deal.value = "$43.78"
        let dealImage = DealImages()
        dealImage.grid6ImageUrl = "https://img.grouponcdn.com/deal/sHHKA7Hp8ZxUfC9gyeH7/XT-2048x1229/v1/t460x279.jpg"
        deal.dealImages = dealImage
        deal.divisionId = "chicago"
        deal.expiresAt = "2016-02-01T05:59:59Z"
        
        let deal2 = Deal()
        
        deal2.uuid = "5b1d966e-78b0-214c-1de7-0ce7b1eb0000"
        deal2.title = "Medieval Times – Tournament Dinner and Show with Optional VIP Package through January 31"
        deal2.announcementTitle = "Medieval Times – Tournament Dinner and Show with Optional VIP Package Up to 49% Off"
        deal2.shortAnnouncementTitle = "Medieval Times"
        deal2.soldQuantity = "1000"
        deal2.soldQuantityMessage = "1,000 +"
        deal2.status = "Open"
        deal2.price = "$26.00"
        deal2.value = "$43.78"
        let dealImage2 = DealImages()
        dealImage2.grid6ImageUrl = "https://img.grouponcdn.com/deal/v9PmBBAMideA7CzMedaa/Bf-2048x1229/v1/t460x279.jpg"
        deal2.dealImages = dealImage2
        deal2.divisionId = "chicago"
        deal2.expiresAt = "2016-02-01T05:59:59Z"
        
        return [deal, deal2, deal]
    }
    
    func refreshView() {
        refreshController.beginRefreshing()
        initData()
        refreshController.endRefreshing()
    }
}
