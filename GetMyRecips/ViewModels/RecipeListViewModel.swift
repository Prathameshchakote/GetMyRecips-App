//
//  RecipeListViewModel.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var error: String?
    @Published var isLoading = false
    @Published var searchText = ""
    
    private var allRecipes: [Recipe] = []
    
    var filteredRecipes: [Recipe] {
        guard !searchText.isEmpty else { return allRecipes }
        return allRecipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func loadRecipes() async {
        isLoading = true
        error = nil
        do {
            allRecipes = try await self.networkService.fetchRecipes("https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")

            recipes = allRecipes
        } catch {
            allRecipes = []
            recipes = []
            self.error = "Failed to load recipes. Please try again."
        }
        
        isLoading = false
    }
    
    func updateSearchResults() {
        recipes = filteredRecipes
    }
}
