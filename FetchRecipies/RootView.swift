//
//  RootView.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

// Supporting/RootView.swift

import SwiftUI

struct RootView: View {
    @StateObject private var listVM = RecipeListViewModel()
    @StateObject private var favorites = FavoritesStore()

    var body: some View {
        TabView {
            Tab(StringConstants.TabNames.browse, systemImage: AssetNameConstants.book) {
                NavigationStack {
                    RecipeListView(viewModel: listVM)
                }
            }
            
            Tab(StringConstants.TabNames.favorites, systemImage: AssetNameConstants.heartFill) {
                NavigationStack {
                    FavoritesListView(
                      viewModel: FavoritesViewModel(
                        listVM: listVM,
                        favoritesStore: favorites
                      )
                    )
                }
            }
            
            Tab(StringConstants.TabNames.discover, systemImage: AssetNameConstants.bookPages) {
                NavigationStack {
                    CardStackView(recipes: listVM.recipes)
                }
            }
        }
        .environmentObject(favorites)
    }
}

