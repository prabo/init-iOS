//
//  MissionListTableViewController.swift
//  init
//
//  Created by Atsuo on 2016/11/10.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class MissionListTableViewController: UITableViewController {
    var category: CategoryModel?
    var missions: [MissionModel] = []
    var incompletedMissions: [MissionModel] = []

    var showOnlyIncompleted = false

    @IBAction func addButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MissionAddController", bundle: nil)
        let missionAddController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionAddController as? MissionAddController else {
            return
        }
        navigationController?.pushViewController(secondViewController, animated: true)
    }

    @IBAction func reloadButton(_ sender: UIButton) {
        getMissionLists()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.init()
        let username = userDefaults.string(forKey: "username")!
        self.navigationItem.title = username

        let filterButton: UIBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(toggleFilter))
        navigationItem.rightBarButtonItem = filterButton
    }

    override func viewDidAppear(_ animated: Bool) {
        getMissionLists()
        showOnlyIncompleted = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getMissionLists() {
        guard let c = self.category else {
            return
        }
        let _ = PraboAPI.sharedInstance.getCategory(id: c.id)
                .subscribe(onNext: { (result: ResultModel<CategoryModel>) in
                    // TODO: Error 処理
                    guard let category: CategoryModel = result.data,
                        let missions = category.missions else {
                        return
                    }
                    self.missions = missions
                    self.tableView.reloadData()
                })
    }

    func toggleFilter() {
        createIncompletedMissionsArray()
        showOnlyIncompleted = showOnlyIncompleted ? false : true
        tableView.reloadData()
    }

    private func createIncompletedMissionsArray() {
        incompletedMissions = []
        missions.forEach({
            if !$0.isCompleted {
                incompletedMissions.append($0)
            }
        })
    }

}

// MARK: UITableViewDataSource method

extension MissionListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showOnlyIncompleted ? incompletedMissions.count : missions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath)
        guard let missionCell = cell as? MissionListTableViewCell else {
            return cell
        }
        let array = showOnlyIncompleted ? incompletedMissions : missions
        let mission = array[indexPath.row]
        missionCell.missionNameLabel.text = array[indexPath.row].title
        missionCell.checkImage.contentMode = .scaleAspectFit
        missionCell.ownerImage.contentMode = .scaleAspectFit
        missionCell.checkImage.image = UIImage(named: "check.png")
        missionCell.ownerImage.image = UIImage(named: "enemy.png")
        missionCell.checkImage.isHidden = !mission.isCompleted
        missionCell.ownerImage.isHidden = (mission.author.id != UserDefaultsHelper.getLoginUser().id)
        return missionCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MissionDetailController", bundle: nil)
        let missionDetailController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionDetailController as? MissionDetailController else {
            return
        }
        let array = showOnlyIncompleted ? incompletedMissions : missions
        let mission = array[indexPath.row]
        secondViewController.title = "詳細"
        secondViewController.mission = mission
        navigationController?.pushViewController(secondViewController, animated: true)
    }

}
