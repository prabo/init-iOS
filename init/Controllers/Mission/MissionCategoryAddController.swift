//
//  MissionCategoryAddController.swift
//  init
//
//  Created by Atsuo Yonehara on 2017/01/01.
//  Copyright © 2017年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class MissionCategoryAddController: UIViewController {
    var mission: MissionModel?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        addRegisterButtonToNavigationBar()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCategory() {
        let parameters: Parameters = [
            "name": titleTextField.text!
        ]
        let headers: HTTPHeaders = [
            "Authorization": UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://init-api.elzup.com/v1/categories", method: .post, parameters:parameters, headers:headers)
            .responseJSON { response in
        }
    }
    
    func handleRegisterButton() {
        registerCategory()
        
        guard let navigationController = navigationController else {
            return
        }
        navigationController.popViewController(animated: true)
    }
    
    private func addRegisterButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleRegisterButton))
        navigationItem.rightBarButtonItem = button
    }
}
