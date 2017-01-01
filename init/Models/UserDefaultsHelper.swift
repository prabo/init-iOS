//
//  UserDafaultsHelper.swift
//  init
//
//  Created by Atsuo on 2016/11/29.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

final class UserDefaultsHelper {
    static let ACCESS_TOKEN_KEY = "access_token"
    static func isLogin() -> Bool {
        // Token saved without [nil, ""]
        return getToken() != ""
    }
    static func getToken() -> String {
        let ud = UserDefaults.init()
        return ud.string(forKey: self.ACCESS_TOKEN_KEY) ?? ""
    }
    static func removeToken() {
        let ud = UserDefaults.init()
        ud.removeObject(forKey: self.ACCESS_TOKEN_KEY)
    }
    
    static func saveUser(info: [String: Any]) {
        let userDefaults = UserDefaults.init()
        userDefaults.set(info["id"]!, forKey: "id")
        userDefaults.set(info["username"]!, forKey: "username")
        userDefaults.set(info["password"], forKey: "password")
        userDefaults.set(info["access_token"]!, forKey: "access_token")
        userDefaults.synchronize()
    }
    
}
