//
//  FavoritesStore.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

/// Manages the set of favorite recipe IDs and persists them to UserDefaults.
@MainActor
final class FavoritesStore: ObservableObject {
    /// Current set of favorite recipe UUIDs.
    @Published private(set) var ids: Set<UUID>

    private let key = "favoriteRecipeIDs"
    private let defaults = UserDefaults.standard

    init() {
        // Load saved favorite IDs from UserDefaults, or start with an empty set.
        if let arr = defaults.stringArray(forKey: key) {
            self.ids = Set(arr.compactMap(UUID.init))
        } else {
            self.ids = []
        }
    }

    /// Toggles the presence of a recipe ID in favorites and updates persistence.
    func toggle(_ id: UUID) {
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        // Save updated set of IDs as an array of strings.
        defaults.set(ids.map(\.uuidString), forKey: key)
    }
    
    /// Adds the given ID to favorites if not already present, then persists.
    func add(_ id: UUID) {
        guard !ids.contains(id) else { return }
        ids.insert(id)
        defaults.set(ids.map(\.uuidString), forKey: key)
    }
    
    /// Removes the given ID from favorites if present, then persists.
    func remove(_ id: UUID) {
        guard ids.contains(id) else { return }
        ids.remove(id)
        defaults.set(ids.map(\.uuidString), forKey: key)
    }

    /// Checks whether a given recipe ID is currently favorited.
    func contains(_ id: UUID) -> Bool {
        ids.contains(id)
    }
    
    /// Clears all favorites and removes the stored key from UserDefaults.
    func clearFavorites() {
        ids.removeAll()
        defaults.removeObject(forKey: key)
    }
}
