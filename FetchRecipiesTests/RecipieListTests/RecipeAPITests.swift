//
//  RecipeAPITests.swift
//  FetchRecipies
//
//  Created by Parth Gupta on 5/29/25.
//

import XCTest
@testable import FetchRecipies

final class RecipeAPITests: XCTestCase {
    func testFetchRecipesSuccess() async throws {
        let recipes = try await APIService.shared.fetchRecipes(
            from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        )
        XCTAssertFalse(recipes.isEmpty)
    }

    func testMalformedDataHandling() async {
        do {
            _ = try await APIService.shared.fetchRecipes(
                from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
            )
            XCTFail("Expected decoding to fail.")
        } catch {
            XCTAssertTrue(true)
        }
    }
}

