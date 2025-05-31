//
//  FavoritesStoreTests.swift
//  FetchRecipiesTests
//
//  Created by Parth Gupta on 5/31/25.
//

import XCTest
@testable import FetchRecipies

@MainActor
final class FavoritesStoreTests: XCTestCase {
    var sut: FavoritesStore!
    var testRecipe: Recipe!
    
    override func setUp() {
        super.setUp()
        sut = FavoritesStore()
        testRecipe = Recipe(
            id: UUID(),
            name: "Test Recipe",
            cuisine: "Test Cuisine",
            photoURLSmall: nil,
            photoURLLarge: nil,
            sourceURL: nil,
            youtubeURL: nil
        )
    }
    
    override func tearDown() {
        sut = nil
        testRecipe = nil
        super.tearDown()
    }
    
    func testToggle_WhenRecipeNotFavorited_AddsToFavorites() {
        // Given
        XCTAssertFalse(sut.contains(testRecipe.id))
        
        // When
        sut.toggle(testRecipe.id)
        
        // Then
        XCTAssertTrue(sut.contains(testRecipe.id))
    }
    
    func testToggle_WhenRecipeIsFavorited_RemovesFromFavorites() {
        // Given
        sut.toggle(testRecipe.id) // Add first
        XCTAssertTrue(sut.contains(testRecipe.id))
        
        // When
        sut.toggle(testRecipe.id) // Remove
        
        // Then
        XCTAssertFalse(sut.contains(testRecipe.id))
    }
    
    func testContains_WithNonexistentRecipe_ReturnsFalse() {
        // Given
        let nonexistentId = UUID()
        
        // When/Then
        XCTAssertFalse(sut.contains(nonexistentId))
    }
    
    func testPersistence_SavesAndLoadsCorrectly() {
        // Given
        sut.toggle(testRecipe.id)
        
        // When
        let newStore = FavoritesStore() // This should load from persistence
        
        // Then
        XCTAssertTrue(newStore.contains(testRecipe.id))
    }
    
    func testClearFavorites_RemovesAllFavorites() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Recipe 1", cuisine: "Cuisine 1", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Recipe 2", cuisine: "Cuisine 2", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        
        recipes.forEach { sut.toggle($0.id) }
        XCTAssertTrue(recipes.allSatisfy { sut.contains($0.id) })
        
        // When
        sut.clearFavorites()
        
        // Then
        XCTAssertTrue(recipes.allSatisfy { !sut.contains($0.id) })
    }
    
    func testToggleMultiple_MaintainsCorrectState() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Recipe 1", cuisine: "Cuisine 1", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Recipe 2", cuisine: "Cuisine 2", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        
        // When
        recipes.forEach { sut.toggle($0.id) }
        sut.toggle(recipes[0].id) // Toggle first recipe off
        
        // Then
        XCTAssertFalse(sut.contains(recipes[0].id))
        XCTAssertTrue(sut.contains(recipes[1].id))
    }
}
