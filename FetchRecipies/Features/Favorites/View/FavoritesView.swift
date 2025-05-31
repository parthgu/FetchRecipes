//
//  FavoritesView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

struct FavoritesListView: View {
    @StateObject var viewModel: FavoritesViewModel

    var body: some View {
        ZStack {
            // Scrollable list of favorite recipes
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
                await viewModel.refresh()
            }

            // Overlay shown when there are no favorites
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
