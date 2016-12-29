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
    
    var categoryArray: [JSON] = []
    var categoryID: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        addRegisterButtonToNavigationBar()
        
        let headers: HTTPHeaders = [
            "Authorization": UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        Alamofire.request("https://init-api.elzup.com/v1/categories", headers:headers)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                json.forEach { (_, json) in
                    self.categoryArray.append(json)
                }
                print(self.categoryArray)
                self.categoryPickerView.reloadAllComponents()
        }
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
           "description": descriptionTextView.text!,
           "category_id": self.categoryID
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
        return categoryArray.count
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]["name"].stringValue
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryID = categoryArray[row]["id"].stringValue
        print("値: \(categoryArray[row]["name"].stringValue)")
    }


    private func addRegisterButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleRegisterButton))
        navigationItem.rightBarButtonItem = button
    }
}
