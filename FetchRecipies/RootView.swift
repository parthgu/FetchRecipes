//
//  RootView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import SwiftUI

/// The main entry point for the app, setting up a tab-based interface
/// and injecting shared dependencies (e.g., favorites store).
struct RootView: View {
    @StateObject private var listVM = RecipeListViewModel()
    @StateObject private var favorites = FavoritesStore()

    var body: some View {
        TabView {
            // MARK: - Browse Tab
            Tab(StringConstants.TabNames.browse, systemImage: AssetNameConstants.book) {
                NavigationStack {
                    RecipeListView(viewModel: listVM)
                }
            }
            
            // MARK: - Favorites Tab
            Tab(StringConstants.TabNames.favorites, systemImage: AssetNameConstants.heartFill) {
                NavigationStack {
                    // Pass the list VM and favorites store into FavoritesViewModel
                    FavoritesListView(
                        viewModel: FavoritesViewModel(
                            listVM: listVM,
                            favoritesStore: favorites
                        )
                    )
                }
            }
            
            // MARK: - Discover Tab (Swipeable Cards)
            Tab(StringConstants.TabNames.discover, systemImage: AssetNameConstants.bookPages) {
                NavigationStack {
                    // Show swipeable card stack based on the full recipe list
                    CardStackView(recipes: listVM.recipes)
                }
            }
        }
        // Provide the FavoritesStore to all child views via environment
        .environmentObject(favorites)
    }
}
