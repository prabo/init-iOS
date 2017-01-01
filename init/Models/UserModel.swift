import Foundation
import SwiftyJSON

final class UserModel {
    var id: Int = -1
    var username: String = ""
    var createdMissions: [MissionModel] = []
    
    convenience required init(object: JSON) {
        self.init()
        self.id = object["id"].intValue
        self.username = object["username"].stringValue
        if object["created_missions"].exists() {
            // self.createdMissions = missionsJson.each
        }
    }
    
    static func collection(object: JSON) -> [UserModel] {
        return object.arrayValue.map { UserModel(object: $0) }
    }
}
