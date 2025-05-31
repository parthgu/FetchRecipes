//
//  FavoritesViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [Recipe] = []

    private let favoritesStore: FavoritesStore
    private let listVM: RecipeListViewModel

    init(listVM: RecipeListViewModel,
         favoritesStore: FavoritesStore) {
        self.listVM = listVM
        self.favoritesStore = favoritesStore

        // whenever recipes or ids change, recompute
        listVM.$recipes
            .combineLatest(favoritesStore.$ids)
            .map { recipes, ids in
                recipes.filter { ids.contains($0.id) }
            }
            .assign(to: &$favorites)
    }

    func refresh() async {
        await listVM.fetchRecipes()
    }
}

