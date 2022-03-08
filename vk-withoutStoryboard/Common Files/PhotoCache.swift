//
//  PhotoCache.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.03.2022.
//

import UIKit

protocol PhotoCacheProtocol: AnyObject {
    func getImage(for url: URL) -> UIImage?
    func saveImage(_ image: UIImage?, for url: URL)
    func deleteImage(for url: URL)
    func clearCache()
}

/// куширование изображений
final class PhotoCache {
    // синглтон
    static let standart = PhotoCache()
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = countLimit
        return cache
    }()

    let countLimit: Int

    init(countLimit: Int = 40) {
        self.countLimit = countLimit
    }
}

extension PhotoCache: PhotoCacheProtocol {
    /// получить кэшированное изображение
    /// - Parameter url: адрес
    /// - Returns: UIImage или nil
    func getImage(for url: URL) -> UIImage? {
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
    /// кэшировать изображение
    /// - Parameters:
    ///   - image: изображение
    ///   - url: ключом является URL
    func saveImage(_ image: UIImage?, for url: URL) {
        guard
            let image = image
        else {
            return deleteImage(for: url)
        }
        imageCache.setObject(image as AnyObject, forKey: url as AnyObject)
    }
    
    
    /// удалить кэшированное изображение по ключу
    /// - Parameter url:  адрес
    func deleteImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
    }
    
    /// очистка всего кэша
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
