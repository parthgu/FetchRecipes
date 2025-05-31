//
//  APIService.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

/// Errors that can occur during API calls.
enum APIError: Error {
    /// The provided URL string was invalid.
    case invalidURL
    /// Failed to decode the JSON response.
    case decodingError
    /// The network request itself failed.
    case requestFailed
}

/// Provides methods to fetch data from the remote recipes endpoint.
final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    /// Fetches recipes from the given URL string.
    /// - Parameter urlString: The string representation of the endpoint URL.
    /// - Returns: An array of `Recipe` objects on success.
    /// - Throws: `APIError.invalidURL` if URL creation fails,
    ///           `APIError.decodingError` if JSON decoding fails,
    ///           or propagates network errors.
    func fetchRecipes(from urlString: String) async throws -> [Recipe] {
        // Ensure the URL string can be converted to a valid URL.
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        // Perform network request to download the data.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            // Decode the JSON into a RecipeResponse and return the recipes array.
            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decoded.recipes
        } catch {
            // If decoding fails, throw a decoding-specific error.
            throw APIError.decodingError
        }
    }
}
