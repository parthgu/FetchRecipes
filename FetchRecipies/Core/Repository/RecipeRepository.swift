//
//  RecipeRepository.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

@MainActor
final class RecipeRepository: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let service: APIService

    init(service: APIService = .shared) {
        self.service = service
    }

    /// Fetches recipes from the network and publishes them
    func fetchRecipes() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let fetched = try await service.fetchRecipes(from: endpoint)
            recipes = fetched
            errorMessage = nil
        } catch {
            recipes = []
            errorMessage = error.localizedDescription
        }
    }
}

