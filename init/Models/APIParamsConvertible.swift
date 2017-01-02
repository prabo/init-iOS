import Foundation

public protocol APIParamsConvertible {
    var APIParams: Dictionary<String, Any> { get }
}
