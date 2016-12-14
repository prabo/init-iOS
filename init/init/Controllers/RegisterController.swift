//
//  ViewController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    var loginInfomation: [String:String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaultsHelper.isLogin() {
            // to login
            let storyboard = UIStoryboard(name: "MissionListTableViewController", bundle: nil)
            guard let nextVC = storyboard.instantiateInitialViewController() else {
                print("Failed to instantiate view controller")
                return
            }
            nextVC.modalTransitionStyle = .flipHorizontal
            self.present(nextVC, animated: true, completion: nil)
            return
        }
    }
    func postLoginID(parameters: Parameters) {
        Alamofire.request("https://init-api.elzup.com/v1/users", method:.post, parameters:parameters)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                self.loginInfomation = [
                    "id": String(describing: json["id"].intValue),
                    "username": json["username"].stringValue,
                    "token_type": json["token_type"].stringValue,
                    "access_token": json["access_token"].stringValue
                ]
                let userDefaults = UserDefaults.init()
                userDefaults.set(self.loginInfomation["id"]!, forKey: "id")
                userDefaults.set(self.loginInfomation["username"]!, forKey: "username")
                userDefaults.set(parameters["password"], forKey: "password")
                userDefaults.set(self.loginInfomation["access_token"]!, forKey: "access_token")
                userDefaults.synchronize()
                print("self.loginInfomation")
                print(self.loginInfomation)
//                let storyboard = UIStoryboard(name: "MissionListTableViewController", bundle: nil)
//                guard let nextVC = storyboard.instantiateInitialViewController() else {
//                    print("Failed to instantiate view controller")
//                    return
//                }
//                nextVC.modalTransitionStyle = .flipHorizontal
//                self.present(nextVC, animated: true, completion: nil)
//                return
        }
    }
    func nextStoryboad () {
        let storyboard = UIStoryboard(name: "MissionListTableViewController", bundle: nil)
        let missionListTableViewController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionListTableViewController as? MissionListTableViewController else {
            return
        }
        navigationController?.pushViewController(secondViewController, animated: true)
    }

    @IBAction func registerButton(_ sender: UIButton) {
        guard let username = nameTextField.text else {
            return
        }
        let parameters: Parameters = [
            "username":  username,
            "password": "hogehoge"
        ]
        postLoginID(parameters:parameters)
        nextStoryboad()
    }

}
