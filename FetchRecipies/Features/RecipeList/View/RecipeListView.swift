//
//  RecipeListView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeListViewModel

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    // 1. Loading skeletons
                    if viewModel.isLoading {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonRowView()
                                .frame(width: proxy.size.width, height: 80)
                        }

                    // 2. Error centered
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            // fill the scrollview so it centers vertically
                            .frame(width: proxy.size.width,
                                   height: proxy.size.height)
                    
                    // 3. Empty centered
                    } else if viewModel.displayedRecipes.isEmpty {
                        Text(viewModel.searchText.isEmpty
                             ? "No recipes available."
                             : "No recipes match “\(viewModel.searchText)”.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(width: proxy.size.width,
                                   height: proxy.size.height)

                    // 4. Actual rows
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.displayedRecipes) { recipe in
                                RecipeRowView(recipe: recipe)
                                    .id(recipe.id)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .frame(width: proxy.size.width)
            }
            .refreshable {
                await viewModel.fetchRecipes()
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
