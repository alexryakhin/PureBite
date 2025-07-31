//
//  RecipeSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

struct RecipeSearchResponse: Codable {

    struct Recipe: Codable {
        let id: Int
        let title: String
    }

    let results: [Recipe]
    let totalResults: Int
    let offset: Int
    let number: Int
}

extension RecipeSearchResponse.Recipe {
    var recipeShortInfo: RecipeShortInfo {
        RecipeShortInfo(id: id, title: title)
    }
}
