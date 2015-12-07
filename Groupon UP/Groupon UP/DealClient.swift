//
//  DealClient.swift
//  Groupon UP
//
//  Created by Ping Zhang on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let clientId = "b91d375e38147f3c1e0339a3588d0b791c190424"
let host = "https://api.groupon.com"


class DealCache {
    static var dealCache = [String: Deal]()
    static func setCache(dealUuid: String, deal: Deal) -> Void {
        dealCache[dealUuid] = deal
    }
    
    static func retrieveDeal(dealUuid: String) -> Deal? {
        if let deal = dealCache[dealUuid] {
            return deal
        }
        return nil
    }
    
}

class DealClient {
    
    static func getDealByDealId(dealId: String, completion: (deal: Deal?, NSError?) -> Void) {
        if let deal = DealCache.retrieveDeal(dealId) {
            completion(deal: deal, nil)
            return
        }
        
        let url = host + "/v2/deals/" + dealId + ".json"
        let parameters = [
            "client_id": clientId
        ]
        Alamofire.request(.GET, url, parameters: parameters).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let dealData = response.result.value {
                    let dealJsonData = JSON(dealData)["deal"]
                    let deal = Deal(dealData: dealJsonData)
                    DealCache.setCache(dealId, deal: deal)
                    completion(deal: deal, nil)
                }
                else {
                    completion(deal: nil, response.result.error)
                }
            }
            else {
                completion(deal: nil, response.result.error)
            }
        }
    }
    
    
    static func getDealsByDealIds(dealIds: [String], completion: (deals: [Deal]?, NSError?) -> Void) {
        var deals = [Deal]()
        for dealId in dealIds {
            getDealByDealId(dealId) { (deal: Deal?, _) in
                deals.append(deal!)
            }
        }
        completion(deals: deals, nil)
    }

    

    static func getDivisionDeals(divisionId: String = "chicago", limit: Int = 10, completion: ([Deal]!) -> Void) {
        let parameters = [
            "division_id": divisionId,
            "limit": limit.description,
            "client_id": clientId
        ]
        let url = host + "/v2/deals.json"
        Alamofire.request(.GET, url, parameters: parameters).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let dealData = response.result.value {
                    let dealJsonData = JSON(dealData)["deals"]
                    completion(Deal.deals(dealJsonData))
                }
                else {
                    //error
                }
            }
            else {
                
            }
        }
    }
}
