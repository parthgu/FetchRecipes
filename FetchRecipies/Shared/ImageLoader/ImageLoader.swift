//
//  ImageLoader.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI
import UIKit

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func load(from url: URL?) {
        guard let url = url else { return }

        Task {
            if let cached = ImageCache.shared.get(forKey: url.absoluteString) {
                image = cached
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let uiImage = UIImage(data: data) else { return }

                ImageCache.shared.set(uiImage, forKey: url.absoluteString)
                image = uiImage
            } catch {
                print("Image load error: \(error)")
            }
        }
    }
}

