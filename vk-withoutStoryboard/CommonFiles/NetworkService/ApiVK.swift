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
    
    /// Запрос на сервер Api.
    /// - Parameters:
    ///   - model: Объект декодирования ответа сервера
    ///   - method: Метод запроса GET или POST.
    ///   - path: путь к api
    ///   - params: параметры запроса
    ///   - completion: Замыкание. Передает: `Result` c декодированным ответом  сервера или ошибку.
    func reguest<T: ModelApiVK>(_ model: T.Type, method: Method, path: Path, params: [String:String]?, completion: @escaping (Result<JSONResponse<T>, ServiceError>) -> Void) {
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
            
            do {
                // декодирование ответа сервера
                let codableData: JSONResponse<T> = try JSONDecoder().decode(JSONResponse<T>.self, from: validData)
                
                DispatchQueue.main.async {
                    completion(.success(codableData))
                }
            }catch {
                DispatchQueue.main.async {
                    completion(.failure(.parseError))
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    /// Проверка токена на валидность с помощью Api.
    /// - Parameter completion: Замыкание.  Передает:  bool - исходя из ответа сервера.
    func checkToken( _ completion : @escaping (Bool) -> Void ){
        var localUrlComponents: URLComponents = self.urlComponents
        
        var localParams: [URLQueryItem] = self.params
        localParams.append(.init(name: "access_token", value: token))
        
        localUrlComponents.path = "/method/users.get"
        localUrlComponents.queryItems = localParams
        
        guard let url: URL = localUrlComponents.url else {
            completion(false)
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = Method.GET.rawValue
        
        let task: URLSessionDataTask = httpSession.dataTask(with: request) { (data, response, error) in
            guard let validData: Data = data, error == nil else {
                DispatchQueue.main.async{
                    completion(false)
                }
                return
            }
            
            do {
                let json: [String:Any]? = try JSONSerialization.jsonObject(with: validData, options: .mutableContainers) as? [String: Any]
                
                DispatchQueue.main.async{
                    //проверка рабочий ли токен (придёт response или error)
                    if let result: Bool = json?.keys.contains("response"){
                        completion(result)
                    }else{
                        completion(false)
                    }
                }
            }catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        task.resume()
    }
}
