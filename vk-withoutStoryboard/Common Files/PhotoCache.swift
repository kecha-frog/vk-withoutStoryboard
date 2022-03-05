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

    subscript(_ url: URL) -> UIImage? { get set }
}

final class PhotoCache {
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
    func getImage(for url: URL) -> UIImage? {
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return image
        } else {
            return nil
        }
    }

    func saveImage(_ image: UIImage?, for url: URL) {
        guard
            let image = image
        else {
            return deleteImage(for: url)
        }
        imageCache.setObject(image as AnyObject, forKey: url as AnyObject)
    }

    func deleteImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
    }

    func clearCache() {
        imageCache.removeAllObjects()
    }

    subscript(url: URL) -> UIImage? {
        get {
            return getImage(for: url)
        }
        set {
            saveImage(newValue, for: url)
        }
    }
}
