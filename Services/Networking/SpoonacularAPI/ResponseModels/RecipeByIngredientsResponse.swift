//
//  RecipeByIngredientsResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import Foundation

struct RecipeByIngredientsResponse: Codable {
    let id: Int
    let image: String?
    let imageType: String?
    let likes: Int?
    let missedIngredientCount: Int
    let missedIngredients: [IngredientInfo]
    let title: String
    let unusedIngredients: [IngredientInfo]
    let usedIngredientCount: Int
    let usedIngredients: [IngredientInfo]
    
    var recipeShortInfo: RecipeShortInfo {
        RecipeShortInfo(
            id: id,
            title: title,
            imageUrl: image.flatMap { URL(string: $0) },
            score: nil,
            readyInMinutes: nil,
            likes: likes
        )
    }
}

struct IngredientInfo: Codable, Identifiable {
    let aisle: String?
    let amount: Double?
    let extendedName: String?
    let id: Int
    let image: String?
    let meta: [String]?
    let name: String
    let original: String?
    let originalName: String?
    let unit: String?
    let unitLong: String?
    let unitShort: String?
    
    var imageUrl: URL? {
        image.flatMap { URL(string: $0) }
    }
} 