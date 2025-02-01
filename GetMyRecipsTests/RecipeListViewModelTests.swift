//
//  RecipeListViewModelTests.swift
//  GetMyRecipsTests
//
//  Created by Prathamesh on 2/3/25.
//

import XCTest
@testable import GetMyRecips

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    fileprivate var viewModel: RecipeListViewModel!
    fileprivate var mockNetworkService: MockNetworkService!
    
    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = RecipeListViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    @MainActor
    func testInitialState() {
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.searchText.isEmpty)
    }
    
    // MARK: - Loading Tests
    
    @MainActor
    func testSuccessfulRecipeLoading() async {
        // Given
        let sampleRecipe = Recipe.sampleRecipe
        mockNetworkService.mockRecipes = [sampleRecipe]
        mockNetworkService.shouldSucceed = true
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.uuid, sampleRecipe.uuid)
    }
    
    @MainActor
    func testFailedRecipeLoading() async {
        // Given
        mockNetworkService.shouldSucceed = false
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.error, "Failed to load recipes. Please try again.")
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
    
    // MARK: - Search Tests
    
    @MainActor
    func testSearchFunctionality() async {
        // Given
        let recipe1 = Recipe.sampleRecipe
        let recipe2 = try! JSONDecoder().decode(RecipeResponse.self, from: Recipe.sampleJson).recipes[1]
        mockNetworkService.mockRecipes = [recipe1, recipe2]
        await viewModel.loadRecipes()
        
        // When - Search by name
        viewModel.searchText = "Apple"
        viewModel.updateSearchResults()
        
        // Then
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertTrue(viewModel.recipes.contains { $0.name.contains("Apple") })
        
        // When - Search by cuisine
        viewModel.searchText = "British"
        viewModel.updateSearchResults()
        
        // Then
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertTrue(viewModel.recipes.contains { $0.cuisine == "British" })
        
        // When - Search with no matches
        viewModel.searchText = "NonexistentRecipe"
        viewModel.updateSearchResults()
        
        // Then
        XCTAssertTrue(viewModel.recipes.isEmpty)
        
        // When - Clear search
        viewModel.searchText = ""
        viewModel.updateSearchResults()
        
        // Then
        XCTAssertEqual(viewModel.recipes.count, 2)
    }
    
    // MARK: - Filter Tests
    
    @MainActor
    func testFilteredRecipesCaseInsensitive() async {
        // Given

        let recipes = [
            Recipe(uuid: "1", name: "Pasta", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil),
            Recipe(uuid: "2", name: "Sushi", cuisine: "Japanese", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)
        ]
        mockNetworkService.mockRecipes = recipes
        await viewModel.loadRecipes()
        
        // When - Search with mixed case
        viewModel.searchText = "pas"
        viewModel.updateSearchResults()
        
        // Then
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertTrue(viewModel.recipes.contains { $0.name.lowercased().contains("pasta") })
    }
    
}
