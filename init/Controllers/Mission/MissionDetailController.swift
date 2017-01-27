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

class MissionDetailController: UIViewController {

    var mission: Mission?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!

    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMission()

        addEditButtonToNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
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
        // Loading Placeholder
        ownerNameLabel.text = "..."
        let _ = PraboAPI.sharedInstance.getMission(id: m.id)
            .subscribe(onNext: { (result: Result<Mission>) in
                // TODO: Error 処理
                guard let mission: Mission = result.data else {
                    return
                }
                self.mission = mission
                self.ownerNameLabel.text = "@" + mission.author.username
            })
    }

    func complete() {
        guard let m = mission else {
            return
        }
        let _ = PraboAPI.sharedInstance.completeMission(mission: m)
            .subscribe(onNext: { (result: Result<Complete>) in
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
            .subscribe(onNext: { (result: Result<Complete>) in
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
        let vc = Storyboard.MissionEdit.instantiate(MissionEditController.self)
        vc.mission = self.mission
        navigationController?.pushViewController(vc, animated: true)
    }

    private func addEditButtonToNavigationBar() {
        let editButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditButton))
        navigationItem.rightBarButtonItem = editButton
    }
}
