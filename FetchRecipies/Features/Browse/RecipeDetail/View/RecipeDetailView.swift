//
//  RecipeDetailView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject private var viewModel: RecipeDetailViewModel
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var favoritesStore: FavoritesStore

    init(recipe: Recipe) {
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(recipe: recipe))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 1. Large Recipe Image
                AsyncImageLoader(
                    url: viewModel.recipe.photoURLLarge,
                    placeholder:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(4/3, contentMode: .fit)
                )
                .aspectRatio(4/3, contentMode: .fit)
                .cornerRadius(12)

                // 2. Title & Cuisine
                HStack(alignment: .top) {
                    Text(viewModel.recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
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

                // 3. Action Buttons
                HStack(spacing: 24) {
                    if let url = viewModel.recipe.sourceURL {
                        Button(action: { openURL(url) }) {
                            Label(StringConstants.source, systemImage: AssetNameConstants.globe)
                        }
                        .buttonStyle(.bordered)
                    }
                    if let yt = viewModel.recipe.youtubeURL {
                        Button(action: { openURL(yt) }) {
                            Label(StringConstants.watch, systemImage: AssetNameConstants.playCircle)
                        }
                        .buttonStyle(.bordered)
                    }
                    Spacer()
                    
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
        .navigationTitle(viewModel.recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
