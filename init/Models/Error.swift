import Foundation
import SwiftyJSON

class Error {
    var message = ""

    required init(json: JSON) {
        self.message = json["error"].stringValue
    }
}
