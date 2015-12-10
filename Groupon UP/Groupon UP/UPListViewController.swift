//
//  UPListViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class UPListViewController: BaseViewController {
    private var _segmentedControl: UISegmentedControl!
    private var _tableView: UITableView!
    private var _refreshController: UIRefreshControl!
    
    var selectedSegmentIndex = 0
    var invitingUps: [UpInvitation] = []
    var invitedUps: [UpInvitation] = []
    
    var grouponUps: [UpInvitation] {
        get {
            switch selectedSegmentIndex {
            case 0:
                return invitingUps
            case 1:
                return invitedUps
            default:
                return invitingUps
            }
        }
        set {
            switch selectedSegmentIndex {
            case 0:
                invitingUps = newValue
            case 1:
                invitedUps = newValue
            default:
                invitingUps = newValue
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UPBackgroundGrayColor

        addSubViews()
        addLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    
    func addSubViews() {
        navigationItem.title = "MY GROUPON UP"
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        tableView.addSubview(refreshController)
    }
    
    func addLayout() {
        segmentedControl.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(-1)
            make.left.equalTo(view).offset(-UPDeal.offset)
            make.right.equalTo(view).offset(UPDeal.offset)
            make.height.equalTo(40)
        }

        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControl.snp_bottom).offset(0)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop).offset(-10)
        }
    }
    
    func initData() {
        grouponUps = []
        tableView.reloadData()
        switch selectedSegmentIndex {
        case 1:
            loadInvitedUps()
        default:
            loadInvitingUps()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UPListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grouponUps.count
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
        let grouponUp = grouponUps[indexPath.row]
        cell.setUpInfo(grouponUp, upType: UpType(rawValue: selectedSegmentIndex)!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dealDetailView = DealDetailsViewController()
        dealDetailView.selectedDeal = grouponUps[indexPath.row].associatedDeal
        dealDetailView.buyItNow = "invited"

        navigationController?.pushViewController(dealDetailView, animated: true)
    }
}

extension UPListViewController {
    func didPressSegment(sender: UISegmentedControl) {
        grouponUps = []
        switch sender.selectedSegmentIndex {
        case 1:
            selectedSegmentIndex = 1
            loadInvitedUps()
        default:
            selectedSegmentIndex = 0
            loadInvitingUps()
        }
        tableView.reloadData()
    }
    
    func loadInvitingUps() {
        UpInvitation.fetchUpInvitationFor(user: PFUser.currentUser()!) { (upInvitations, _) in
            if let upInvitations = upInvitations {
                self.invitingUps = upInvitations
                self.tableView.reloadData()
            }
            self.refreshController.endRefreshing()
        }
    }
    
    func loadInvitedUps() {
        UpInvitation.fetchUpInvitationsNotBy(user: PFUser.currentUser()!){ (upInvitations, _) in
            if let upInvitations = upInvitations {
                self.invitedUps = upInvitations
                self.tableView.reloadData()
            }
            self.refreshController.endRefreshing()
        }
    }
}

extension UPListViewController {
    var segmentedControl: UISegmentedControl {
        if _segmentedControl == nil {
            let controls = ["Inviting", "Invited"]
            _segmentedControl = UISegmentedControl(items: controls)
            _segmentedControl.selectedSegmentIndex = 0
            _segmentedControl.layer.borderWidth = 0
            _segmentedControl.layer.borderColor = UPTintColor.CGColor
            _segmentedControl.tintColor = UPBackgroundGrayColor
            _segmentedControl.backgroundColor = UPTintColor
            _segmentedControl.setTitleTextAttributes([NSFontAttributeName: UpListCell.segmentFont!],
                forState: UIControlState.Normal)
            _segmentedControl.addTarget(self, action: "didPressSegment:", forControlEvents: .ValueChanged)
        }
        return _segmentedControl
    }
    var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView()
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            _tableView.estimatedRowHeight = 200
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

extension UPListViewController {
    func refreshView() {
        refreshController.beginRefreshing()
        initData()
    }
}
