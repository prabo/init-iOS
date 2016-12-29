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

final class MissionAddController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    var mission: Mission?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    var categoryArry: [String] = ["1","2","3"]
    

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

    func registerMission() {
        let parameters: Parameters = [
           "title": titleTextField.text!,
           "description": descriptionTextView.text!
        ]
        let headers: HTTPHeaders = [
            "Authorization": UserDefaultsHelper.getToken(),
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

        guard let navigationController = navigationController else {
            return
        }
        navigationController.popViewController(animated: true)
    }
    
    //表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArry.count
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArry[row]
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("値: \(categoryArry[row])")
    }


    private func addRegisterButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleRegisterButton))
        navigationItem.rightBarButtonItem = button
    }
}
