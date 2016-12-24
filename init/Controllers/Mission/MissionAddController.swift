//
//  MissionAddController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

final class MissionAddController: UIViewController {
    var mission: Mission?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    func registerMission() {
        let parameters: Parameters = [
           "title":titleTextField.text!,
           "description":descriptionTextView.text!
        ]
        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request("https://init-api.elzup.com/v1/missions", method: .post, parameters:parameters, headers:headers)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                print(json)
        }
    }

    func handleRegisterButton() {
        registerMission()
        _=self.navigationController?.popViewController(animated: true)
    }
}
