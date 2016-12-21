//
//  User.swift
//  init
//
//  Created by Atsuo on 2016/12/15.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import Foundation
import SwiftyJSON
import Foundation

final class User {
    var id: Int
    var username: String
    var tokenType: String
    var accessToken: String

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.username = json["username"].stringValue
        self.tokenType = json["token_type"].stringValue
        self.accessToken = json["access_token"].stringValue
    }
}
