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
    var category :Category?
    var missions: [Mission] = []
    var categoryMissions :[Mission] = []
    var incompletedMissions: [Mission] = []
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

        if !UserDefaultsHelper.isLogin() {
            // to login
            let storyboard = UIStoryboard(name: "RegisterViewController", bundle: nil)
            guard let nextVC = storyboard.instantiateInitialViewController() else {
                print("Failed to instantiate view controller")
                return
            }
            nextVC.modalTransitionStyle = .flipHorizontal
            self.present(nextVC, animated: true, completion: nil)
            return
        }

        let userDefaults = UserDefaults.init()
        let username = userDefaults.string(forKey: "username")!
        self.navigationItem.title = username

        let filterButton: UIBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(toggleFilter))
        navigationItem.rightBarButtonItem = filterButton
    }

    override func viewDidAppear(_ animated: Bool) {
        getMissionLists()
        createCategoryMissionsArray()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getMissionLists() {

        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]

        Alamofire.request("https://init-api.elzup.com/v1/missions", headers:headers)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                self.missions.removeAll()
                json.forEach { (_, json) in
                    self.missions.append(MissionModel(json: json))
                }
                self.tableView.reloadData()
        }
    }

    func toggleFilter() {
        createIncompletedMissionsArray()
        showOnlyIncompleted = showOnlyIncompleted ? false : true
        tableView.reloadData()
    }
    
    func createCategoryMissionsArray(){
        guard let c = category else {
            return
        }
        categoryMissions = []
        missions.forEach({
            if $0.categoryID == c.categoryID {
                categoryMissions.append($0)
            }
        })
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
        missionCell.ownerImage.isHidden = mission.author.id == UserDefaultsHelper.getLoginUser().id
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
