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
    var object: PFObject
    var upId: String! {
        return object.objectId!
    }
    var message: String! {
        return object["message"].stringValue
    }
    var date: NSDate! {
        return object["grouponUPDate"] as! NSDate
    }
    var dealId: String! {
        return object["dealId"].stringValue
    }
    var createdByUserId: String! {
        return object["createdBy"].stringValue
    }
    var openEnroll: Bool! {
        return object["openEnroll"].boolValue
    }
    var rsvps: [UpRSVP]?
    
    init(up: PFObject) {
        object = up
    }
    
    func fetchEnrolledUsers(callback: ([UpRSVP]?, NSError?) -> Void) {
        PFQuery(className: "UserUP").whereKey("grouponUPID", equalTo: upId).findObjectsInBackgroundWithBlock({ (rsvps, error) -> Void in
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
    var upId: String! {
        return object["grouponUPID"].stringValue
    }
    var rsvpedAt: NSDate! {
        return object.createdAt!
    }
    
    init(rsvp: PFObject) {
        object = rsvp
    }
}
