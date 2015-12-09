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
import Parse

class OrderViewController: UIViewController {
    private var _tableView: UITableView!
    private var _refreshController: UIRefreshControl!
    var orders: [Order] = []
    
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
        navigationItem.title = "MY GROUPONS"
        view.backgroundColor = UPBackgroundGrayColor
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop).offset(-10)
        }
    }
    
    func initData() {
        makeGetOrdersRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseId = "UpListTableViewCell"
        let cell: UpListTableViewCell
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? UpListTableViewCell {
            cell = reuseCell
        }
        else {
            cell = UpListTableViewCell(style: .Subtitle, reuseIdentifier: reuseId)
        }
        let order = orders[indexPath.row]
        if order.associatedDeal == nil {
            DealClient.getDealByDealId(order.dealId) { (deal: Deal?, _) in
                if let deal = deal {
                    dispatch_async(dispatch_get_main_queue()) {
                        order.associatedDeal = deal
                        cell.setDeal(order.associatedDeal!)
                    }
                }
            }
        }
        else {
            cell.setDeal(order.associatedDeal!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dealDetailView = DealDetailsViewController()
        dealDetailView.selectedDeal = orders[indexPath.row].associatedDeal!
        navigationController?.pushViewController(dealDetailView, animated: true)
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
            _tableView.backgroundColor = UIColor.clearColor()
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

extension OrderViewController {
    func makeGetOrdersRequest() {
        Order.findOrdersByUserId(PFUser.currentUser()!.objectId!) { (orders: [Order], error: NSError?) in
            self.orders = orders
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
        }
    }
    
    func refreshView() {
        refreshController.beginRefreshing()
        initData()
        
    }
}