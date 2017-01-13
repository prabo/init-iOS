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
        let startStoryboard = UserDefaultsHelper.isLogin
            ? Storyboard.MissionCategoryTableViewController.instantiate(UIViewController.self)
            : Storyboard.RegisterViewController.instantiate(UIViewController.self)
        window?.rootViewController = startStoryboard
    }
}
