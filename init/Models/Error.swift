import Foundation
import SwiftyJSON

final class Error {
    var message = ""

    required init(json: JSON) {
        self.message = json["error"].stringValue
    }
}
