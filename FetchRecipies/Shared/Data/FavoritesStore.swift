//
//  FavoritesStore.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var ids: Set<UUID>

    private let key = "favoriteRecipeIDs"
    private let defaults = UserDefaults.standard

    init() {
        if let arr = defaults.stringArray(forKey: key) {
            self.ids = Set(arr.compactMap(UUID.init))
        } else {
            self.ids = []
        }
    }

    func toggle(_ id: UUID) {
        if ids.contains(id) { ids.remove(id) }
        else { ids.insert(id) }
        defaults.set(ids.map(\.uuidString), forKey: key)
    }
    
    func add(_ id: UUID) {
        if ids.contains(id) { return }
        else { ids.insert(id) }
        defaults.set(ids.map(\.uuidString), forKey: key)
    }
    
    func remove(_ id: UUID) {
        if !ids.contains(id) { return }
        else { ids.remove(id) }
        defaults.set(ids.map(\.uuidString), forKey: key)
    }

    func contains(_ id: UUID) -> Bool {
        ids.contains(id)
    }
}

