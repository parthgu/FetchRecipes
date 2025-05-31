//
//  RecipeDetailView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

/// Shows detailed information for a single recipe, including image, title, cuisine, action buttons, and favorite toggle.
struct RecipeDetailView: View {
    /// View model that holds and manages the data for this detail view.
    @StateObject private var viewModel: RecipeDetailViewModel
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var favoritesStore: FavoritesStore

    /// Initializes with a Recipe and creates the corresponding view model.
    init(recipe: Recipe) {
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(recipe: recipe))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Large Recipe Image
                AsyncImageLoader(
                    url: viewModel.recipe.photoURLLarge,
                    placeholder:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(4/3, contentMode: .fit)
                )
                .aspectRatio(4/3, contentMode: .fit)
                .cornerRadius(12)

                // MARK: - Title & Cuisine
                HStack(alignment: .top) {
                    Text(viewModel.recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    // Show share button if a source URL is available
                    if let url = viewModel.recipe.sourceURL {
                        ShareLink(item: url) {
                            Image(systemName: AssetNameConstants.share)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 24)
                                .padding(4)
                        }
                    }
                }
                Text(viewModel.recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Divider()

                // MARK: - Action Buttons
                HStack(spacing: 24) {
                    // Open the recipe's web source when tapped
                    if let url = viewModel.recipe.sourceURL {
                        Button(action: { openURL(url) }) {
                            Label(StringConstants.source, systemImage: AssetNameConstants.globe)
                        }
                        .buttonStyle(.bordered)
                    }
                    // Open YouTube video if available
                    if let yt = viewModel.recipe.youtubeURL {
                        Button(action: { openURL(yt) }) {
                            Label(StringConstants.watch, systemImage: AssetNameConstants.playCircle)
                        }
                        .buttonStyle(.bordered)
                    }
                    Spacer()
                    // Favorite/unfavorite toggle for this recipe
                    Button {
                        favoritesStore.toggle(viewModel.recipe.id)
                    } label: {
                        Image(systemName:
                            favoritesStore.contains(viewModel.recipe.id)
                                ? AssetNameConstants.heartFill
                                : AssetNameConstants.heart
                        )
                    }
                    .foregroundStyle(.red)
                    .buttonStyle(.plain)
                }

                Spacer(minLength: 32)
            }
            .padding()
        }
        // Display the recipe name as navigation title
        .navigationTitle(viewModel.recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
