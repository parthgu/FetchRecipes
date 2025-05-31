//
//  AsyncImageLoader.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Loads and displays an image from a URL asynchronously.
/// Displays `placeholder` until the image finishes loading.
struct AsyncImageLoader<Placeholder: View>: View {
    let url: URL?
    let placeholder: Placeholder

    @StateObject private var loader = ImageLoader()

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                // Show the provided placeholder view while loading
                placeholder
            }
        }
        .onAppear {
            // Start loading the image once this view appears
            loader.load(from: url)
        }
    }
}
