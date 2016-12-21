//
//  MissionListTableViewCell.swift
//  init
//
//  Created by Atsuo on 2016/11/10.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit

final class MissionListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var missionNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
