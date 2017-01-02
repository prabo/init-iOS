import Foundation
import SwiftyJSON

final class ErrorModel {
    var message = ""

    required init(json: JSON) {
        self.message = json["error"].stringValue
    }
}

