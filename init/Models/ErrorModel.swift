import Foundation

final class ErrorModel {
    var message = ""

    required init(object: JSON) {
        self.message = object["error"]
    }
}

