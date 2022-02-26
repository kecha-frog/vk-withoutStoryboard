//
//  FetchPost.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation

// Запросы
class fetchApiVK{
    private var qeuryArray = [URLQueryItem]()
    
    init(){
        qeuryArray.append(.init(name: "access_token", value: Session.instance.token))
        qeuryArray.append(.init(name: "v", value: "5.131"))
    }
    
    final func reguest(method: method, path: path,params: [String:String]?, complition: @escaping (Any) -> Void) {
        let configuration = URLSessionConfiguration.default
        let httpSession = URLSession(configuration: configuration)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/" + path.rawValue
        
        if (params != nil){
            params?.forEach({ (key, value) in
                qeuryArray.append(.init(name: key, value: value))
            })
            
        }
        urlComponents.queryItems = qeuryArray
        var request  = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        
        let task = httpSession.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else {
                DispatchQueue.main.async{
                    print (error as Any, "Error")
                }
                return
            }
            DispatchQueue.main.async{
                do {
                    //let codableData = try JSONDecoder().decode ([FetchDataModel].self, from: validData)
                    let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                    complition(json)
                } catch let error {
                    print( "Catch error", error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    enum method:String{
        case POST
        case GET
    }
    
    enum path:String{
        case getFriends = "friends.get"
        case getPhotos = "photos.get"
        case getGroups = "groups.get"
        case searchGroup = "groups.search"
    }
    
}
