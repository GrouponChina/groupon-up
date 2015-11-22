//
//  OrderViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import SnapKit
import Alamofire
import SwiftyJSON

class OrderViewController: UIViewController {
    
    private var _tableView: UITableView!
    private var _refreshController: UIRefreshControl!
    var deals: [Deal] = []
    //var selectedEntree: Entree!
    
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

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    
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
//        cell.addToCart.tag = indexPath.row
//        cell.addToCart.addTarget(self, action: "addToCart:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.setDeal(deal)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let selectedEntree = deals[indexPath.row]
        //let entreeDetail = EntreeDetailViewController()
        //entreeDetail.selectedEntree = selectedEntree
        NSLog("didSelect")
        //self.navigationController?.pushViewController(entreeDetail, animated: true)
        
    }
}

extension OrderViewController {
    var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView()
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            _tableView.estimatedRowHeight = 300
            _tableView.rowHeight = UITableViewAutomaticDimension
            //_tableView.backgroundColor = FYMenu.backgroundColor
        }
        return _tableView
    }
    
    var refreshController: UIRefreshControl {
        if _refreshController == nil {
            _refreshController = UIRefreshControl()
            _refreshController.tintColor = UIColor.whiteColor()
//            let imageSize = CGSize(width: self.view.frame.width, height: 170.0)
//            let refreshBackground = Image.reSizeUIImage(UIImage(named: "fusionyo.png")!, scaledToSize: imageSize)
//            _refreshController.backgroundColor = UIColor(patternImage: refreshBackground)
            _refreshController.addTarget(self, action: "refreshView", forControlEvents: .ValueChanged)
        }
        return _refreshController
    }
}

extension OrderViewController {
    
    func makeGetDealsRequest() {
        //self.deals = fakeDeals()
        
        DealClient.getDivisionDeals { (deals: [Deal]!) -> Void in
            self.deals = deals
        }
    }
    
    func fakeDeals() -> [Deal] {
        var deal = Deal()
        
        deal.uuid = "5b1d966e-78b0-214c-1de7-0ce7b1eb0323"
        deal.title = "Medieval Times – Tournament Dinner and Show with Optional VIP Package through January 31"
        deal.announcementTitle = "Medieval Times – Tournament Dinner and Show with Optional VIP Package Up to 49% Off"
        deal.shortAnnouncementTitle = "Medieval Times"
        deal.soldQuantity = "1000"
        deal.soldQuantityMessage = "1,000 +"
        deal.status = "Open"
        deal.price = "$26.00"
        deal.value = "$43.78"
        var dealImage = DealImages()
        dealImage.grid6ImageUrl = "https://img.grouponcdn.com/deal/sHHKA7Hp8ZxUfC9gyeH7/XT-2048x1229/v1/t460x279.jpg"
        deal.dealImages = dealImage
        deal.divisionId = "chicago"
        
        return [deal, deal, deal]
    }
    
    func refreshView() {
        refreshController.beginRefreshing()
        tableView.reloadData()
        //initData()
        refreshController.endRefreshing()
    }
}