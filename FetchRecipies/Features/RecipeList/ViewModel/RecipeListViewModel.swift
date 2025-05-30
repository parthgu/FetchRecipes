//
//  RecipeListViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    enum SortOption: String, CaseIterable, Identifiable {
        case nameAsc = "A–Z"
        case nameDesc = "Z–A"
        case cuisine  = "Cuisine"
        
        var id: Self { self }
    }
    
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .nameAsc
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
//    private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
//    private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    private var normalizedSearchText: String {
        searchText
          .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
      }

    /// Applies search + sort in one pass
    var displayedRecipes: [Recipe] {
        // 1. Filter
        let filtered = recipes.filter { recipe in
            guard !normalizedSearchText.isEmpty else { return true }
            let name = recipe.name
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            let cuisine = recipe.cuisine
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            return name.contains(normalizedSearchText)
                || cuisine.contains(normalizedSearchText)
        }

        // 2. Sort
        switch sortOption {
        case .nameAsc:
            return filtered.sorted { $0.name < $1.name }
        case .nameDesc:
            return filtered.sorted { $0.name > $1.name }
        case .cuisine:
            return filtered.sorted { $0.cuisine < $1.cuisine }
        }
    }

    func fetchRecipes() async {
        isLoading = true

        do {
            recipes = try await APIService.shared.fetchRecipes(from: endpoint)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to load recipes. Try again later."
            recipes = []
        }
    }
}

extension RecipeListViewModel {
    var cuisines: [String] {
        let set = Set(recipes.map(\.cuisine))
        return set.sorted()
    }
}
