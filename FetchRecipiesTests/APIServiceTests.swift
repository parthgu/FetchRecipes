//
//  APIServiceTests.swift
//  FetchRecipiesTests
//
//  Created by Parth Gupta on 5/31/25.
//

import XCTest
@testable import FetchRecipies

final class APIServiceTests: XCTestCase {
    var sut: APIService!
    
    override func setUp() {
        super.setUp()
        sut = APIService.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchRecipes_WithValidURL_ReturnsRecipes() async throws {
        // Given
        let validURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        
        // When
        let recipes = try await sut.fetchRecipes(from: validURL)
        
        // Then
        XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty")
        XCTAssertTrue(recipes.allSatisfy { !$0.name.isEmpty }, "All recipes should have names")
        XCTAssertTrue(recipes.allSatisfy { !$0.cuisine.isEmpty }, "All recipes should have cuisine types")
    }
    
    func testFetchRecipes_WithInvalidURL_ThrowsError() async {
        // Given
        let invalidURL = ""
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes(from: invalidURL)
            XCTFail("Expected error for invalid URL")
        } catch {
            XCTAssertEqual(error as? APIError, .invalidURL)
        }
    }
    
    func testFetchRecipes_WithMalformedData_ThrowsError() async {
        // Given
        let malformedURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes(from: malformedURL)
            XCTFail("Expected error for malformed data")
        } catch {
            XCTAssertEqual(error as? APIError, .decodingError)
        }
    }
    
    func testFetchRecipes_WithEmptyData_ReturnsEmptyArray() async throws {
        // Given
        let emptyURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        
        // When
        let recipes = try await sut.fetchRecipes(from: emptyURL)
        
        // Then
        XCTAssertTrue(recipes.isEmpty, "Recipes array should be empty")
    }
}
