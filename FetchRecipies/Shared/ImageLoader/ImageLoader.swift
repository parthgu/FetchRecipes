//
//  ImageLoader.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Loads an image asynchronously from a URL, using `ImageCache` to avoid redundant network calls.
@MainActor
final class ImageLoader: ObservableObject {
    /// Publishes the loaded UIImage (or nil if still loading or failed).
    @Published var image: UIImage?

    /// Begins loading the image from the given URL.
    /// - Parameter url: The URL of the image to load; if nil, loading is skipped.
    func load(from url: URL?) {
        guard let url = url else { return }

        Task {
            // 1. Check in-memory/disk cache first
            if let cached = ImageCache.shared.get(forKey: url.absoluteString) {
                image = cached
                return
            }

            do {
                // 2. Fetch image data from network
                let (data, _) = try await URLSession.shared.data(from: url)
                // 3. Convert data to UIImage
                guard let uiImage = UIImage(data: data) else { return }

                // 4. Cache the downloaded image for future use
                ImageCache.shared.set(uiImage, forKey: url.absoluteString)
                // 5. Publish the image so UI can update
                image = uiImage
            } catch {
                // Log any errors during fetch
                print("Image load error: \(error)")
            }
        }
    }
}
