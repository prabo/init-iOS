import Foundation
import SwiftyJSON

class CompleteModel: JsonInitializable {

    var id: Int
    var createdAt: Date
    var mission: MissionModel
    var user: UserModel

    required init(json: JSON) {
        self.id = json["id"].intValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let createdAt = dateFormatter.date(from: json["created_at"].stringValue) {
            self.createdAt = createdAt
        } else {
            // NOTE: bad
            self.createdAt = Date()
        }
        self.mission = MissionModel(json: json["mission"])
        self.user = UserModel(json: json["user"])
    }

    static func collection(json: JSON) -> [CompleteModel] {
        return json.arrayValue.map {
            CompleteModel(json: $0)
        }
    }
}
