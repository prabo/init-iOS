import Foundation
import SwiftyJSON

protocol JsonInitializable {
    init(json: JSON)
}

class ResultModel<T: JsonInitializable> {
    var data: T?
    var error: ErrorModel?
    required init(json: JSON) {
        if json["error"].exists() {
            self.error = ErrorModel(json: json)
            return
        }
        self.data = T(json: json)
    }

    func isErorr() -> Bool {
        return self.error != nil
    }
}

