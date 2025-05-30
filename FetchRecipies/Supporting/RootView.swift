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
            NavigationStack {
                RecipeListView(viewModel: listVM)
            }
            .tabItem { Label(StringConstants.TabNames.browse, systemImage: AssetNameConstants.book) }

            NavigationStack {
                FavoritesListView(
                  viewModel: FavoritesViewModel(
                    listVM: listVM,
                    favoritesStore: favorites
                  )
                )
            }
            .tabItem { Label(StringConstants.TabNames.favorites, systemImage: AssetNameConstants.heartFill) }
        }
        .environmentObject(favorites)
    }
}

