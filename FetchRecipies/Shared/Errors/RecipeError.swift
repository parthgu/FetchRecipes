//
//  RecipeError.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

/// Defines possible errors when fetching or decoding recipes.
enum RecipeError: Error {
    /// The URL string was malformed or could not be converted to a valid URL.
    case invalidURL
    
    /// Decoding the JSON response into `Recipe` objects failed.
    case decodingFailed
    
    /// The server returned no data or an empty payload.
    case emptyData
}
