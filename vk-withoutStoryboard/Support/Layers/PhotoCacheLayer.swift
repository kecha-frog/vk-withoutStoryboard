//
//  PhotoCacheLayer.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.03.2022.
//

import UIKit

protocol PhotoCacheLayerProtocol: AnyObject {
    func getImage(for url: URL) -> UIImage?
    func saveImage(_ image: UIImage?, for url: URL)
    func deleteImage(for url: URL)
    func deleteAllImage()
}

/// Класс для кеширования изображений.
///
/// Доступно два вида кеширования:
/// singleton - cохранение кэша до закрытия приложения.
/// .init - сохранение на время жизни родительского класса.
final class PhotoRamCacheLayer {
    // MARK: - Private Properties
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache: NSCache<AnyObject, AnyObject> = NSCache<AnyObject, AnyObject>()
        cache.countLimit = countLimit
        return cache
    }()

    private let countLimit: Int

    // MARK: - Static Properties
    /// Singleton: cохранение кэша  до закрытия приложения.
    static let standart = PhotoRamCacheLayer()

    // MARK: - Initializers
    /// Сохранение на время жизни родительского класса.
    /// - Parameter countLimit: лимит на сохранение в кэш.
    ///
    /// по умолчанию лимит 40.
    init(countLimit: Int = 40) {
        self.countLimit = countLimit
    }
}

extension PhotoRamCacheLayer: PhotoCacheLayerProtocol {
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

final class PhotoFileCacheLayer {
    // MARK: - Public Properties
    var images = [String: UIImage]()
    
    // MARK: - Private Properties
    private static let pathName: String = {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask).first
        else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()

    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60

    // MARK: - Public Methods
    func saveImage(url: URL, dataImage: Data) {
        guard let fileName = getFilePath(url: url) else { return }
        FileManager.default.createFile(atPath: fileName, contents: dataImage, attributes: nil)
    }

    func getImage(url: URL) -> UIImage? {
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }

        let lifeTime = Date().timeIntervalSince(modificationDate)

        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: fileName) else { return nil }

        DispatchQueue.main.async {
            self.images[url.absoluteString] = image
        }

        return image
    }

    // MARK: - Private Methods
    private func getFilePath(url: URL) -> String? {
        guard let cachesDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask).first
        else { return nil }
        let hashName = url.absoluteString.split(separator: "?").first?.split(separator: "/").last ?? "default"

        return cachesDirectory.appendingPathComponent(PhotoFileCacheLayer.pathName + "/" + hashName).path
    }
}
