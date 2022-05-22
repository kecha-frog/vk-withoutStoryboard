//
//  PhotoFileCacheLayer.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.03.2022.
//

import UIKit

// MARK: - Protocol
protocol PhotoFileCacheLayerProtocol {
    var images: [String: UIImage] { get set }

    func saveImage(url: URL, dataImage: Data)
    func getImage(for url: URL) -> UIImage?
}

extension PhotoFileCacheLayerProtocol {
    // MARK: - Private Properties
    fileprivate var pathName: String {
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
    }

    // MARK: - Private Methods
    fileprivate var cacheLifeTime: TimeInterval {
        30 * 24 * 60 * 60
    }

    fileprivate func getFilePath(url: URL) -> String? {
        guard let cachesDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask).first
        else { return nil }
        let hashName = url.absoluteString.split(separator: "?").first?.split(separator: "/").last ?? "default"

        return cachesDirectory.appendingPathComponent(self.pathName + "/" + hashName).path
    }
}

class PhotoFileCacheLayer: PhotoFileCacheLayerProtocol {
    // MARK: - Public Properties
   internal var images = [String: UIImage]()

    // MARK: - Public Methods
    func saveImage(url: URL, dataImage: Data) {
        guard let fileName = getFilePath(url: url) else { return }
        FileManager.default.createFile(atPath: fileName, contents: dataImage, attributes: nil)
    }

    func getImage(for url: URL) -> UIImage? {
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
}
