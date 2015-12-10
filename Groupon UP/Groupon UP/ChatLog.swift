//
//  ChatLog.swift
//  Groupon UP
//
//  Created by Robert Xue on 12/8/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Parse

class ChatLog: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Chat"
    }
    
    @NSManaged var user: PFUser
    @NSManaged var invitation: UpInvitation
    @NSManaged var message: String
    
    static func fetchChatFor(invitation invitation: UpInvitation, callback: ([ChatLog]?, NSError?) -> Void) {
        let query = ChatLog.query()!
        query.whereKey("invitation", equalTo: invitation)
        query.findObjectsInBackgroundWithBlock { (chatLogs, error) -> Void in
            if let chatLogs = chatLogs?.map({ $0 as! ChatLog}) {
                callback(chatLogs.sort({ (left, right) -> Bool in
                    return left.createdAt!.timeIntervalSince1970 < right.createdAt!.timeIntervalSince1970
                }), nil)
            } else {
                callback(nil, error)
            }
        }
    }
}

