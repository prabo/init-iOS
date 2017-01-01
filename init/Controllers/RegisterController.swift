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
        // TODO: Random key
        let password = "hogehoge"
        PraboAPI.shareInstance.createUser(username: username, password: password)
            .subscribe(onNext: { (result) in
                if let error = result.error {
                    // TODO: Alert 分離したい
                    let alert = UIAlertController(title: "登録エラー", message: error.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                guard let session = result.data else {
                    return
                }
                UserDefaultsHelper.saveUser(session: session, password: password)
                self.nextStoryboad()
            })
    }
    
}
