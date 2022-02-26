//
//  FetchPost.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation

extension fetchApiVK{
    enum Method:String{
        case POST
        case GET
    }
    
    enum Path:String{
        case getFriends = "/method/friends.get"
        case getPhotos = "/method/photos.get"
        case getGroups = "/method/groups.get"
        case searchGroup = "/method/groups.search"
    }
}

// Запросы
class fetchApiVK{
    private let httpSession = URLSession(configuration: URLSessionConfiguration.default)
    
    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        return components
    }()
    
    private var params:[URLQueryItem] = [
        .init(name: "access_token", value: Session.instance.token),
        .init(name: "v", value: "5.131")
    ]
    
    final func reguest(method: Method, path: Path, params: [String:String]?, complition: @escaping (Any) -> Void) {
        if (params != nil){
            params?.forEach({ (key, value) in
                self.params.append(.init(name: key, value: value))
            })
        }
        
        urlComponents.path = path.rawValue
        urlComponents.queryItems = self.params
        
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
                //let codableData = try JSONDecoder().decode ([FetchDataModel].self, from: validData)
                let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                complition(json)
            } catch let error {
                print( "Catch error", error.localizedDescription)
            }
        }
        task.resume()
    }

}
