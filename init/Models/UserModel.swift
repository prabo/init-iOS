import Foundation
import SwiftyJSON

final class UserModel {
    dynamic var id: Int = -1
    dynamic var username: String = ""
    dynamic var createdMissions: [Mission]?
    
    convenience required init(object: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.username = json["username"].stringValue
        if let missionsJson = json["created_missions"].arrayValue {
            // self.createdMissions = missionsJson.each
        }
    }
    
    static func collection(object: JSON) -> [UserModel] {
        return object.arrayValue.map { UserModel(object: $0) }
    }
}
