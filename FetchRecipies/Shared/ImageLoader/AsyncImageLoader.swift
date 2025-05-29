//
//  AsyncImageLoader.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

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
                placeholder
            }
        }
        .onAppear {
            loader.load(from: url)
        }
    }
}

