//
//  IngredientSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation
import Core

public struct IngredientSearchResponse: Codable {

    public struct Ingredient: Codable, Identifiable, Equatable {
        public let id: Int
        public let aisle: String?
        public let image: String?
        public let name: String
        public let possibleUnits: [String]
    }

    public let results: [Ingredient]
    public let totalResults: Int
    public let offset: Int
    public let number: Int
}

public extension IngredientSearchResponse.Ingredient {
    var toCoreIngredient: Core.Ingredient {
        return Ingredient(
            id: id,
            amount: 100,
            imageUrlPath: image.orEmpty,
            unit: "g",
            name: name,
            aisle: aisle.orEmpty
        )
    }
}
