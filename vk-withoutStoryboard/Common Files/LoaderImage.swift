//
//  LoaderImage.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 08.03.2022.
//

import UIKit

/// Загрузка изображений (выбор кэшировать или нет)
class LoaderImage{
    static var standart = LoaderImage()
    
    private let httpSession = URLSession(configuration: URLSessionConfiguration.default)
    
    /// загрузка по url, по дефолту кэширование отключено
    /// - Parameters:
    ///   - url: адрес
    ///   - cacheOn: включить кэширование, (по дефолту кэширование отключено)
    ///   - completion: замыкание UIImage
    func load(url: String, cacheOn:Bool = false, completion: @escaping (UIImage)-> Void){
        guard let urlImage = URL(string: url) else {
            return
        }
        
        if let imageChache = PhotoCache.standart.getImage(for: urlImage), cacheOn {
            completion(imageChache)
        }else{
            let task = httpSession.dataTask(with: urlImage) { data, response, error in
                guard let validData = data, let image = UIImage(data: validData), error == nil else {
                    debugPrint(error!)
                    return
                }
                
                if cacheOn{
                    PhotoCache.standart.saveImage(image, for: urlImage)
                }
                
                DispatchQueue.main.async{
                    completion(image)
                }
            }
            task.resume()
        }
    }
}
