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

class DealClient {
    static func getDivisionDeals(divisionId: String = "chicago", limit: Int = 5, completion: ([Deal]!) -> Void) {
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
