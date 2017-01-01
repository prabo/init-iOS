//
//  Mission.swift
//  init
//
//  Created by Atsuo on 2016/12/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//
import SwiftyJSON
import Foundation

final class MissionModel: JsonInitializable {
    var id: Int
    var title: String
    var description: String
    var authorId: String
    var isCompleted: Bool
    //category
    var categoryID: String
    var categoryName: String
    //author
    var authorID: Int
    var authorUsername: String

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.authorId = json["author_id"].stringValue
        self.isCompleted = json["is_completed"].boolValue
        self.categoryID = json["category"]["id"].stringValue
        self.categoryName = json["category"]["name"].stringValue
        self.authorID = json["author"]["id"].intValue
        self.authorUsername = json["author"]["username"].stringValue
    }
}
