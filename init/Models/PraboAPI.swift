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
    func getUser(userId: Int) -> Observable<ResultModel<UserModel>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.User.Get(userId))
                .subscribe(
                    onNext: { json in
                        observer.onNext(ResultModel<UserModel>(json: json))
                }
            )
            return Disposables.create()
        }
    }

    func createUser(username: String, password: String) -> Observable<ResultModel<SessionModel>> {
        let params = [
            username: username,
            password: password,
        ]
        
        return Observable.create { observer -> Disposable in
            self.request(router: Router.User.Post, parameters: params as [String : AnyObject])
                .subscribe(
                    onNext: { json in
                        observer.onNext(ResultModel<SessionModel>(json: json))
                }
            )
            return Disposables.create()
        }
    }
}
