//
//  RecipeListView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// Displays a list of recipes with search, sorting, and filtering functionality.
/// Shows different states (loading, error, empty) before rendering the main content.
struct RecipeListView: View {
    /// View model driving the recipe list data and state.
    @ObservedObject var viewModel: RecipeListViewModel
    
    /// Controls whether the search field is currently active.
    @State private var isSearchActive = false
    
    /// Tracks the vertical scroll offset to conditionally show the search button.
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        Group {
            // 1. Show loading skeletons while data is fetching
            if viewModel.isLoading {
                LoadingSkeletonListView()
                
                // 2. If there's an error, show error view with retry button
            } else if let error = viewModel.errorMessage {
                ErrorStateView(
                    message: error,
                    subtitle: StringConstants.errorSubtitle
                ) {
                    // Retry fetching recipes when the button is tapped
                    Task { await viewModel.fetchRecipes() }
                }
                
                // 3. If no recipes match (either initial or filtered), show empty state
            } else if viewModel.displayedRecipes.isEmpty {
                EmptyStateView(
                    message: viewModel.searchText.isEmpty
                    ? StringConstants.emptyDefault // No search text: default empty message
                    : String(format: StringConstants.emptyFiltered, viewModel.searchText) // Filtered empty message
                ) {
                    // Retry fetching recipes when the button is tapped
                    Task { await viewModel.fetchRecipes() }
                }
                
                // 4. Otherwise, render the main scrollable content (pills bar + recipe cards)
            } else {
                mainContent
            }
        }
        .navigationTitle(StringConstants.recipesTitle)
        // Attach searchable modifier for filtering recipes by name
        .searchable(
            text: $viewModel.searchText,
            isPresented: $isSearchActive,
            prompt: StringConstants.searchPlaceholder
        )
        // Toolbar contains a search icon when user has scrolled down a bit
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Show search button only after scrolling past 10 points
                if scrollOffset > 10 {
                    Button {
                        isSearchActive = true
                    } label: {
                        Image(systemName: AssetNameConstants.search)
                    }
                }
            }
        }
    }
    
    // MARK: - Pills Bar (Sort + Cuisine Filters)
    
    /// A horizontal bar of "pills" (buttons) for sorting and filtering by cuisine.
    @ViewBuilder
    private var pillsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // 1. Sort/filter menu displayed as a pill with an icon
                Menu {
                    // Picker for selecting sort option from the view model
                    Picker(StringConstants.sortBy, selection: $viewModel.sortOption) {
                        ForEach(RecipeListViewModel.SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                } label: {
                    Image(systemName: AssetNameConstants.sortFilter)
                        .pillStyle(h: 16) // Custom pill styling with height 16
                }
                
                Divider() // Separator between sort pill and cuisine pills
                
                // 2. Render one pill per cuisine category
                ForEach(viewModel.cuisines, id: \.self) { cuisine in
                    // Filter recipes for this cuisine to pass into the destination view
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
    
    // MARK: - Main Content (ScrollView of Pills + Recipe Cards)
    
    /// Main scrollable content that includes the pills bar and a grid of recipe cards.
    @ViewBuilder
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Top row: pills for sorting and cuisine filters
                pillsBar
                
                // Recipe cards displayed in a vertical stack
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.displayedRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                                .cardStyle()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onScrollGeometryChange(
            for: CGFloat.self,
            of: { geo in
                // Convert geometry info to actual scroll offset (accounting for top inset)
                geo.contentOffset.y + geo.contentInsets.top
            },
            action: { _, new in
                // Update state so the toolbar search button can react to scrolling
                scrollOffset = new
            }
        )
        // Enable pull-to-refresh to refetch recipes
        .refreshable {
            Task {
                await viewModel.fetchRecipes()
            }
        }
    }
}

// MARK: - Private Subviews

/// A placeholder list showing skeleton rows while data is loading.
private struct LoadingSkeletonListView: View {
    var body: some View {
        List(0..<5, id: \.self) { _ in
            SkeletonRowView() // Each row is a skeleton representation of a recipe card
        }
        .listStyle(.plain)
    }
}
