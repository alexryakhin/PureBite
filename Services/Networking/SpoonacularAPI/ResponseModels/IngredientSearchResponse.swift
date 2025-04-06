//
//  IngredientSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

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
