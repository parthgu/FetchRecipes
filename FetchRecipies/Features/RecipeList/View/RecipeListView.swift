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
                ErrorStateView(message: error, subtitle: StringConstants.errorSubtitle) {
                    Task { await viewModel.fetchRecipes() }
                }

            // 3. Empty state next
            } else if viewModel.displayedRecipes.isEmpty {
                EmptyStateView(
                    message: viewModel.searchText.isEmpty
                    ? StringConstants.emptyDefault
                        : String(format: StringConstants.emptyFiltered, viewModel.searchText)
                ) {
                    Task { await viewModel.fetchRecipes() }
                }

            // 4. Otherwise show scrollable content with sticky pills
            } else {
                mainContent
            }
        }
        .navigationTitle(StringConstants.recipesTitle)
        .searchable(text: $viewModel.searchText, prompt: StringConstants.searchPlaceholder)
        .task {
            await viewModel.fetchRecipes()
        }
    }
    
    @ViewBuilder
    private var pillsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Sort/filter menu as a pill
                Menu {
                    Picker(StringConstants.sortBy, selection: $viewModel.sortOption) {
                        ForEach(RecipeListViewModel.SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                } label: {
                    Image(systemName: AssetNameConstants.sortFilter)
                        .pillStyle(h: 16)
                }
                
                Divider()
                
                ForEach(viewModel.cuisines, id: \.self) { cuisine in
                    let filtered = viewModel.recipes.filter { $0.cuisine == cuisine }
                    
                    NavigationLink(
                        destination: CuisineRecipesView(
                            cuisine: cuisine,
                            recipes: filtered
                        )
                    ) {
                        Text(cuisine)
                            .pillStyle()
                    }
                }
            }
            .padding(.horizontal)
            .background(Color(UIColor.systemBackground))
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                pillsBar

                // Recipe cards
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.displayedRecipes) { recipe in
                        RecipeRowView(recipe: recipe)
                            .cardStyle()
                    }
                }
                .padding(.horizontal)
            }
        }
        .refreshable {
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
