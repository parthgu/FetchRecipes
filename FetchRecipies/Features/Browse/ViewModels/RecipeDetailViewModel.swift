//
//  RecipeDetailViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import Foundation
import SwiftUI

/// ViewModel for a single recipe detail view.
@MainActor
final class RecipeDetailViewModel: ObservableObject {
    /// The recipe being displayed.
    @Published var recipe: Recipe

    /// Initializes with the given recipe.
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
