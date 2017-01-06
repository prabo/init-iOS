//
//  MissionDetailController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class MissionDetailController: UIViewController {

    var mission: MissionModel?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMission()

        addEditButtonToNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        loadMission()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadMission() {
        guard let m = mission else {
            return
        }
        titleLabel.text = m.title
        descriptionLabel.text = m.description
    }

    func complete() {
        guard let m = mission else {
            return
        }
        let _ = PraboAPI.sharedInstance.completeMission(mission: m)
                .subscribe(onNext: { (result: ResultModel<CompleteModel>) in
                    if let error = result.error {
                        UIAlertController(title: "エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
                        return
                    }
                    UIAlertController(title: "完了", message: "ミッション達成おめでとう！", preferredStyle: .alert)
                            .addAction(title: "OK") { _ in
                                _ = self.navigationController?.popViewController(animated: true)
                            }.show()
                })
    }

    func notComplete() {
        guard let m = mission else {
            return
        }
        let _ = PraboAPI.sharedInstance.uncompleteMission(mission: m)
                .subscribe(onNext: { (result: ResultModel<CompleteModel>) in
                    if let error = result.error {
                        UIAlertController(title: "エラー", message: error.message, preferredStyle: .alert).addAction(title: "OK").show()
                        return
                    }
                    UIAlertController(title: "完了", message: "未達成に戻しました", preferredStyle: .alert)
                            .addAction(title: "OK") { _ in
                                _ = self.navigationController?.popViewController(animated: true)
                            }.show()
                })
    }

    @IBAction func completeButton(_ sender: UIButton) {
        complete()
    }

    @IBAction func notCompleteButton(_ sender: UIButton) {
        notComplete()
    }

    func handleEditButton() {
        let storyboard = UIStoryboard(name: "MissionEditController", bundle: nil)
        let missionEditController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionEditController as? MissionEditController else {
            return
        }
        secondViewController.mission = self.mission
        navigationController?.pushViewController(secondViewController, animated: true)
    }

    private func addEditButtonToNavigationBar() {
        let editButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditButton))
        navigationItem.rightBarButtonItem = editButton
    }
}
