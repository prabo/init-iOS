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
    var isShowView = true
    var categoryArray: [CategoryModel] = []
    var selectedCategory: CategoryModel?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var categoryPickerView: UIPickerView!

    //category Add
    @IBOutlet var categoryAddView: UIView!
    @IBAction func categoryAddButton(_ sender: UIButton) {
        isShowView ? showView() : hideView()
        isShowView = !isShowView
    }
    //extra View
    @IBOutlet weak var categoryAddTextField: UITextField!
    @IBAction func categoryAddRegisterButton(_ sender: UIButton) {
        addCategory()
    }

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
        self.categoryAddView.layer.borderColor = UIColor.red.cgColor
        self.categoryAddView.layer.borderWidth = 10
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
    
    private func showView() {
        categoryAddView.center = self.view.center
        self.view.addSubview(categoryAddView)
        
        UIView.animate(withDuration: 0.5, animations: {[weak self] () -> Void in
            
            if let weakSelf = self {
                weakSelf.categoryAddView.alpha = 1
                weakSelf.categoryAddView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
            }
        })
    }
    
    private func hideView() {
        UIView.animate(withDuration: 0.5, animations: {[weak self] () -> Void in
            
            if let weakSelf = self {
                weakSelf.categoryAddView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5);
                weakSelf.categoryAddView.alpha = 0;
            }
            
            }, completion: {[weak self] (complated) -> Void in
                
                if let weakSelf = self {
                    weakSelf.view.subviews.last?.removeFromSuperview()
                }
        })
    }
    
    private func addCategory(){
        let params = CategoryParam(name: categoryAddTextField.text!)
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
                        self.hideView()
                        self.isShowView = !self.isShowView
                        //↓これをどこに入れれば良いかわからないです(>_<)
                        //self.categoryPickerView.reloadAllComponents()
                    }.show()
            })
    }
}
