//
//  MissionListController.swift
//  init
//
//  Created by Atsuo on 2016/11/10.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MissionListController: UITableViewController {
    var category: Category?
    var missions: [Mission] = []
    var incompletedMissions: [Mission] = []

    var showOnlyIncompleted = false

    @IBAction func addButton(_ sender: UIButton) {
        navigationController?.pushViewController(
            Storyboard.MissionAdd.instantiate(MissionAddController.self),
            animated: true)
    }

    @IBAction func reloadButton(_ sender: UIButton) {
        getMissionLists()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = category?.name

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
            .subscribe(onNext: { (result: Result<Category>) in
                // TODO: Error 処理
                guard let category: Category = result.data,
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

extension MissionListController {
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
        missionCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        missionCell.checkImage.contentMode = .scaleAspectFit
        missionCell.ownerImage.contentMode = .scaleAspectFit
        missionCell.checkImage.image = UIImage(named: "check")
        missionCell.ownerImage.image = UIImage(named: "enemy")
        missionCell.checkImage.isHidden = !mission.isCompleted
        missionCell.ownerImage.isHidden = (mission.author.id != UserDefaultsHelper.getLoginUser().id)
        return missionCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.MissionDetail.instantiate(MissionDetailController.self)
        let array = showOnlyIncompleted ? incompletedMissions : missions
        let mission = array[indexPath.row]
        vc.title = "詳細"
        vc.mission = mission
        navigationController?.pushViewController(vc, animated: true)
    }

}
