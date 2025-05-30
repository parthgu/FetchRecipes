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
        Group {
            // 1. Loading skeletons
            if viewModel.isLoading {
                LoadingSkeletonListView()

            // 2. Error state takes precedence
            } else if let error = viewModel.errorMessage {
                ErrorStateView(message: error) {
                    Task { await viewModel.fetchRecipes() }
                }

            // 3. Empty state next
            } else if viewModel.displayedRecipes.isEmpty {
                EmptyStateView(
                    message: viewModel.searchText.isEmpty
                        ? "No recipes available."
                        : "No recipes match “\(viewModel.searchText)”."
                ) {
                    Task { await viewModel.fetchRecipes() }
                }

            // 4. Otherwise show scrollable content with sticky pills
            } else {
                RecipesScrollContentView(viewModel: viewModel)
            }
        }
        .navigationTitle("Recipes")
        .searchable(text: $viewModel.searchText, prompt: "Search recipes")
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

// MARK: - Private Subviews

private struct LoadingSkeletonListView: View {
    var body: some View {
        List(0..<5, id: \.self) { _ in SkeletonRowView() }
            .listStyle(.plain)
    }
}

private struct CuisinePillsView: View {
    let cuisines: [String]
    @Binding var sortOption: RecipeListViewModel.SortOption

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Sort/filter menu as a pill
                Menu {
                    Picker("Sort by", selection: $sortOption) {
                        ForEach(RecipeListViewModel.SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.2))
                        .foregroundColor(.accentColor)
                        .cornerRadius(12)
                }
                
                Divider()
                
                ForEach(cuisines, id: \.self) { cuisine in
                    NavigationLink(
                        destination: CuisineRecipesView(
                            cuisine: cuisine,
                            recipes: cuisines.isEmpty ? [] : []
                        )
                    ) {
                        Text(cuisine)
                            .font(.subheadline).bold()
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.accentColor.opacity(0.2))
                            .foregroundColor(.accentColor)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            .background(Color(UIColor.systemBackground))
        }
    }
}

private struct RecipesScrollContentView: View {
    @ObservedObject var viewModel: RecipeListViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Cuisine pills scroll normally with content
                CuisinePillsView(
                    cuisines: viewModel.cuisines,
                    sortOption: $viewModel.sortOption
                )
//                .padding(.horizontal, -16) // extend to screen edges if needed

                // Recipe cards
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.displayedRecipes) { recipe in
                        RecipeRowView(recipe: recipe)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .refreshable {
            await viewModel.fetchRecipes()
        }
    }
}
