import Foundation
import SwiftyJSON

final class UserModel: JsonInitializable {
    var id: Int = -1
    var username: String = ""
    var createdMissions: [MissionModel] = []

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.username = json["username"].stringValue
        if json["created_missions"].exists() {
            self.createdMissions = MissionModel.collection(json: json[""])
        }
    }
    
    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }

    static func collection(json: JSON) -> [UserModel] {
        return json.arrayValue.map { UserModel(json: $0) }
    }
}
