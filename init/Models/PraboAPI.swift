import Alamofire
import RxSwift
import SwiftyJSON

class PraboAPI {
    static let shareInstance = PraboAPI()
    static let base_url = "https://init-api.elzup.com/v1"
    
    public func request(router: RouterPath, parameters: [String: AnyObject] = [:])
        -> Observable<JSON> {
            return Observable.create { observer -> Disposable in
                let headers: HTTPHeaders = [
                    "Authorization":UserDefaultsHelper.getToken(),
                    "Accept": "application/json"
                ]
                Alamofire.request(
                    router.url,
                    method: router.method,
                    parameters: parameters,
                    headers: headers
                    ).responseJSON { response in
                        guard let object = response.result.value else {
                            return
                        }
                        let json = JSON(object)
                        observer.onNext(json)
                }
                return Disposables.create()
            }
    }

    public func authHeaders() -> HTTPHeaders {
        // TODO: 依存性
        return [ "Authorization": UserDefaultsHelper.getToken() ]
    }
}

extension PraboAPI {
    func getUser(userId: Int) -> Observable<Session> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.User.Get(userId))
                .subscribe(
                    onNext: { json in
                        let session = Session(json: json)
                        observer.onNext(session)
                }
            )
            return Disposables.create()
        }
    }
}
