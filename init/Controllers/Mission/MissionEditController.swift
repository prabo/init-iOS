//
//  MissionEditController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class MissionEditController: UIViewController, UITextFieldDelegate {

    var mission: MissionModel?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func deleteButton(_ sender: UIButton) {
        deleteMission()
        _ = navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        guard let m = mission else {
            return
        }
        titleTextField.text = m.title
        descriptionTextView.text = m.description

        addChangeButtonToNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func changeMission() {
        guard let m = mission else {
            return
        }
        // TODO: この Unwrap どうにかしたい
        guard let navigationController = navigationController else {
            return
        }
        let storyboard = UIStoryboard(name: "MissionDetailController", bundle: nil)
        let missionDetailController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionDetailController as? MissionDetailController else {
            return
        }
        m.title = titleTextField.text!
        m.description = descriptionTextView.text!
        let _ = PraboAPI.sharedInstance.updateMission(mission: m)
            .subscribe(onNext: { (result: ResultModel<MissionModel>) in
                if let error = result.error {
                    UIAlertController(title: "編集エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
                    return
                }
                guard let mission: MissionModel = result.data else {
                    return
                }
                // NOTE: 前画面の情報更新しておく
                secondViewController.mission = mission
                UIAlertController(title: "完了", message: "ミッションを編集しました", preferredStyle: .alert)
                    .addAction(title: "OK") { action in
                        navigationController.popViewController(animated: true)
                    }.show()
            })
    }
    
    func deleteMission() {
        guard let m = mission else {
            return print("mission is nill")
        }
        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        let str = m.id.description
        Alamofire.request("https://init-api.elzup.com/v1/missions/"+str,
                          method: .delete, headers:headers)
            .responseJSON { response in
        }
    }

    func handleChange() {
        changeMission()
    }

    private func addChangeButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(handleChange))
        navigationItem.rightBarButtonItem = button
    }

}
