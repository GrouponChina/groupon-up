//
//  Order.swift
//  Groupon UP
//
//  Created by Ping Zhang on 12/7/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Foundation
import Parse

class Order {
    var object: PFObject
    
    var orderId: String! {
        return object["objectId"] as! String
    }
    var userId: String! {
        return object["userID"] as! String
    }
    var dealId: String! {
        return object["dealID"] as! String
    }
    var grouponUpId: String! {
        return object["grouponUPID"] as! String
    }
    
    init(order: PFObject) {
        object = order
    }
    
    var associatedDeal: Deal?
    
    static func findOrdersByUserId(userId: String, completion: (orders: [Order], error: NSError?) -> Void) {
        let query = PFQuery(className: "Order")
        query.whereKey("userID", equalTo: userId)
        query.findObjectsInBackgroundWithBlock { (pfOrders: [PFObject]?, error: NSError?) -> Void in
            if let _ = error {
                completion(orders: [], error: error)
            }
            else {
                var orders: [Order] = []
                if let pfOrders = pfOrders {
                    for pfOrder in pfOrders {
                        orders.append(Order(order: pfOrder))
                    }
                }
                completion(orders: orders, error: nil)
            }
        }
    }
    
}
