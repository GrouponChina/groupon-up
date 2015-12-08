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

    class func getAvatarUrlFor(email email: String) -> NSURL {
        return NSURL(string: "https://www.gravatar.com/avatar/\(email.md5())?s=200")!
    }

    class func getAvatarUrl() -> NSURL {
        return NSURL(string: "https://www.gravatar.com/avatar?s=200")!
    }
}

let UserCache = UserClient()