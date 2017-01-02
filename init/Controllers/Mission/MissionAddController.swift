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
    var selectedCategory: CategoryModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        addRegisterButtonToNavigationBar()

        let _ = PraboAPI.sharedInstance.getCategories()
                .subscribe(onNext: { (result: ResultsModel<CategoryModel>) in
                    // TODO: Error
                    guard let categories: [CategoryModel] = result.data else {
                        return
                    }
                    self.categoryArray = categories
                    self.selectedCategory = categories[0]
                    self.categoryPickerView.reloadAllComponents()
                })
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
        guard let navigationController = navigationController,
              let category = self.selectedCategory else {
            return
        }
        let param = MissionParam(
                title: titleTextField.text!,
                description: descriptionTextView.text!,
                categoryId: category.id)
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
        return categoryArray[row].name
    }

    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoryArray[row]
    }

    private func addRegisterButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleRegisterButton))
        navigationItem.rightBarButtonItem = button
    }
}
