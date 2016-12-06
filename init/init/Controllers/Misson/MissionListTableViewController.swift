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

    //var missionList: [String]=["残留","コーヒー","炊飯器","3Dprinter","github"]
    var missions: [[String:String]] = []
    //var missionListsValue = Array<String?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaultsHelper.isLogin() {
            // to login
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier:"Register")
            nextVC?.modalTransitionStyle = .flipHorizontal
            self.present(nextVC!,animated: true,completion: nil)
            return
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath) as! MissionListTableViewCell

        // Configure the cell...
//        cell.missionNameLabel.text=missionList[indexPath.row]
        guard let title = missions[indexPath.row]["title"] else {
            cell.missionNameLabel.text = "title error"
            return cell
        }
        cell.missionNameLabel.text = title
        // cell.missionNameLabel.text = missions[indexPath.row]["title"]
        return cell
    }
    func getMissionLists(){
        
        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://init-api.elzup.com/v1/missions",headers:headers)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                json.forEach { (_, json) in
                    let missionList : [String:String] = [
                        "id":String(describing: json["id"].int),
                        "title": json["title"].string ?? "no title",
                        "description": json["description"].string ?? "no description",
                        "author_id": json["author_id"].string ?? "no author_id",
                        "is_completed": json["is_completed"].string ?? "no is_completed",
                        ]
                    self.missions.append(missionList)
                }
                self.tableView.reloadData()
                print("aaaa")
                print(self.missions)
        }
    }
    
    
    
    @IBAction func addButton(_ sender: UIButton) {
    }
    @IBAction func reloadButton(_ sender: UIButton) {
    }

    
}