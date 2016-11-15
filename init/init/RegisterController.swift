//
//  ViewController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var IDName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButton(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier:"ListNabi")
        nextVC?.modalTransitionStyle = .flipHorizontal
        present(nextVC!,animated: true,completion: nil)
    }

}
