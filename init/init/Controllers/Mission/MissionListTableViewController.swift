//
//  MissionListTableViewController.swift
//  init
//
//  Created by Atsuo on 2016/11/10.
//  Copyright © 2016年 Atsuo. All rights reserved.
//
//
import UIKit
import Alamofire
import SwiftyJSON

class MissionListTableViewController: UITableViewController {

    var missions: [Mission] = []

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
    }

    override func viewDidAppear(_ animated: Bool) {
        getMissionLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath)
        guard let missionCell = cell as? MissionListTableViewCell else {
            return cell
        }
        missionCell.missionNameLabel.text = missions[indexPath.row].title

        missionCell.checkImage.contentMode = .scaleAspectFit
        missionCell.checkImage.image = UIImage(named: "check.png")
        return missionCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MissionDetailController", bundle: nil)
        //changePoint start (make missionDetailController)
        let missionDetailController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionDetailController as? MissionDetailController else {
            return
        }
        //changePoint end
        let mission = missions[indexPath.row]
        secondViewController.title = "詳細"
        secondViewController.mission = mission
        navigationController?.pushViewController(secondViewController, animated: true)
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
                    self.missions.append(Mission(json: json))
                }
                self.tableView.reloadData()
                print("self.missions")
                print(self.missions)
        }
    }

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

}