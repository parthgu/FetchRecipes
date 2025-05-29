//
//  APIService.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingError
    case requestFailed
}

final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchRecipes(from urlString: String) async throws -> [Recipe] {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decoded.recipes
        } catch {
            throw APIError.decodingError
        }
    }
}
