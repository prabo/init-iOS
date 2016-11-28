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
    var loginInfomation: [String:String?] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func postLoginID(){
        let parameters: Parameters = [
            "username": nameTextField,
            "password":"aaaaaaaa"
        ]
        Alamofire.request("https://init-api.elzup.com/v1/users",method:.post,parameters:parameters)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                self.loginInfomation = [
                    "id": String(describing: json["id"].int),
                    "username": json["username"].string,
                    "token_type": json["token_type"].string,
                    "access_token": json["access_token"].string
                ]
                print(self.loginInfomation)
        }
        
    }

    @IBAction func registerButton(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier:"ListNabi")
        nextVC?.modalTransitionStyle = .flipHorizontal
        present(nextVC!,animated: true,completion: nil)
        
        postLoginID()
    }

}
