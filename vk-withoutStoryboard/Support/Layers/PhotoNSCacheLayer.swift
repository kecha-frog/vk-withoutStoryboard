//
//  PhotoNSCacheLayer.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 22.05.2022.
//

import UIKit

protocol PhotoNSCacheLayerProtocol: AnyObject {
    func getImage(for url: URL) -> UIImage?
    func saveImage(_ image: UIImage?, for url: URL)
    func deleteImage(for url: URL)
    func deleteAllImage()
}

#warning("переписать нскэш")
/// Класс для кеширования изображений.
///
/// Доступно два вида кеширования:
/// singleton - cохранение кэша до закрытия приложения.
/// .init - сохранение на время жизни родительского класса.
final class PhotoNSCacheLayer {
    // MARK: - Private Properties
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache: NSCache<AnyObject, AnyObject> = NSCache<AnyObject, AnyObject>()
        cache.countLimit = countLimit
        return cache
    }()

    private let countLimit: Int

    // MARK: - Initializers
    /// Сохранение на время жизни родительского класса.
    /// - Parameter countLimit: лимит на сохранение в кэш.
    ///
    /// по умолчанию лимит 40.
    init(limit: Int) {
        countLimit = limit
    }
}

extension PhotoNSCacheLayer: PhotoNSCacheLayerProtocol {
    // MARK: - Public Methods
    /// Получение кэшированного изображения по url адресу.
    /// - Parameter url: url адрес изображения.
    /// - Returns: изображение или nil.
    func getImage(for url: URL) -> UIImage? {
        if let image: UIImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return image
        } else {
            return nil
        }
    }

    ///  Сохранение в кэш изображения.
    ///
    /// Ключом для сохранения изображения в кэш является его url адрес.
    /// - Parameters:
    ///   - image: изображение или  nil.
    ///   - url: url адрес изображения.
    func saveImage(_ image: UIImage?, for url: URL) {
        guard
            let image: UIImage = image
        else {

            #warning("понять для чего сделал удаление")
            return deleteImage(for: url)
        }
        imageCache.setObject(image as AnyObject, forKey: url as AnyObject)
    }

    /// Удаление кэшированного изображения.
    /// - Parameter url: url адрес изображения.
    func deleteImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
    }

    /// Очистка всего кэша.
    func deleteAllImage() {
        imageCache.removeAllObjects()
    }
}
