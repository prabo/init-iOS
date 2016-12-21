//
//  Mission.swift
//  init
//
//  Created by Atsuo on 2016/12/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//
import SwiftyJSON
import Foundation

final class Mission {
    var id: Int
    var title: String
    var description: String
    var authorId: String
    var isCompleted: Bool

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.authorId = json["author_id"].stringValue
        self.isCompleted = json["is_completed"].boolValue
    }
}
