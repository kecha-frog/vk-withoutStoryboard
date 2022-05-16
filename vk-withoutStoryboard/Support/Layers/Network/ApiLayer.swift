//
//  FetchApiVK.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation

// MARK: - Helper
final class HelperApiLayer {
    enum ServiceError: Error {
        case parseError
        case requestError(Error)
        case otherError(String)
    }

    enum Method: String {
        case POST
        case GET
    }

    enum Path: String {
        case getFriends = "/method/friends.get"
        case getPhotos = "/method/photos.get"
        case getGroups = "/method/groups.get"
        case searchGroup = "/method/groups.search"
        case getCatalogGroups = "/method/groups.getCatalog"
        case getNews = "/method/newsfeed.get"
        case getUser = "/method/users.get"
    }
}

// MARK: - Protocol
private protocol ApiLayerProtocol {
    func request<T: ModelApiVK>(
        _ model: T.Type,
        method: HelperApiLayer.Method,
        path: HelperApiLayer.Path,
        params: [String: String]?,
        completion: @escaping (Result<JSONResponse<T>, HelperApiLayer.ServiceError>) -> Void)

    func requestItems<T: ModelApiVK>(
        _ model: T.Type,
        method: HelperApiLayer.Method,
        path: HelperApiLayer.Path,
        params: [String: String]?,
        completion: @escaping (Result<JSONResponseItems<T>, HelperApiLayer.ServiceError>) -> Void)

    func requestCheckToken( _ completion : @escaping (Bool) -> Void )
}

private extension ApiLayerProtocol {
    // MARK: - Private Properties
    private var httpSession: URLSession {
        URLSession(configuration: URLSessionConfiguration.default)
    }

    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        return components
    }

    /// получение токена из Keychain
    var token: String? {
        KeychainLayer.standart.get(.token)
    }

    var params: [URLQueryItem] {
        [.init(name: "v", value: "5.131")]
    }

    // MARK: - Private Methods
    func _requestPrivate(
        method: HelperApiLayer.Method,
        path: HelperApiLayer.Path,
        params: [String: String]?,
        completion: @escaping (Result<Data, HelperApiLayer.ServiceError>) -> Void) {
        var localParams: [URLQueryItem] = self.params
        if params != nil {
            params?.forEach { key, value in
                localParams.append(.init(name: key, value: value))
            }
        }
        localParams.append(.init(name: "access_token", value: token))

        var localUrlComponents: URLComponents = self.urlComponents
        localUrlComponents.path = path.rawValue
        localUrlComponents.queryItems = localParams

        guard let url: URL = localUrlComponents.url else {
            completion(.failure(.otherError("no url")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let task: URLSessionDataTask = httpSession.dataTask(with: request) { data, _, error in
            guard let validData = data, error == nil else {
                if let error: Error = error {
                    DispatchQueue.main.async {
                        completion(.failure(.requestError(error)))
                    }
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(validData))
            }
        }
        task.resume()
    }

}

/// Singleton для работы  с Api.
final class ApiLayer: ApiLayerProtocol {
    // MARK: - Static Properties
    /// Singleton
    static let standart = ApiLayer()

    // MARK: - Private Initializers
    private init() {}

    // MARK: - Public Methods
    /// Запрос на сервер Api.
    /// - Parameters:
    ///   - model: Объект декодирования ответа сервера
    ///   - method: Метод запроса GET или POST.
    ///   - path: путь к api
    ///   - params: параметры запроса
    ///   - completion: Замыкание. Передает: `Result` c декодированным ответом  сервера или ошибку.
    func request<T: ModelApiVK>(
        _ model: T.Type,
        method: HelperApiLayer.Method,
        path: HelperApiLayer.Path,
        params: [String: String]?,
        completion: @escaping (Result<JSONResponse<T>, HelperApiLayer.ServiceError>) -> Void) {
        _requestPrivate(method: method, path: path, params: params) { result in
            switch result {
            case .success(let data):
                do {
                    // декодирование ответа сервера
                    let response: JSONResponse<T> = try JSONDecoder().decode(JSONResponse<T>.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.parseError))
                        print(error)
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print(error)
                }
            }
        }
    }

    /// Запрос списка на сервер Api.
    /// - Parameters:
    ///   - model: Объект декодирования ответа сервера
    ///   - method: Метод запроса GET или POST.
    ///   - path: путь к api
    ///   - params: параметры запроса
    ///   - completion: Замыкание. Передает: `Result` c декодированным ответом  сервера или ошибку.
    func requestItems<T: ModelApiVK>(
        _ model: T.Type,
        method: HelperApiLayer.Method,
        path: HelperApiLayer.Path,
        params: [String: String]?,
        completion: @escaping (Result<JSONResponseItems<T>, HelperApiLayer.ServiceError>) -> Void) {
        _requestPrivate(method: method, path: path, params: params) { result in
            switch result {
            case .success(let data):
                let dispatchGroup = DispatchGroup()
                let decoder = JSONDecoder()

                do {
                    let json: [String: Any]? = try JSONSerialization.jsonObject(
                        with: data,
                        options: .mutableContainers
                    ) as? [String: Any]
                    let responseJson: [String: Any]? = json?["response"] as? [String: Any]
                    guard let responseJson: [String: Any] = responseJson else { return }

                    var items: [T]?
                    var count: Int?
                    var profiles: [NewsProfileModel]?
                    var groups: [NewsGroupModel]?

                    // Многопоточный парсинг данных.
                    DispatchQueue.global().async(group: dispatchGroup) {
                        do {
                            let itemsData = try JSONSerialization.data(withJSONObject: responseJson["items"] as Any)
                            items = try decoder.decode([T].self, from: itemsData)

                            count = responseJson["count"] as? Int
                        } catch {
                            completion(.failure(.parseError))
                            print(error)
                        }
                    }

                    // Если запрос новости, то дополнительно приходят профили и группы
                    if model == NewsPostModel.self {
                        // Многопоточный парсинг данных.
                        DispatchQueue.global().async(group: dispatchGroup) {
                            do {
                                let profilesData = try JSONSerialization.data(
                                    withJSONObject: responseJson["profiles"] as Any)
                                profiles = try decoder.decode([NewsProfileModel].self, from: profilesData)
                            } catch {
                                completion(.failure(.parseError))
                                print(error)
                            }
                        }
                        // Многопоточный парсинг данных.
                        DispatchQueue.global().async(group: dispatchGroup) {
                            do {
                                let groupsData = try JSONSerialization.data(
                                    withJSONObject: responseJson["groups"] as Any)
                                groups = try decoder.decode([NewsGroupModel].self, from: groupsData)
                            } catch {
                                completion(.failure(.parseError))
                                print(error)
                            }
                        }
                    }

                    dispatchGroup.notify(queue: DispatchQueue.main) {
                        guard let items = items else { return }

                        let responseApi = JSONResponseItems(items, count, profiles, groups)
                        completion(.success(responseApi))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.parseError))
                        print(error)
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print(error)
                }
            }
        }
    }

    /// Проверка токена на валидность с помощью Api.
    /// - Parameter completion: Замыкание.  Передает:  bool - исходя из ответа сервера.
    func requestCheckToken( _ completion : @escaping (Bool) -> Void ) {
        _requestPrivate(method: .GET, path: .getUser, params: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let json: [String: Any]? = try JSONSerialization.jsonObject(
                        with: data,
                        options: .mutableContainers
                    ) as? [String: Any]

                    DispatchQueue.main.async {
                        // проверка рабочий ли токен (придёт response или error)
                        if let result: Bool = json?.keys.contains("response") {
                            completion(result)
                        } else {
                            completion(false)
                        }
                    }
                } catch {
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
