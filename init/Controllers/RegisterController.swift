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

final class RegisterController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
                let loginInfomation = [
                    "id": String(describing: json["id"].intValue),
                    "username": json["username"].stringValue,
                    "password": parameters["password"] as! String,
                    "token_type": json["token_type"].stringValue,
                    "access_token": json["access_token"].stringValue
                ]
                UserDefaultsHelper.saveUser(info: loginInfomation)
                print("loginInfomation")
                print(loginInfomation)
                self.nextStoryboad()
                return
        }
    }
    func nextStoryboad () {
        let storyboard = UIStoryboard(name: "MissionListTableViewController", bundle: nil)
        guard let nextVC = storyboard.instantiateInitialViewController() else {
            print("Failed to instantiate view controller")
            return
        }
        nextVC.modalTransitionStyle = .flipHorizontal
        self.present(nextVC, animated: true, completion: nil)
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
    }

}
