import Foundation
import SwiftyJSON

protocol JsonInitializable {
    init(json: JSON)
}

class Result<T:JsonInitializable> {
    var data: T?
    var error: Error?
    required init(json: JSON) {
        if json["error"].exists() {
            self.error = Error(json: json)
            return
        }
        self.data = T(json: json)
    }

    func isErorr() -> Bool {
        return self.error != nil
    }
}

// TODO: 統一したい

class ResultsModel<T:JsonInitializable> {
    var data: [T]?
    var error: Error?
    required init(json: JSON) {
        if json["error"].exists() {
            self.error = Error(json: json)
            return
        }
        self.data = json.arrayValue.map {
            T(json: $0)
        }
    }

    func isErorr() -> Bool {
        return self.error != nil
    }
}
