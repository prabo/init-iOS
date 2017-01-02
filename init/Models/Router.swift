import Foundation
import Alamofire

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
        case Post

        var method: HTTPMethod {
            switch self {
            case .Get: return .get
            case .Post: return .post
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

    enum Mission: RouterPath {

        case Get(Int)
        case GetAll
        case Post
        case Put(Int)
        case Delete(Int)
        case PutComplete(Int)
        case PutUncomplete(Int)

        var method: HTTPMethod {
            switch self {
            case .Get, .GetAll: return .get
            case .Post, .PutComplete, .PutUncomplete: return .post
            case .Put: return .put
            case .Delete: return .delete
            }
        }

        var path: String {
            switch self {
            case .Get(let id), .Put(let id), .Delete(let id):
                return "/missions/\(id)"
            case .Post, .GetAll:
                return "/missions"
            case .PutComplete(let id):
                return "/missions/\(id)/complete"
            case .PutUncomplete(let id):
                return "/missions/\(id)/uncomplete"
            }
        }

        var url: String {
            return Router.base_url + path
        }
    }

}
