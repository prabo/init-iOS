//
//  UserDafaultsHelper.swift
//  init
//
//  Created by Atsuo on 2016/11/29.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

final class UserDefaultsHelper {
    private struct Key {
        static let accessToken = "access_token"
        static let id = "id"
        static let userName = "username"
        static let password = "password"
    }
    
    static var isLogin: Bool {
        // Token saved without [nil, ""]
        return getToken() != ""
    }

    static func getToken() -> String {
        return UserDefaults.standard.string(forKey: Key.accessToken) ?? ""
    }

    static func removeToken() {
        UserDefaults.standard.removeObject(forKey: Key.accessToken)
    }

    static func getLoginUser() -> UserModel {
        let userDefaults = UserDefaults.standard
        let id = userDefaults.integer(forKey: Key.id)
        let username = userDefaults.string(forKey: Key.userName) ?? ""
        return UserModel(id: id, username: username)
    }

    static func saveUser(session: SessionModel, password: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(session.id, forKey: Key.id)
        userDefaults.set(session.username, forKey: Key.userName)
        userDefaults.set(password, forKey: Key.password)
        userDefaults.set(session.accessToken, forKey: Key.accessToken)
        userDefaults.synchronize()
    }
}