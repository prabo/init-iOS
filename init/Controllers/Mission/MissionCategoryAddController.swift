//
//  MissionCategoryAddController.swift
//  init
//
//  Created by Atsuo Yonehara on 2017/01/01.
//  Copyright © 2017年 Atsuo. All rights reserved.
//

import UIKit
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

    func handleRegisterButton() {
        guard let navigationController = navigationController else {
            return
        }
        let params = CategoryParam(name: titleTextField.text!)
        let _ = PraboAPI.sharedInstance.createCategory(param: params)
                .subscribe(onNext: { (result: ResultModel<CategoryModel>) in
                    if let error = result.error {
                        UIAlertController(title: "登録エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
                        return
                    }
                    guard let category: CategoryModel = result.data else {
                        return
                    }
                    UIAlertController(title: "完了", message: "「\(category.name)」を作成しました！", preferredStyle: .alert)
                            .addAction(title: "OK") { _ in
                                navigationController.popViewController(animated: true)
                            }.show()
                })
    }

    private func addRegisterButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleRegisterButton))
        navigationItem.rightBarButtonItem = button
    }
}
