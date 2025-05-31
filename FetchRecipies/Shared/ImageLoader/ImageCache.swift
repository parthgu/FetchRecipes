//
//  ImageCache.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Manages in-memory and on-disk caching of downloaded images.
/// Singleton instance for shared access across the app.
final class ImageCache {
    static let shared = ImageCache()

    /// In-memory cache using `NSCache` for fast image retrieval.
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private let fileManager = FileManager.default
    
    /// Directory URL on disk where cached images are stored.
    private lazy var diskCacheURL: URL = {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDir.appendingPathComponent("ImageCache", isDirectory: true)
    }()

    private init() {
        // Create the disk cache directory if it doesn't exist.
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    /// Retrieves an image for the given key, checking memory first, then disk.
    /// - Parameter key: A string identifying the image (e.g., URL.absoluteString).
    /// - Returns: The cached `UIImage` or `nil` if not found.
    func get(forKey key: String) -> UIImage? {
        // 1. Check in-memory cache
        if let memoryImage = memoryCache.object(forKey: key as NSString) {
            return memoryImage
        }

        // 2. Check on-disk cache
        let fileURL = diskCacheURL.appendingPathComponent(key.toValidFilename())
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            // Store in memory cache for future accesses
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }

        // Not in cache
        return nil
    }

    /// Stores an image in both memory and disk caches.
    /// - Parameters:
    ///   - image: The `UIImage` to cache.
    ///   - key: A string key under which to store the image.
    func set(_ image: UIImage, forKey key: String) {
        // 1. Store in-memory
        memoryCache.setObject(image, forKey: key as NSString)

        // 2. Store on disk as JPEG data
        let fileURL = diskCacheURL.appendingPathComponent(key.toValidFilename())
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        try? data.write(to: fileURL)
    }
    
    /// Clears all cached images from both memory and disk.
    func clearCache() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: diskCacheURL)
    }
}
