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
                "Authorization": UserDefaultsHelper.getToken(),
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
        return ["Authorization": UserDefaultsHelper.getToken()]
    }
}

extension PraboAPI {
    // User
    func getUser(userId: Int) -> Observable<Result<User>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.User.Get(userId))
                .subscribe(
                    onNext: { json in
                        observer.onNext(Result<User>(json: json))
                    }
                )
            return Disposables.create()
        }
    }

    func createUser(username: String, password: String) -> Observable<Result<Session>> {
        let params = [
            "username": username,
            "password": password
        ]

        return Observable.create { observer -> Disposable in
            self.request(router: Router.User.Post, parameters: params)
                .subscribe(
                    onNext: { json in
                        observer.onNext(Result<Session>(json: json))
                    }
                )
            return Disposables.create()
        }
    }

    // Mission
    func getMission(id: Int) -> Observable<Result<Mission>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Get(id))
                .subscribe(
                    onNext: { json in
                        observer.onNext(Result<Mission>(json: json))
                    }
                )
            return Disposables.create()
        }
    }

    func getMissions() -> Observable<ResultsModel<Mission>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.GetAll)
                .subscribe(
                    onNext: { json in
                        observer.onNext(ResultsModel<Mission>(json: json))
                    }
                )
            return Disposables.create()
        }
    }

    func updateMission(mission: Mission) -> Observable<Result<Mission>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Put(mission.id), parameters: mission.generateParam().APIParams)
                .subscribe(onNext: { json in
                    observer.onNext(Result<Mission>(json: json))
                })
            return Disposables.create()
        }
    }

    func deleteMission(mission: Mission) -> Observable<Result<Mission>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Delete(mission.id))
                .subscribe(onNext: { json in
                    observer.onNext(Result<Mission>(json: json))
                })
            return Disposables.create()
        }
    }

    func createMission(param: MissionParam) -> Observable<Result<Mission>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.Post, parameters: param.APIParams)
                .subscribe(onNext: { json in
                    observer.onNext(Result<Mission>(json: json))
                })
            return Disposables.create()
        }
    }

    func completeMission(mission: Mission) -> Observable<Result<Complete>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.PutComplete(mission.id))
                .subscribe(onNext: { json in
                    observer.onNext(Result<Complete>(json: json))
                })
            return Disposables.create()
        }
    }

    func uncompleteMission(mission: Mission) -> Observable<Result<Complete>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Mission.PutUncomplete(mission.id))
                .subscribe(onNext: { json in
                    observer.onNext(Result<Complete>(json: json))
                })
            return Disposables.create()
        }
    }

    // Category
    func getCategory(id: Int) -> Observable<Result<Category>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Category.Get(id))
                .subscribe(
                    onNext: { json in
                        observer.onNext(Result<Category>(json: json))
                    }
                )
            return Disposables.create()
        }
    }

    func getCategories() -> Observable<ResultsModel<Category>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Category.GetAll)
                .subscribe(
                    onNext: { json in
                        observer.onNext(ResultsModel<Category>(json: json))
                    }
                )
            return Disposables.create()
        }
    }

    func updateCategory(category: Category) -> Observable<Result<Category>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Category.Put(category.id), parameters: category.generateParam().APIParams)
                .subscribe(onNext: { json in
                    observer.onNext(Result<Category>(json: json))
                })
            return Disposables.create()
        }
    }

    func deleteCategory(category: Category) -> Observable<Result<Category>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Category.Delete(category.id))
                .subscribe(onNext: { json in
                    observer.onNext(Result<Category>(json: json))
                })
            return Disposables.create()
        }
    }

    func createCategory(param: CategoryParam) -> Observable<Result<Category>> {
        return Observable.create { observer -> Disposable in
            self.request(router: Router.Category.Post, parameters: param.APIParams)
                .subscribe(onNext: { json in
                    observer.onNext(Result<Category>(json: json))
                })
            return Disposables.create()
        }
    }
}
