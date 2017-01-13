import Foundation
import SwiftyJSON

final class User: JsonInitializable {
    var id: Int = -1
    var username: String = ""
    var createdMissions: [Mission] = []

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.username = json["username"].stringValue
        if json["created_missions"].exists() {
            self.createdMissions = Mission.collection(json: json[""])
        }
    }

    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }

    static func collection(json: JSON) -> [User] {
        return json.arrayValue.map {
            User(json: $0)
        }
    }
}
