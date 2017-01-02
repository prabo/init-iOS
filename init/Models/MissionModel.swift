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
    var isCompleted: Bool
    //category
    var categoryID: String
    var categoryName: String
    //author
    var author: UserModel
    var completedUsers: [UserModel]?

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.isCompleted = json["is_completed"].boolValue
        self.categoryID = json["category"]["id"].stringValue
        self.categoryName = json["category"]["name"].stringValue
        self.author = UserModel(json: json["author"])
        if json["completed_users"].exists() {
            self.completedUsers = UserModel.collection(json: json["completed_users"])
        }
    }

    static func collection(json: JSON) -> [MissionModel] {
        return json.arrayValue.map {
            MissionModel(json: $0)
        }
    }

    func generateParam() -> MissionParam {
        return MissionParam(title: self.title, description: self.description, categoryID: self.categoryID)
    }
}

final class MissionParam: APIParamsConvertible  {
    var title: String
    var description: String
    var categoryID: String
    public var APIParams: Dictionary<String, Any>

    required init(title: String, description: String, categoryID: String) {
        self.title = title
        self.description = description
        self.categoryID = categoryID
        self.APIParams = [
                "title": title,
                "description": description,
                "category_id": categoryID
        ]
    }
}
