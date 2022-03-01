//
//  FetchApiVK.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation
import UIKit

struct JSONResponse<T:Decodable>: Decodable{
    let count: Int
    let items: [T]
    
    private enum CodingKeys:String, CodingKey{
        case response
    }
    
    private enum ResponseKeys:String, CodingKey{
        case count
        case items
    }
    
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        let test = try response.nestedContainer(keyedBy: ResponseKeys.self,forKey: .response)
        self.count = try test.decode(Int.self, forKey: .count)
        self.items = try test.decode([T].self, forKey: .items)
    }
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
        .init(name: "access_token", value: Session.instance.token),
        .init(name: "v", value: "5.131")
    ]
    
    private init(){}
    
    final func reguest<T:Decodable>(_ type: T.Type, method: Method, path: Path, params: [String:String]?, completion: @escaping (JSONResponse<T>) -> Void) {
        var localParams:[URLQueryItem] = self.params
        if (params != nil){
            params?.forEach({ (key, value) in
                localParams.append(.init(name: key, value: value))
            })
        }
        
        urlComponents.path = path.rawValue
        urlComponents.queryItems = localParams
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        
        let task = httpSession.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else {
                DispatchQueue.main.async{
                    print (error as Any, "Error")
                }
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: validData, options: .mutableContainers)
//                print(json)
                let codableData = try JSONDecoder().decode (JSONResponse<T>.self, from: validData)
                
                DispatchQueue.main.async {
                    completion(codableData)
                }
            }catch {
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
