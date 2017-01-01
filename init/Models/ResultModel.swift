import Foundation

class ResultModel<ModelType> {
    var data: ModelType?
    var error: ErrorModel?
    required init(object: JSON) {
        if object["error"].exists() {
            self.error = ErrorModel(object)
            return
        }
        self.data = ModelType(object)
    }

    func isErorr() {
        return self.error != null
    }
}

