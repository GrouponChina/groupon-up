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
        addSubViews()
        addLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    
    func addSubViews() {
        navigationItem.title = "My Groupon Ups"
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        tableView.addSubview(refreshController)
    }
    
    func addLayout() {
        view.backgroundColor = UIColor.whiteColor()
        segmentedControl.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(2)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(40)
        }
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(segmentedControl.snp_bottom).offset(1)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
        }
    }
    
    func initData() {
        grouponUps = []
        tableView.reloadData()
        switch selectedSegmentIndex {
        case 0:
            loadInvitingUps()
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
}

extension UPListViewController {
    func didPressSegment(sender: UISegmentedControl) {
        grouponUps = []
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegmentIndex = 0
            loadInvitingUps()
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
        UpInvitation.findAllUpInvitationsCreatedByUser(PFUser.currentUser()!.objectId!) { (upInvitations: [UpInvitation], _) in
            self.invitingUps = upInvitations
            self.tableView.reloadData()
        }
    }
    
    func loadInvitedUps() {
        UpRSVP.findAllUpRsvpReceivedByUser(PFUser.currentUser()!.objectId!){ (upInvitations: [UpInvitation], _) in
            self.invitedUps = upInvitations
            self.tableView.reloadData()
        }
    }
}

extension UPListViewController {
    var segmentedControl: UISegmentedControl {
        if _segmentedControl == nil {
            let controls = ["Inviting", "Invited"]
            _segmentedControl = UISegmentedControl(items: controls)
            _segmentedControl.selectedSegmentIndex = 0
            _segmentedControl.layer.borderWidth = 0.5
            _segmentedControl.layer.borderColor = UIColor.blackColor().CGColor
            _segmentedControl.layer.cornerRadius = 3.0
            _segmentedControl.tintColor = UpListCell.segmentTintColor
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
        refreshController.endRefreshing()
    }
}
