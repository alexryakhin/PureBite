//
//  RecipeSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public struct RecipeSearchResponse: Codable {

    public struct Recipe: Codable {
        public let id: Int
        public let title: String
    }

    public let results: [Recipe]
    public let totalResults: Int
    public let offset: Int
    public let number: Int
}

public extension RecipeSearchResponse.Recipe {
    var recipeShortInfo: RecipeShortInfo {
        RecipeShortInfo(id: id, title: title)
    }
}
