//
//  RecipeListViewModelTests.swift
//  FetchRecipiesTests
//
//  Created by Parth Gupta on 5/31/25.
//

import XCTest
@testable import FetchRecipies

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    var sut: RecipeListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = RecipeListViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertTrue(sut.searchText.isEmpty)
        XCTAssertEqual(sut.sortOption, .nameAsc)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.isLoading)
    }
    
    func testDisplayedRecipes_WithEmptySearch_ShowsAllRecipes() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Sushi", cuisine: "Japanese", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        sut.recipes = recipes
        
        // When
        let displayed = sut.displayedRecipes
        
        // Then
        XCTAssertEqual(displayed.count, recipes.count)
    }
    
    func testDisplayedRecipes_WithSearch_FiltersRecipes() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Sushi", cuisine: "Japanese", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        sut.recipes = recipes
        sut.searchText = "Pizza"
        
        // When
        let displayed = sut.displayedRecipes
        
        // Then
        XCTAssertEqual(displayed.count, 1)
        XCTAssertEqual(displayed.first?.name, "Pizza")
    }
    
    func testDisplayedRecipes_WithSearchByCuisine_FiltersRecipes() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Pasta", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Sushi", cuisine: "Japanese", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        sut.recipes = recipes
        sut.searchText = "Italian"
        
        // When
        let displayed = sut.displayedRecipes
        
        // Then
        XCTAssertEqual(displayed.count, 2)
        XCTAssertTrue(displayed.allSatisfy { $0.cuisine == "Italian" })
    }
    
    func testDisplayedRecipes_WithSortOptionNameAsc_SortsCorrectly() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        sut.recipes = recipes
        sut.sortOption = .nameAsc
        
        // When
        let displayed = sut.displayedRecipes
        
        // Then
        XCTAssertEqual(displayed[0].name, "Apple Pie")
        XCTAssertEqual(displayed[1].name, "Pizza")
    }
    
    func testDisplayedRecipes_WithSortOptionNameDesc_SortsCorrectly() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        sut.recipes = recipes
        sut.sortOption = .nameDesc
        
        // When
        let displayed = sut.displayedRecipes
        
        // Then
        XCTAssertEqual(displayed[0].name, "Pizza")
        XCTAssertEqual(displayed[1].name, "Apple Pie")
    }
    
    func testFetchRecipes_OnSuccess_UpdatesState() async throws {
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertFalse(sut.recipes.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testCuisines_ReturnsUniqueSortedCuisines() {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Pasta", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Sushi", cuisine: "Japanese", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        sut.recipes = recipes
        
        // When
        let cuisines = sut.cuisines
        
        // Then
        XCTAssertEqual(cuisines, ["Italian", "Japanese"])
    }
}
