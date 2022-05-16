//
//  LoaderImageLayer.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 08.03.2022.
//

import UIKit

// MARK: - Extension
extension LoaderImageLayer {
    // перечисление режимов работы кэширования
    enum CacheWork {
        case on
        case off
    }
}

/// Singleton для загрузки изображения  с возможностью кеширования.
final class LoaderImageLayer {
    // MARK: - Private Properties
    private let cacheImage = PhotoFileCacheLayer()
    private let httpSession = URLSession(configuration: URLSessionConfiguration.default)

    // MARK: - Static Properties
    ///  Singleton
    static var standart = LoaderImageLayer()

    // MARK: - Private Initializers
    private init() {}

    // MARK: - Public Methods
    /// Загрузка изображения по url адресу с возможным кэшированием и получение изображения из кэша.
    /// - Parameters:
    ///   - url: Url адрес изображения.
    ///   - cache: включение кэширования.
    ///   - completion: Замыкание.  Передает:  `UIImage` -  изображение  полученное по url.
    ///
    ///  По умолчанию кэширование изображение отключено.
    func load(url: String, cache: CacheWork = .off, completion: @escaping (UIImage) -> Void) {
        // Проверяем url
        guard let url = URL(string: url) else {
            return
        }

        // если кэширование включено, проверяем есть ли изобюражение в кэше
        if cache == .on, let imageCache = cacheImage.images[url.absoluteString] {
            completion(imageCache)
        } else if cache == .on, let imageFileCache: UIImage = cacheImage.getImage(url: url) {
            completion(imageFileCache)
        } else {
            // загрузка изображения по url
            let task: URLSessionDataTask = httpSession.dataTask(with: url) { data, _, error in
                guard let validData: Data = data, let image = UIImage(data: validData), error == nil else {
                    if let error: Error = error {
                        print(error)
                    }
                    return
                }
                // если кэширование включено, то производим сохранение в кэш
                if cache == .on {
                    self.cacheImage.saveImage(url: url, dataImage: validData)
                }

                DispatchQueue.main.async {
                    completion(image)
                }
            }
            task.resume()
        }
    }
}
