//
//  RecipeRowView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Displays a single recipe row with an image, title, cuisine, and a favorite button.
struct RecipeRowView: View {
    let recipe: Recipe
    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        HStack {
            // Load recipe thumbnail asynchronously; show gray box while loading
            AsyncImageLoader(
                url: recipe.photoURLSmall,
                placeholder: Rectangle().fill(Color.gray.opacity(0.5))
            )
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Favorite/unfavorite toggle
            Button {
                favoritesStore.toggle(recipe.id)
            } label: {
                Image(systemName:
                    favoritesStore.contains(recipe.id)
                        ? AssetNameConstants.heartFill
                        : AssetNameConstants.heart
                )
            }
            .foregroundStyle(.red)
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
