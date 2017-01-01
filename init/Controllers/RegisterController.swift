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
            let storyboard = UIStoryboard(name: "MissionCategoryTableViewController", bundle: nil)
            guard let nextVC = storyboard.instantiateInitialViewController() else {
                print("Failed to instantiate view controller")
                return
            }
            nextVC.modalTransitionStyle = .flipHorizontal
            self.present(nextVC, animated: true, completion: nil)
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
        let password = "hogehoge"
        PraboApiService.sharedInstance.createUser(username, password) { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                if json["error"].exists() {
                    let message = json["error"].stringValue
                    let alert = UIAlertController(title: "登録エラー", message: message, preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "OK", style: .default) { action in
                        print("Action OK!!")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let loginInfomation = [
                    "id": String(describing: json["id"].intValue),
                    "username": json["username"].stringValue,
                    "password": parameters["password"] as! String,
                    "token_type": json["token_type"].stringValue,
                    "access_token": json["access_token"].stringValue
                ]
                UserDefaultsHelper.saveUser(info: loginInfomation)
                self.nextStoryboad()
                return
    
    }

    func nextStoryboad () {
        let storyboard = UIStoryboard(name: "MissionCategoryTableViewController", bundle: nil)
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
