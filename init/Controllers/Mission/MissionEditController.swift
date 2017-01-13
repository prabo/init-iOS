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

    var mission: Mission?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func deleteButton(_ sender: UIButton) {
        deleteMission()
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
        let _ = PraboAPI.sharedInstance.updateMission(mission: m)
            .subscribe(onNext: { (result: Result<Mission>) in
                if let error = result.error {
                    UIAlertController(title: "編集エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
                    return
                }
                guard let mission: Mission = result.data else {
                    return
                }
                let vc = Storyboard.MissionDetail.instantiate(MissionDetailController.self)
                vc.mission = mission
                UIAlertController(title: "完了", message: "ミッションを編集しました", preferredStyle: .alert)
                    .addAction(title: "OK") { _ in
                        navigationController.popViewController(animated: true)
                    }.show()
            })
    }

    // ２つ前の画面に戻る
    func popTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }

    func deleteMission() {
        guard let m = mission else {
            return
        }
        let _ = PraboAPI.sharedInstance.deleteMission(mission: m)
            .subscribe(onNext: { (result: Result<Mission>) in
                if let error = result.error {
                    UIAlertController(title: "削除エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
                    return
                }
                guard let mission: Mission = result.data else {
                    return
                }
                UIAlertController(title: "完了", message: "ミッション「\(mission.title)」を削除しました", preferredStyle: .alert)
                    .addAction(title: "OK") { _ in
                        self.popTwo()
                    }.show()
            })
    }

    func handleChange() {
        changeMission()
    }

    private func addChangeButtonToNavigationBar() {
        let button: UIBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(handleChange))
        navigationItem.rightBarButtonItem = button
    }

}
