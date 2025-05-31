//
//  RecipeListViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    /// Sorting options for recipe list.
    enum SortOption: String, CaseIterable, Identifiable {
        case nameAsc = "A–Z"
        case nameDesc = "Z–A"
        
        var id: Self { self }
    }
    
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .nameAsc
    @Published var errorMessage: String?
    @Published var isLoading = true
    
    init() {
        Task {
            await fetchRecipes()
        }
    }

    // NOTE: To test invalid or empty inputs, uncomment out the desired endpoint

    // All recipies:
    private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    // Malformed Data:
    // private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"

    // Empty Data:
    // private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    // Normalize search text to ignore diacritics and case.
    private var normalizedSearchText: String {
        searchText
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    }

    /// Returns recipes filtered by search text and sorted per the selected option.
    var displayedRecipes: [Recipe] {
        // FILTER: only include if name or cuisine contains search text
        let filtered = recipes.filter { recipe in
            guard !normalizedSearchText.isEmpty else { return true }
            let name = recipe.name
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            let cuisine = recipe.cuisine
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            return name.contains(normalizedSearchText) || cuisine.contains(normalizedSearchText)
        }

        // SORT: ascending or descending by name
        switch sortOption {
        case .nameAsc:
            return filtered.sorted { $0.name < $1.name }
        case .nameDesc:
            return filtered.sorted { $0.name > $1.name }
        }
    }

    /// Fetches recipes from the server, updating `recipes` or setting an error message.
    func fetchRecipes() async {
        errorMessage = nil
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
    /// All unique cuisine names, sorted alphabetically.
    var cuisines: [String] {
        Set(recipes.map(\.cuisine))
            .sorted()
    }
}
