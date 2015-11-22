//
//  Deal.swift
//  Groupon UP
//
//  Created by Ping Zhang on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Foundation
import SwiftyJSON

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
        dealImages = DealImages(dealData: dealData)
        divisionId = dealData["division"]["id"].stringValue
    }
    
    static func deals(dealDataArray: JSON) -> [Deal] {
        var deals = [Deal]()
        for (_, subJson): (String, JSON)  in dealDataArray {
            deals.append(Deal(dealData: subJson))
        }
        return deals
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