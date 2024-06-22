//
//  IngredientSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public struct IngredientSearchResponse: Codable {
    public let id: Int
    public let title: String
    public let image: String
    public let usedIngredientCount: Int
    public let missedIngredientCount: Int
    public let likes: Int
    public let missedIngredients: [Ingredient]
    public let usedIngredients: [Ingredient]
}
