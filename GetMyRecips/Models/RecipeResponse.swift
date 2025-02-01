//
//  RecipeResponse.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

extension RecipeResponse {
    static var sampleRecipeResponse: Self = {
        try! JSONDecoder().decode(RecipeResponse.self, from: Recipe.sampleJson)
    }()
}
