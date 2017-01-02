//
//  AppDelegate.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        let storyboardName = UserDefaultsHelper.isLogin ? "MissionCategoryTableViewController" : "RegisterViewController"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        window?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
