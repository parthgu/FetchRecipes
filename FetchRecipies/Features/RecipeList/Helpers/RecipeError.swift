//
//  RecipeError.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import Foundation

enum RecipeError: Error {
    case invalidURL
    case decodingFailed
    case emptyData
}
