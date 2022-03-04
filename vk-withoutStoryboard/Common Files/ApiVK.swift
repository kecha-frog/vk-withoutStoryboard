//
//  FetchApiVK.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation
import UIKit

enum ServiceError: Error{
    case parseError
    case serverError
}

extension ApiVK{
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

// Запрос переделал на дженерик и синглтон, в будущем дабавлю обнавление токена по функции
class ApiVK{
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
    
    final func reguest<T:ModelApiVK>(_ modelSelf: T.Type, method: Method, path: Path, params: [String:String]?, completion: @escaping (Result<JSONResponse<T>, ServiceError>) -> Void) {
        var localParams:[URLQueryItem] = self.params
        if (params != nil){
            params?.forEach({ (key, value) in
                localParams.append(.init(name: key, value: value))
            })
        }
        
        let token = Keychain.standart.get(.token)
        localParams.append(.init(name: "access_token", value: token))
        
        
        urlComponents.path = path.rawValue
        urlComponents.queryItems = localParams
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        
        let task = httpSession.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else {
                DispatchQueue.main.async{
                    completion(.failure(.serverError))
                    debugPrint(error as Any)
                }
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: validData, options: .mutableContainers)
//                print(json)
                let codableData = try JSONDecoder().decode (JSONResponse<T>.self, from: validData)
                
                DispatchQueue.main.async {
                    completion(.success(codableData))
                }
            }catch {
                completion(.failure(.parseError))
                debugPrint(error)
            }
        }
        task.resume()
    }
}

// для удобной загрузки из интернета
extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
