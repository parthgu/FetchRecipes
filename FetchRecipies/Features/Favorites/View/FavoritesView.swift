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
        List(viewModel.favorites) { recipe in
            RecipeRowView(recipe: recipe)
        }
        .navigationTitle("Favorites")
        .refreshable { await viewModel.refresh() }
        .overlay {
            if viewModel.favorites.isEmpty {
                Text("No favorites yet.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

