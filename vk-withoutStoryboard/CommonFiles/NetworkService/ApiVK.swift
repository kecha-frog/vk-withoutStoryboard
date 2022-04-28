//
//  FetchApiVK.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation

extension ApiVK{
    enum ServiceError: Error{
        case parseError
        case requestError(Error)
        case otherError(String)
    }
    
    enum Method:String{
        case POST
        case GET
    }
    
    enum Path:String{
        case getFriends = "/method/friends.get"
        case getPhotos = "/method/photos.get"
        case getGroups = "/method/groups.get"
        case searchGroup = "/method/groups.search"
        case getCatalogGroups = "/method/groups.getCatalog"
        case getNews = "/method/newsfeed.get"
        case getUser = "/method/users.get"
    }
}

/// Singleton для работы  с Api.
final class ApiVK{
    /// Singleton
    static let standart: ApiVK = ApiVK()
    
    private let httpSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    private var urlComponents: URLComponents {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        return components
    }
    
    /// получение токена из Keychain
    private var token: String? {
        Keychain.standart.get(.token)
    }
    
    private var params: [URLQueryItem] {
        [.init(name: "v", value: "5.131")]
    }
    
    private init(){}

    private func _requestPrivate(method: Method, path: Path, params: [String:String]?, completion: @escaping (Result<Data, ServiceError>) -> Void) {
        var localParams: [URLQueryItem] = self.params
        if (params != nil){
            params?.forEach({ (key, value) in
                localParams.append(.init(name: key, value: value))
            })
        }
        localParams.append(.init(name: "access_token", value: token))
        
        var localUrlComponents: URLComponents = self.urlComponents
        localUrlComponents.path = path.rawValue
        localUrlComponents.queryItems = localParams
        
        guard let url: URL = localUrlComponents.url else {
            completion(.failure(.otherError("no url")))
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task: URLSessionDataTask = httpSession.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else {
                if let error: Error = error{
                    DispatchQueue.main.async{
                        completion(.failure(.requestError(error)))
                    }
                }
                return
            }
            
            DispatchQueue.main.async{
                completion(.success(validData))
            }
        }
        task.resume()
    }
    
    /// Запрос на сервер Api.
    /// - Parameters:
    ///   - model: Объект декодирования ответа сервера
    ///   - method: Метод запроса GET или POST.
    ///   - path: путь к api
    ///   - params: параметры запроса
    ///   - completion: Замыкание. Передает: `Result` c декодированным ответом  сервера или ошибку.
    func request<T: ModelApiVK>(_ model: T.Type, method: Method, path: Path, params: [String:String]?, completion: @escaping (Result<JSONResponse<T>, ServiceError>) -> Void) {
        _requestPrivate(method: method, path: path, params: params) { result in
            switch result{
            case .success(let data):
                do {
                    // декодирование ответа сервера
                    let response: JSONResponse<T> = try JSONDecoder().decode(JSONResponse<T>.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                }catch {
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
    func requestItems<T: ModelApiVK>(_ model: T.Type, method: Method, path: Path, params: [String:String]?, completion: @escaping (Result<JSONResponseItems<T>, ServiceError>) -> Void) {
        _requestPrivate(method: method, path: path, params: params) { result in
            switch result{
            case .success(let data):
                let dispatchGroup = DispatchGroup()
                let decoder = JSONDecoder()
                
                do{
                    let json: [String:Any]? = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    let responseJson: [String:Any]? = json?["response"] as? [String : Any]
                    guard let responseJson = responseJson else { return}
                    
                    var items: [T]?
                    var count: Int?
                    var profiles: [NewsProfileModel]?
                    var groups: [NewsGroupModel]?
                    
                    // Если запрос новости, то дополнительно приходят профили и группы
                    if model == NewsPostModel.self{
                        // Многопоточный парсинг данных.
                        // Второй способ работы с DispatchGroup
                        DispatchQueue.global().async(group: dispatchGroup){
                            do {
                                let profilesData = try JSONSerialization.data(withJSONObject: responseJson["profiles"])
                                profiles = try decoder.decode([NewsProfileModel].self, from: profilesData)
                            }catch {
                                completion(.failure(.parseError))
                                print(error)
                            }
                            
                        }
                        // Многопоточный парсинг данных.
                        DispatchQueue.global().async(group: dispatchGroup){
                            do {
                                let groupsData = try JSONSerialization.data(withJSONObject: responseJson["groups"])
                                groups = try decoder.decode([NewsGroupModel].self, from: groupsData)
                            }catch {
                                completion(.failure(.parseError))
                                print(error)
                            }
                            
                        }
                    }
                    
                    // Многопоточный парсинг данных.
                    DispatchQueue.global().async(group: dispatchGroup){
                        do {
                            let itemsData = try JSONSerialization.data(withJSONObject: responseJson["items"])
                            items = try decoder.decode([T].self, from: itemsData)
                            
                            count = responseJson["count"] as? Int
                        }catch {
                            completion(.failure(.parseError))
                            print(error)
                        }
                        
                    }
                    
                    dispatchGroup.notify(queue: DispatchQueue.main){
                        guard let items = items else { return }
                        
                        let responseApi = JSONResponseItems(items, count, profiles, groups)
                        completion(.success(responseApi))
                    }
                    
                }catch{
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
    func requestCheckToken( _ completion : @escaping (Bool) -> Void ){
        _requestPrivate(method: .GET, path: .getUser, params: nil) { result in
            switch result{
            case .success(let data):
                do {
                    let json: [String:Any]? = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    
                    DispatchQueue.main.async{
                        //проверка рабочий ли токен (придёт response или error)
                        if let result: Bool = json?.keys.contains("response"){
                            completion(result)
                        }else{
                            completion(false)
                        }
                    }
                }catch {
                    
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
