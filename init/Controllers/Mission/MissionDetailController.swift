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
                .subscribe(onNext: { (result: ResultModel<MissionModel>) in
                    // TODO: Error 処理
                    guard let mission: MissionModel = result.data else {
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

        let headers: HTTPHeaders = [
                "Authorization": UserDefaultsHelper.getToken(),
                "Accept": "application/json"
        ]
        let str = m.id.description

        Alamofire.request("https://init-api.elzup.com/v1/missions/" + str + "/complete", method: .post, headers: headers)
                .responseJSON { _ in
                }
    }

    func notComplete() {
        guard let m = mission else {
            return
        }

        let headers: HTTPHeaders = [
                "Authorization": UserDefaultsHelper.getToken(),
                "Accept": "application/json"
        ]
        let str = m.id.description

        Alamofire.request("https://init-api.elzup.com/v1/missions/" + str + "/uncomplete", method: .post, headers: headers)
                .responseJSON { _ in
                }
    }

    @IBAction func completeButton(_ sender: UIButton) {
        complete()
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func notCompleteButton(_ sender: UIButton) {
        notComplete()
        _ = self.navigationController?.popViewController(animated: true)
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
