//
//  Mission.swift
//  init
//
//  Created by Atsuo on 2016/12/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import SwiftyJSON
import Foundation

class Mission: JsonInitializable {
    var id: Int
    var title: String
    var description: String
    var isCompleted: Bool
    //category
    var category: Category
    //author
    var author: User
    var completedUsers: [User]?

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.isCompleted = json["is_completed"].boolValue
        self.category = Category(json: json["category"])
        self.author = User(json: json["author"])
        if json["completed_users"].exists() {
            self.completedUsers = User.collection(json: json["completed_users"])
        }
    }

    static func collection(json: JSON) -> [Mission] {
        return json.arrayValue.map {
            Mission(json: $0)
        }
    }

    func generateParam() -> MissionParam {
        return MissionParam(title: self.title, description: self.description, categoryId: self.category.id)
    }
}

class MissionParam: APIParamsConvertible {
    var title: String
    var description: String
    var categoryId: Int
    public var APIParams: [String: Any]

    required init(title: String, description: String, categoryId: Int) {
        self.title = title
        self.description = description
        self.categoryId = categoryId
        self.APIParams = [
            "title": title,
            "description": description,
            "category_id": categoryId
        ]
    }
}
