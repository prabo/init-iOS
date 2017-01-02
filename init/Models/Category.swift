//
//  Category.swift
//  init
//
//  Created by Atsuo Yonehara on 2016/12/30.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryModel: JsonInitializable {
    var id: Int
    var name: String

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }

    static func collection(json: JSON) -> [CategoryModel] {
        return json.arrayValue.map {
            CategoryModel(json: $0)
        }
    }

    func generateParam() -> CategoryParam {
        return CategoryParam(name: self.name)
    }
}

final class CategoryParam: APIParamsConvertible {
    var name: String
    public var APIParams: [String: Any]

    required init(name: String) {
        self.name = name
        self.APIParams = [
                "name": name
        ]
    }
}
