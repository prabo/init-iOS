//
//  CategoryListController.swift
//  init
//
//  Created by Atsuo Yonehara on 2016/12/25.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class CategoryListController: UITableViewController {

    var categories: [CategoryModel] = []

    @IBAction func addButton(_ sender: UIButton) {
        navigationController?.pushViewController(
            Storyboard.MissionCategoryAddController.instantiate(CategoryAddController.self),
            animated: true)
    }

    @IBAction func reroadButton(_ sender: UIButton) {
        getCategoryLists()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.init()
        let username = userDefaults.string(forKey: "username")!
        self.navigationItem.title = username

        getCategoryLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        getCategoryLists()
    }

    func getCategoryLists() {

        let _ = PraboAPI.sharedInstance.getCategories()
                .subscribe(onNext: { (result: ResultsModel<CategoryModel>) in
                    // TODO: Error
                    guard let categories: [CategoryModel] = result.data else {
                        return
                    }
                    self.categories = categories
                    self.tableView.reloadData()
                })
    }
}

// MARK: UITableViewDataSource method

extension CategoryListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        guard let categoryCell = cell as? MissionCategoryTableViewCell else {
            return cell
        }
        categoryCell.categoryLabel.text = categories[indexPath.row].name
        return categoryCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.MissionListTableViewController.instantiate(MissionListController.self)
        let category = categories[indexPath.row]
        vc.category = category
        navigationController?.pushViewController(vc, animated: true)
    }
}
