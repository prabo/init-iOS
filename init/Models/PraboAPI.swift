import Alamofire
import RxSwift

class PraboAPI {
    static let shareInstance = PraboAPI()
    static let base_url = "https://init-api.elzup.com/v1"
    
    public func request(router: RouterPath, parameters: [String: AnyObject] = [:], headers: HTTPHeaders = [:])
        -> Observable<DataResponse<Any>> {
            return Observable.create { observer -> Disposable in
                headers += authHeaders()
                Alamofire.request(router.url, method: router.method, parameters: parameters, headers: headers).responseJSON { response in
                    observer.onNext(response)
                }
                return AnonymousDisposable { }
            }
    }

    public func authHeaders() -> HTTPHeaders {
        // TODO: 依存性
        return [ "Authorization": UserDefaultsHelper.getToken() ]
    }
}

extension PraboAPI {
    class User {
        func Get(userId: Int) -> Observable<User> {
            return Observable.create { (observer) -> Disposable in
                _ = request(Router.User.Get())
                
                
            return PraboAPI.manager.rx_request(Router.User.Get(userId)).flatMap{
                manager.rx_responseResult(responseSerializer: Request.ObjectMapperSerializer("user"))
            }.flatMap { _, user in
                Observable.just(user)
            }
        }

        static func Create(params: UserParams) -> Observable<AnyObject> {
            return PraboAPI.manager.rx_request(Router.User.Post(params)).flatMap{
                manager.rx_responseResult(responseSerializer: Request.ObjectMapperSerializer("user"))
            }.flatMap { _, user in
                Observable.just(user)
            }
        }

        static func Update(params: UserParams) -> Observable<AnyObject> {
            // 処理結果を使わない場合は、とりあえずjsonで返しておく。(Observableは必ず返す必要があるため。)
            return PraboAPI.manager.rx_request(Router.User.Patch(params)).flatMap {$0.rx_JSON()}
        }
    }
}
