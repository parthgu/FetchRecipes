//
//  FavoritesView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Displays the user's favorite recipes. Shows a list when there are favorites,
/// otherwise overlays a “No favorites yet” message.
struct FavoritesListView: View {
    @StateObject var viewModel: FavoritesViewModel

    var body: some View {
        ZStack {
            // List of favorite recipe cards
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.favorites) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                                .cardStyle()
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
            .refreshable {
                // Refresh the favorites in case they’ve changed elsewhere
                await viewModel.refresh()
            }

            // If no favorites, show a centered placeholder message
            if viewModel.favorites.isEmpty {
                VStack {
                    Spacer()
                    Text("No favorites yet.")
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
