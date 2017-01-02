import Alamofire
import RxSwift
import SwiftyJSON

class PraboAPI {
    static let sharedInstance = PraboAPI()
    static let base_url = "https://init-api.elzup.com/v1"

    public func request(router: RouterPath, parameters: [String: Any] = [:])
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
            "username": username,
            "password": password,
        ]

        return Observable.create { observer -> Disposable in
            self.request(router: Router.User.Post, parameters: params)
                .subscribe(
                    onNext: { json in
                        observer.onNext(ResultModel<SessionModel>(json: json))
                }
            )
            return Disposables.create()
        }
    }

    func getMission(id: Int) -> Observable<ResultModel<MissionModel>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Get(id))
                    .subscribe(
                            onNext: { json in
                                observer.onNext(ResultModel<MissionModel>(json: json))
                            }
                    )
            return Disposables.create()
        }
    }

    func getMissions() -> Observable<ResultsModel<MissionModel>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.GetAll)
                    .subscribe(
                            onNext: { json in
                                observer.onNext(ResultsModel<MissionModel>(json: json))
                            }
                    )
            return Disposables.create()
        }
    }

    func updateMission(mission: MissionModel) -> Observable<ResultModel<MissionModel>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Put(mission.id), parameters: mission.generateParam().APIParams)
                    .subscribe(onNext: { json in
                        observer.onNext(ResultModel<MissionModel>(json: json))
                    })
            return Disposables.create()
        }
    }

    func deleteMission(mission: MissionModel) -> Observable<ResultModel<MissionModel>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Delete(mission.id))
                    .subscribe(onNext: { json in
                        observer.onNext(ResultModel<MissionModel>(json: json))
                    })
            return Disposables.create()
        }
    }

    func createMission(param: MissionParam) -> Observable<ResultModel<MissionModel>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Post, parameters: param.APIParams)
                    .subscribe(onNext: { json in
                        observer.onNext(ResultModel<MissionModel>(json: json))
                    })
            return Disposables.create()
        }
    }

}
