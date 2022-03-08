//
//  FetchApiVK.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation
import UIKit

extension ApiVK{
    enum ServiceError: Error{
        case parseError
        case requestError(Error)
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
        case getAllGroups = "/method/groups.getCatalog"
    }
}

final class ApiVK{
    /// синглтон
    static let standart = ApiVK()
    
    private let httpSession = URLSession(configuration: URLSessionConfiguration.default)
    
    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        return components
    }()

    private final var params:[URLQueryItem] = [
        .init(name: "v", value: "5.131")
    ]
    
    private init(){}
    
    /// Запрос к апи (вернет в замыкание  ошибку или результат)
    /// - Parameters:
    ///   - modelSelf: модель (self) для декодирования ответа api
    ///   - method: метод GET или POST
    ///   - path: путь url
    ///   - params: параметры запроса
    ///   - completion: замыкание с ассихронным  ответом
    func reguest<T:ModelApiVK>(_ modelSelf: T.Type, method: Method, path: Path, params: [String:String]?, completion: @escaping (Result<JSONResponse<T>, ServiceError>) -> Void) {
        var localParams:[URLQueryItem] = self.params
        if (params != nil){
            params?.forEach({ (key, value) in
                localParams.append(.init(name: key, value: value))
            })
        }
        /// получение токена
        let token = Keychain.standart.get(.token)
        localParams.append(.init(name: "access_token", value: token))
        
        urlComponents.path = path.rawValue
        urlComponents.queryItems = localParams
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        
        let task = httpSession.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else {
                DispatchQueue.main.async{
                    completion(.failure(.requestError(error!)))
                }
                return
            }
            
            do {
                // декодирование
                let codableData = try JSONDecoder().decode(JSONResponse<T>.self, from: validData)
                
                DispatchQueue.main.async {
                    completion(.success(codableData))
                }
            }catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    /// проверка токена на валидность, возращает в замыкание булевое значение
    /// - Parameter completion: замыкание  (Bool) -> Void
    func checkToken( _ completion : @escaping (Bool) -> Void ){
        /// получение токена
        let token = Keychain.standart.get(.token)
        
        var localParams:[URLQueryItem] = self.params
        localParams.append(.init(name: "access_token", value: token))
        
        urlComponents.path = "/method/users.get"
        urlComponents.queryItems = localParams
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = Method.GET.rawValue
        
        let task = httpSession.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else {
                DispatchQueue.main.async{
                    completion(false)
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: .mutableContainers) as? [String: Any]
                
                DispatchQueue.main.async{
                    //проверка рабочий ли токен (придёт response или error)
                    if let result = json?.keys.contains("response"), result == true{
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }catch {
                completion(false)
            }
        }
        task.resume()
    }
}
