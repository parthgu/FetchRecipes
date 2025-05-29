//
//  FavoritesListView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        List {
            ForEach(viewModel.recipes.filter { favorites.isFavorite($0.id) }) { recipe in
                RecipeRowView(recipe: recipe)
                    .environmentObject(favorites)
                    .id(recipe.id)
            }
        }
        .navigationTitle("Favorites")
        .refreshable { await viewModel.fetchRecipes() }
        .overlay {
            if viewModel.recipes.filter({ favorites.isFavorite($0.id) }).isEmpty {
                Text("No favorites yet.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .task { await viewModel.fetchRecipes() }
    }
}
