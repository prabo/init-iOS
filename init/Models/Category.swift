//
//  Category.swift
//  init
//
//  Created by Atsuo Yonehara on 2016/12/30.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import SwiftyJSON

class Category {
    var categoryID: String
    var categoryName: String
    
    required init(json: JSON) {
        self.categoryID = json["id"].stringValue
        self.categoryName = json["name"].stringValue
    }
}
