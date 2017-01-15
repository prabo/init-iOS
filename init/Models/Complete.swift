import Foundation
import SwiftyJSON

class Complete: JsonInitializable {

    var id: Int
    var createdAt: Date
    var mission: Mission
    var user: User

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
        self.mission = Mission(json: json["mission"])
        self.user = User(json: json["user"])
    }

    static func collection(json: JSON) -> [Complete] {
        return json.arrayValue.map {
            Complete(json: $0)
        }
    }
}
