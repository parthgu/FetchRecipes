//
//  RecipeDetailViewModel.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/30/25.
//

import Foundation
import SwiftUI

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
