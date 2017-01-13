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
    }

    func nextStoryboad() {
        let vc = Storyboard.CategoryList.instantiate(UIViewController.self)
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }

    @IBAction func registerButton(_ sender: UIButton) {
        guard let username = nameTextField.text else {
            return
        }
        // TODO: Random key
        let password = "hogehoge"
        PraboAPI.sharedInstance.createUser(username: username, password: password)
                .subscribe(onNext: { (result) in
                    if let error = result.error {
                        UIAlertController(title: "登録エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
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
