//
//  IngredientSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

struct IngredientSearchResponse: Codable {

    struct Ingredient: Codable, Identifiable, Equatable {
        let id: Int
        let aisle: String?
        let image: String?
        let name: String
        let possibleUnits: [String]
    }

    let results: [Ingredient]
    let totalResults: Int
    let offset: Int
    let number: Int
}

extension IngredientSearchResponse.Ingredient {
    var toCoreIngredient: IngredientSearchInfo {
        return IngredientSearchInfo(
            aisle: aisle.orEmpty,
            id: id,
            imageUrlPath: image,
            name: name,
            possibleUnits: possibleUnits
        )
    }
}
