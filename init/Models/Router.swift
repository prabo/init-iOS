import Foundation
import Alamofire

public protocol APIParamsConvertible {
    var APIParams: Dictionary<String, AnyObject> { get }
}

class UserParams: APIParamsConvertible {
    var username: String = ""
    var password: String = ""

    var APIParams: [String: AnyObject] {
        return [String: AnyObject]()
    }
}


class Router {
    static let base_url = "https://init-api.elzup.com/v1"
}

public protocol RouterPath {
    var method: HTTPMethod { get }
    var path: String { get }
    var url: String { get }
}

extension Router {

    enum User: RouterPath {

        case Get(Int)
        case Post(UserParams)

        var method: HTTPMethod {
            switch self {
            case .Get:
                return .get
            case .Post:
                return .post
            }
        }

        var path: String {
            switch self {
            case .Get(let userId):
                return "/users/\(userId)"
            case .Post:
                return "/users"
            }
        }

        var url: String {
            return Router.base_url + path
        }
    }

}
