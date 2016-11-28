//
//  MissionListTableViewCell.swift
//  init
//
//  Created by Atsuo on 2016/11/10.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

class MissionListTableViewCell: UITableViewCell {

    @IBOutlet weak var missionNameLabel: UILabel!
    @IBOutlet weak var check: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
