//
//  MissionEditController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MissionEditController: UIViewController {
    var mission: Mission?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func changeMission() {
    }
    func deleteMission() {
        guard let m = mission else {
            return print("mission is nill")
        }
        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        let str = m.id.description
        Alamofire.request("https://init-api.elzup.com/v1/missions/"+str,
                          method: .delete, headers:headers)
            .responseJSON { response in
        }
    }
    @IBAction func changeButton(_ sender: UIButton) {
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notChangeButton(_ sender: UIButton) {
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteMission()
        _=navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
}
