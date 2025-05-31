//
//  FavoritesViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    /// The list of recipes marked as favorites, updated whenever the master list or favorite IDs change.
    @Published private(set) var favorites: [Recipe] = []

    private let favoritesStore: FavoritesStore
    private let listVM: RecipeListViewModel

    /// Initializes with the main recipe list view model and the favorites store.
    /// Sets up a publisher to automatically update `favorites` when either the full recipe list
    /// or the set of favorite IDs changes.
    init(listVM: RecipeListViewModel,
         favoritesStore: FavoritesStore) {
        self.listVM = listVM
        self.favoritesStore = favoritesStore

        // Combine the published recipes array and the set of favorite IDs.
        // Whenever either changes, filter the full recipe list to only those whose IDs are in `favoritesStore.ids`.
        listVM.$recipes
            .combineLatest(favoritesStore.$ids)
            .map { recipes, ids in
                recipes.filter { ids.contains($0.id) }
            }
            .assign(to: &$favorites)
    }

    /// Re-fetches recipes from the server to ensure the favorites list is up to date.
    func refresh() async {
        await listVM.fetchRecipes()
    }
}
