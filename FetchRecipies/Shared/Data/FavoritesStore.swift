//
//  FavoritesStore.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: Set<UUID>

    private let key = "favoriteRecipeIDs"
    private let defaults = UserDefaults.standard

    init() {
        if let saved = defaults.array(forKey: key) as? [String] {
            self.favorites = Set(saved.compactMap(UUID.init(uuidString:)))
        } else {
            self.favorites = []
        }
    }

    func toggle(_ id: UUID) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        save()
    }

    func isFavorite(_ id: UUID) -> Bool {
        favorites.contains(id)
    }

    private func save() {
        let strings = favorites.map(\.uuidString)
        defaults.set(strings, forKey: key)
    }
}

