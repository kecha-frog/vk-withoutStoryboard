//
//  FetchPost.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation

// MARK: задание 2:
//запрос API
class FetchPost{
    func reguest(complition: (([FetchDataModel]) -> ())?) {
        let httpURL = URL(string:"https://jsonplaceholder.typicode.com/posts/")!
        let httpSession = URLSession.shared.dataTask(with: httpURL) { (data, response, error) in
            guard let validData = data, error == nil else {
                DispatchQueue.main.async{
                    print (error, "Error")
                }
                return
            }
            DispatchQueue.main.async{
                do {
                    let codableData = try JSONDecoder().decode ([FetchDataModel].self, from: validData)
                    complition?(codableData)
                } catch let error {
                    print( "Catch error", error.localizedDescription)
                }
            }
        }
        httpSession.resume()
    }
}
