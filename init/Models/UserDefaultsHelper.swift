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
    
    static func getLoginUser() -> UserModel {
        let ud = UserDefaults.init()
        let id = ud.integer(forKey: "id") 
        let usernmae = ud.string(forKey: "usernmae") ?? ""
        return UserModel(id: id, username: usernmae)
    }
    
    static func saveUser(session: SessionModel, password: String) {
        let userDefaults = UserDefaults.init()
        userDefaults.set(session.id, forKey: "id")
        userDefaults.set(session.username, forKey: "username")
        userDefaults.set(password, forKey: "password")
        userDefaults.set(session.accessToken, forKey: "access_token")
        userDefaults.synchronize()
    }
    
}
