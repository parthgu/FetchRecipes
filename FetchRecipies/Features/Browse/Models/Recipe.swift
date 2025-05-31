//
//  Recipe.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

/// Represents a single recipe with relevant metadata.
/// Conforms to Identifiable for SwiftUI list differentiation,
/// Codable for JSON encoding/decoding, and Equatable for value comparisons.
struct Recipe: Identifiable, Codable, Equatable {
    /// Unique identifier for this recipe.
    let id: UUID
    
    /// Display name of the recipe.
    let name: String
    
    /// Cuisine category (e.g., "Italian", "Mexican").
    let cuisine: String
    
    /// URL to a smaller-sized photo (e.g., thumbnail).
    let photoURLSmall: URL?
    
    /// URL to a larger-sized photo (e.g., full-size).
    let photoURLLarge: URL?
    
    /// Link to the original source (e.g., a blog or website) for the recipe.
    let sourceURL: URL?
    
    /// YouTube link if there is a video demonstration for the recipe.
    let youtubeURL: URL?
    
    /// Maps JSON keys to Swift property names when decoding/encoding.
    enum CodingKeys: String, CodingKey {
        case id = "uuid"                   // JSON field "uuid" maps to `id`
        case name, cuisine                 // JSON fields "name" and "cuisine" match directly
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

/// Represents the top-level response from the API containing an array of recipes.
struct RecipeResponse: Codable {
    /// Array of `Recipe` objects returned by the server.
    let recipes: [Recipe]
}
