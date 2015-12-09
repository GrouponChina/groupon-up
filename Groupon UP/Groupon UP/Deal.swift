//
//  Deal.swift
//  Groupon UP
//
//  Created by Ping Zhang on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Foundation
import SwiftyJSON
import Parse



class Deal {
    var uuid :String!
    var title :String!
    var announcementTitle :String!
    var shortAnnouncementTitle :String!
    var soldQuantity :String!
    var soldQuantityMessage :String!
    var status :String!
    var price: String!
    var value: String!
    var dealImages: DealImages!
    var divisionId: String!
    var expiresAt: String = "Never Expires"
    var up: UpInvitation?
    
    var upStatus: DealUpStatus {
        guard let up = up else {
            return .None
        }
        //TODO: Check for redeem status
        //if redeemed {
        //    return .Redeemed
        //}
        if up.date.timeIntervalSinceNow < 0 {
            return .Expired
        }
        if !up.openEnroll {
            return .Confirmed
        }
        return .Active
    }
    
    init() {
        
    }
    
    init(dealData: JSON) {
        uuid = dealData["uuid"].stringValue
        title = dealData["title"].stringValue
        announcementTitle = dealData["announcementTitle"].stringValue
        shortAnnouncementTitle = dealData["shortAnnouncementTitle"].stringValue
        soldQuantity = dealData["soldQuantity"].stringValue
        soldQuantityMessage = dealData["soldQuantityMessage"].stringValue
        status = dealData["status"].stringValue
        let options = dealData["options"]
        price = options[0]["price"]["formattedAmount"].stringValue
        value = options[0]["value"]["formattedAmount"].stringValue
        
        let fullLengthExpiresAt = options[0]["expiresAt"].stringValue
        if !fullLengthExpiresAt.isEmpty {
            let dataRange = fullLengthExpiresAt.startIndex..<fullLengthExpiresAt.startIndex.advancedBy(10)
            expiresAt = "Expires at: " + fullLengthExpiresAt.substringWithRange(dataRange)
        }
        dealImages = DealImages(dealData: dealData)
        divisionId = dealData["division"]["name"].stringValue
    }
    
    static func deals(dealDataArray: JSON) -> [Deal] {
        var deals = [Deal]()
        for (_, subJson): (String, JSON)  in dealDataArray {
            deals.append(Deal(dealData: subJson))
        }
        return deals
    }
    
    func getUpForDeal(callback: (UpInvitation?, NSError?) -> Void) {
        let query = UpInvitation.query()!
        query.whereKey("dealId", equalTo: uuid)
        query.getFirstObjectInBackgroundWithBlock { (up, error) -> Void in
            if let _ = error {
                callback(nil, error)
            }
            if let up = up {
                self.up = up as? UpInvitation
            }
            callback(self.up, error)
        }
    }
}


class DealImages {
    var placeholderUrl: String!
    var grid4ImageUrl: String!
    var grid6ImageUrl: String!
    var largeImageUrl: String!
    var mediumImageUrl: String!
    var smallImageUrl: String!
    var sidebarImageUrl: String!
    
    init() {
        
    }
    
    init(dealData: JSON) {
        placeholderUrl = dealData["placeholderUrl"].stringValue
        grid4ImageUrl = dealData["grid4ImageUrl"].stringValue
        grid6ImageUrl = dealData["grid6ImageUrl"].stringValue
        largeImageUrl = dealData["largeImageUrl"].stringValue
        mediumImageUrl = dealData["mediumImageUrl"].stringValue
        smallImageUrl = dealData["smallImageUrl"].stringValue
        sidebarImageUrl = dealData["sidebarImageUrl"].stringValue
    }
}

enum DealUpStatus {
    // Nothing has happened at this state
    case None
    // Up has been created, some user has responded already. Can not cancel
    // `Confirm` -> Confirmed
    case Active
    // Up has been created, users are onboard, enrollment ended. Can not cancel
    // `Redeem` -> Redeemed
    // `Time > Exprie date` -> Expired
    case Confirmed
    // Up has been created, users are onboard, enrollment ended, groupon expired
    // Final state
    case Expired
    // Up has been created, users are onboard, enrollment ended, groupon redeemed
    // Final state
    case Redeemed
}