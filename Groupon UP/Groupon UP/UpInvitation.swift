//
//  UpInvitation.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/30/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class UpInvitation: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "UpInvitation"
    }
    
    @NSManaged var message: String
    @NSManaged var date: NSDate
    @NSManaged var createdBy: PFUser
    @NSManaged var dealId: String
    @NSManaged var openEnroll: Bool
    @NSManaged var rsvps: [PFUser]

    var associatedDeal: Deal?
    
    static func fetchUpInvitationFor(user user: PFUser, callback: ([UpInvitation]?, NSError?) -> Void) {
        let myUpQuery = UpInvitation.query()!
        myUpQuery.whereKey("createdBy", equalTo: user)
        let myRSVPQuery = UpInvitation.query()!
        myRSVPQuery.whereKey("rsvps", equalTo: user)
        let query = PFQuery.orQueryWithSubqueries([myRSVPQuery, myUpQuery])
        query.includeKey("rsvps")
        query.includeKey("createdBy")
        query.findObjectsInBackgroundWithBlock { (upInvitations, error) -> Void in
            if let upInvitations = upInvitations?.map({ $0 as! UpInvitation}) {
                callback(upInvitations, nil)
            } else {
                callback(nil, error)
            }
        }
    }

    static func fetchUpInvitationsNotBy(user user: PFUser, callback: ([UpInvitation]?, NSError?) -> Void) {
        let query = UpInvitation.query()!
        query.whereKey("createdBy", notEqualTo: user)
        query.whereKey("rsvps", notEqualTo: user)
        query.includeKey("rsvps")
        query.includeKey("createdBy")
        query.findObjectsInBackgroundWithBlock { (upInvitations, error) -> Void in
            if let upInvitations = upInvitations?.map({ $0 as! UpInvitation}) {
                callback(upInvitations, nil)
            } else {
                callback(nil, error)
            }
        }
    }
}

enum UpType: Int {
    case Inviting = 0
    case Invited = 1
}
