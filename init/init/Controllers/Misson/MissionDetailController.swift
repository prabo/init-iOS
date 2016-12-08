//
//  MissionDetailController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

class MissionDetailController: UIViewController {
    
    var mission: Mission?
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let m = mission else {
            return
        }
        titleLabel.text = m.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func completeButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notCompleteButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func editButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MissionEditController", bundle: nil)
        let secondViewController = storyboard.instantiateInitialViewController() as! MissionEditController
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
}
