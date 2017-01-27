//
//  Category.swift
//  init
//
//  Created by Atsuo Yonehara on 2016/12/30.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import SwiftyJSON

class Category: JsonInitializable {
    var id: Int
    var name: String
    var missions: [Mission]?

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        if json["missions"].exists() {
            self.missions = Mission.collection(json: json["missions"])
        }
    }

    static func collection(json: JSON) -> [Category] {
        return json.arrayValue.map {
            Category(json: $0)
        }
    }

    func generateParam() -> CategoryParam {
        return CategoryParam(name: self.name)
    }
}

class CategoryParam: APIParamsConvertible {
    var name: String
    public var APIParams: [String: Any]

    required init(name: String) {
        self.name = name
        self.APIParams = [
            "name": name
        ]
    }
}
