//
//  ImageCache.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

final class ImageCache {
    static let shared = ImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private lazy var diskCacheURL: URL = {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDir.appendingPathComponent("ImageCache", isDirectory: true)
    }()

    private init() {
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    func get(forKey key: String) -> UIImage? {
        if let memoryImage = memoryCache.object(forKey: key as NSString) {
            return memoryImage
        }

        let fileURL = diskCacheURL.appendingPathComponent(key.toValidFilename())
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }

        return nil
    }

    func set(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)

        let fileURL = diskCacheURL.appendingPathComponent(key.toValidFilename())
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }

        try? data.write(to: fileURL)
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: diskCacheURL)
    }
}


