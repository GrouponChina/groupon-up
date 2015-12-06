//
//  UpInvitation.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/30/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import UIKit
import Parse

class UpInvitation {
    private var _createdByUsername: String!
    
    var associatedDeal: Deal?
    
    var object: PFObject
    var upId: String! {
        return object.objectId!
    }
    var message: String! {
        return object["message"] as! String
    }
    var date: NSDate! {
        return object["grouponUPDate"] as! NSDate
    }
    var dealId: String! {
        return object["dealId"] as! String
    }
    var createdByUserId: String! {
        return object["createdBy"] as! String
    }
    var createdByUsername: String {
        if _createdByUsername == nil {
            do {
                let user = try PFUser.query()?.whereKey("objectId", equalTo: createdByUserId).getFirstObject()
                _createdByUsername =  user!["username"] as! String
            }
            catch {
                return ""
            }
        }
        return _createdByUsername
    }
    var openEnroll: Bool! {
        return object["openEnroll"].boolValue
    }
    var rsvps: [UpRSVP]?
    var acceptedByUsers: [String] = []
    
    init(up: PFObject) {
        object = up
        fetchEnrolledUsers { (rsvps: [UpRSVP]?, error: NSError?) -> Void in
            if (error != nil) {
                print("[ERROR] Unable to fetch rsvps on existing Groupon UP")
            }
            else {
                if (rsvps != nil) {
                    for rsvp in rsvps! {
                        self.acceptedByUsers.append(rsvp.username)
                    }
                    print("[API-SUCCESS] Fetched \(rsvps!.count) rsvps on existing Groupon UP")
                }
            }
        }
    }
    
    static func findAllUpInvitationsCreatedByUser(userId: String, completion: ([UpInvitation], NSError?) -> Void) -> Void {
        let query = PFQuery(className: "GrouponUP")
        query.whereKey("createdBy", equalTo: userId)
        query.findObjectsInBackgroundWithBlock { (ups: [PFObject]?, error: NSError?) -> Void in
            if let _ = error {
                completion([], error)
            }
            else {
                var upInvitations: [UpInvitation] = []
                if let ups = ups {
                    for up in ups {
                        upInvitations.append(UpInvitation(up: up))
                    }
                }
                completion(upInvitations, nil)
            }
        }
    }
    
    func fetchEnrolledUsers(callback: ([UpRSVP]?, NSError?) -> Void) {
        let subquery = PFQuery(className: "UserUP")
        subquery.whereKey("grouponUPID", equalTo: upId)
        
        let query = PFUser.query()!
        query.whereKey("objectId", matchesKey: "userID", inQuery: subquery)
        
        query.findObjectsInBackgroundWithBlock({ (rsvps: [PFObject]?, error: NSError?) -> Void in
            if let _ = error {
                callback(nil, error)
            }
            if let rsvps = rsvps where rsvps.count > 0 {
                self.rsvps = rsvps.map({ (rsvp) -> UpRSVP in
                    UpRSVP(rsvp: rsvp)
                })
            } else {
                self.rsvps = [UpRSVP]()
            }
            callback(self.rsvps, nil)
        })
    }
}

class UpRSVP {
    var object: PFObject
    var rsvpId: String! {
        return object.objectId!
    }
    var userId: String! {
        return object["userID"].stringValue
    }
    var username: String! {
        return object["username"] as! String
    }
    var upId: String! {
        return object["grouponUPID"].stringValue
    }
    var rsvpedAt: NSDate! {
        return object.createdAt!
    }
    
    init(rsvp: PFObject) {
        object = rsvp
    }
    
    static func findAllUpRsvpReceivedByUser(userId: String, completion: ([UpInvitation], NSError?) -> Void) -> Void {
        let subquery = PFQuery(className: "UserUP")
        subquery.whereKey("userID", equalTo: userId)
        let query = PFQuery(className: "GrouponUP")
        query.whereKey("objectId", matchesKey: "grouponUPID", inQuery: subquery)
        query.findObjectsInBackgroundWithBlock { (ups: [PFObject]?, error: NSError?) -> Void in
            if let _ = error {
                print(error)
                completion([], error)
            }
            else {
                var upInvitations: [UpInvitation] = []
                if let ups = ups {
                    for up in ups {
                        upInvitations.append(UpInvitation(up: up))
                    }
                }
                completion(upInvitations, nil)
            }
        }
    }
}

enum UpType: Int {
    case Inviting = 0
    case Invited = 1
}
