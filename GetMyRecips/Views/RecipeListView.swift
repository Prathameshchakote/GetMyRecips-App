//
//  RecipeListView.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var isSearching: Bool {
        return !viewModel.searchText.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.error != nil {
                    VStack {
                        ContentUnavailableView {
                            Button("Try Again") {
                                Task {
                                    await viewModel.loadRecipes()
                                }
                            }
                        }
                        Spacer()
                    }
                } else if viewModel.recipes.isEmpty && viewModel.searchText.isEmpty {
                    ContentUnavailableView(
                        "No recipes available",
                        systemImage: "nosign",
                        description: Text("Try after some time")
                    )
                } else {
                    recipeList
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.loadRecipes()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onChange(of: viewModel.searchText) {
                viewModel.updateSearchResults()
            }
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
    
    private var recipeList: some View {
        List {
            ForEach(viewModel.recipes) {  recipe in
                RecipeCardView(recipe: recipe)
            }
        }
        .listRowSeparator(.hidden, edges: .all)
        .listStyle(.plain)
        .searchable(
            text: $viewModel.searchText,
            prompt: "What are you craving for?"
        )
        .onChange(of: viewModel.searchText) {
            viewModel.updateSearchResults()
        }
        .refreshable {
            await viewModel.loadRecipes()
        }
        .overlay {
            if viewModel.recipes.isEmpty {
                ContentUnavailableView(
                    "Product not available",
                    systemImage: "magnifyingglass",
                    description: Text("No results for **\(viewModel.searchText)**")
                )
            }
        }
        
    }
}

#Preview {
    RecipeListView()
}
