import Foundation

class CompleteModel: JsonInitializable {

    var id: Int
    var createdAt: NSDate
    var mission: MissionModel
    var user: UserModel

    required init(json: JSON) {
        self.id = json["id"].intValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSZZ"
        self.createdAt = dateFormatter.date(from: json["created_at"].stringValue)
        self.mission = MissionModel(json: json["mission"])
        self.user = MissionModel(json: json["user"])
    }

    static func collection(json: JSON) -> [CompleteModel] {
        return json.arrayValue.map {
            CompleteModel(json: $0)
        }
    }
}
