//
//  RecipeListView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Recipes...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else if viewModel.displayedRecipes.isEmpty {
                    Text(viewModel.searchText.isEmpty
                         ? "No recipes available."
                         : "No recipes match “\(viewModel.searchText)”.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    List(viewModel.displayedRecipes) { recipe in
                        RecipeRowView(recipe: recipe)
                            .id(recipe.id)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
            .searchable(text: $viewModel.searchText, prompt: "Search recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sortOption) {
                            ForEach(RecipeListViewModel.SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
            }
            .task { await viewModel.fetchRecipes() }
        }
    }
}
