//
//  UserClient.swift
//  Groupon UP
//
//  Created by XueYan on 12/7/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Parse

class UserClient {
    var cache = [String: PFUser]()

    func clearCache() {
        cache.removeAll()
    }

    func getUserForId(id: String) -> PFUser {
        if let user = cache[id] {
            return user
        } else {
            let user = PFUser(withoutDataWithObjectId: id)
            return user
        }
    }
}

let UserCache = UserClient()