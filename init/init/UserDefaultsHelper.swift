//
//  UserDafaultsHelper.swift
//  init
//
//  Created by Atsuo on 2016/11/29.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

class UserDefaultsHelper{
    static func isLogin() -> Bool {
        let ud = UserDefaults.init()
        return ud.string(forKey: "access_token") != nil
    }

}

