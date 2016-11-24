//
//  MissionListTableViewController.swift
//  init
//
//  Created by Atsuo on 2016/11/10.
//  Copyright © 2016年 Atsuo. All rights reserved.
//
//
//import UIKit
//import Alamofire
//
//class MissionListTableViewController: UITableViewController {
//
//    var missionList: [String]=["残留","コーヒー","炊飯器","3Dprinter","github"]
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return missionList.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath) as! MissionListTableViewCell
//
//        // Configure the cell...
//        cell.missionNameLabel.text=missionList[indexPath.row]
//        return cell
//    }

import UIKit
import Alamofire
import SwiftyJSON

class MissionListTableViewController: UIViewController,UITableViewDataSource {
    let table = UITableView() // プロパティにtableを追加
    var articles: [[String:String?]] = []
    let imageView = UIImage(named :"check.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        table.dataSource = self
        getArticles()
        
    }
    
    func getArticles() {
        let url = "https://qiita.com/api/v2/items"
        // method defaults to `.get`
        Alamofire.request(url).responseJSON{ response in
            guard let object = response.result.value else{
                return
            }
            let json=JSON(object)
            json.forEach({ (_,json) in
                let article: [String:String?] = [
                    "title":json["title"].string,
                    "userid":json["user"]["id"].string
                ]
                self.articles.append(article)
            })
            self.table.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath) as! MissionListTableViewCell
//        let cell = UITableViewCell(style: .default, reuseIdentifier:"cell")
        let article = articles[indexPath.row]
        cell.imageView?.image = imageView
        cell.textLabel?.text = article["title"]!
        cell.detailTextLabel?.text = article["userid"]!
        return cell
    }
    
    
    

    @IBAction func reload(_ sender: UIButton) {
    }
    @IBAction func add(_ sender: UIButton) {
    }
}

