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

class MissionDetailController: UITableViewController {

    var mission: Mission?
    var titleLabel: String!
    var descriptionLabel: String!
    var ownerNameLabel: String!
    
    var completedUsers = [User]()
    enum SectionName {
        case title
        case author
        case state
        case completedUsers
    }
    
    var completed = false

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
        titleLabel = m.title
        descriptionLabel = m.description
        // Loading Placeholder
        ownerNameLabel = "@" + m.author.username
        completed = m.isCompleted
        let _ = PraboAPI.sharedInstance.getMission(id: m.id)
            .subscribe(onNext: { (result: Result<Mission>) in
                // TODO: Error 処理
                guard let mission: Mission = result.data else {
                    return
                }
                guard let completedUsers = mission.completedUsers else {
                    return
                }
                self.completedUsers = completedUsers
                self.tableView.reloadData()
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

extension MissionDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionName.title.hashValue:
            return 1
        case SectionName.author.hashValue:
            return 1
        case SectionName.state.hashValue:
            return 2
        case SectionName.completedUsers.hashValue:
            return completedUsers.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell (style: .default, reuseIdentifier: "")
        switch indexPath.section {
        case SectionName.title.hashValue:
            cell.textLabel?.text = self.descriptionLabel
            cell.selectionStyle = .none
        case SectionName.author.hashValue:
            cell.textLabel?.text = self.ownerNameLabel
            cell.selectionStyle = .none
        case SectionName.state.hashValue:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "notCompleted"
                if !completed {
                    cell.accessoryType = .checkmark
                }
            case 1:
                cell.textLabel?.text = "completed"
                if completed {
                    cell.accessoryType = .checkmark
                }
            default:
                break
            }
        case SectionName.completedUsers.hashValue:
            cell.textLabel?.text = completedUsers[indexPath.row].username
            cell.selectionStyle = .none
            cell.imageView?.image = #imageLiteral(resourceName: "enemy")
        default:
            break
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionName.title.hashValue:
            return titleLabel
        case SectionName.author.hashValue:
            return "作成者"
        case SectionName.state.hashValue:
            return " "
        case SectionName.completedUsers.hashValue:
            return "ミッションクリアユーザー"
        default:
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section.hashValue == SectionName.state.hashValue else {
            return
        }
        completed = !completed
        
        switch (indexPath.section, indexPath.row) {
        case (2,0):
            notComplete()
        case (2,1):
            complete()
        default:
            break
        }
        
        tableView.reloadData()
    }
}
