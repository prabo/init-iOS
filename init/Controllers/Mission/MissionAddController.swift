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

final class MissionAddController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var mission: MissionModel?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var categoryPickerView: UIPickerView!

    var categoryArray: [CategoryModel] = []
    var categoryID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        addRegisterButtonToNavigationBar()

        let headers: HTTPHeaders = [
                "Authorization": UserDefaultsHelper.getToken(),
                "Accept": "application/json"
        ]
        Alamofire.request("https://init-api.elzup.com/v1/categories", headers: headers)
                .responseJSON { response in
                    guard let object = response.result.value else {
                        return
                    }
                    let json = JSON(object)
                    json.forEach { (_, json) in
                        self.categoryArray.append(CategoryModel(json: json))
                    }
                    print(self.categoryArray)
                    self.categoryPickerView.reloadAllComponents()
                    self.categoryID = self.categoryArray[0].categoryID
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

    func handleRegisterButton() {
        // TODO: この Unwrap どうにかしたい
        guard let navigationController = navigationController else {
            return
        }
        let param = MissionParam(
                title: titleTextField.text!,
                description: descriptionTextView.text!,
                categoryID: self.categoryID)
        let _ = PraboAPI.sharedInstance.createMission(param: param)
                .subscribe(onNext: { (result: ResultModel<MissionModel>) in
                    if let error = result.error {
                        UIAlertController(title: "登録エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
                        return
                    }
                    guard let mission: MissionModel = result.data else {
                        return
                    }
                    UIAlertController(title: "完了", message: "「\(mission.title)」を作成しました！", preferredStyle: .alert)
                            .addAction(title: "OK") { _ in
                                navigationController.popViewController(animated: true)
                            }.show()
                })
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
        return categoryArray[row].categoryName
    }

    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryID = categoryArray[row].categoryID
    }

    private func addRegisterButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleRegisterButton))
        navigationItem.rightBarButtonItem = button
    }
}
