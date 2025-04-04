//
//  Ingredient.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public struct IngredientFull: Codable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let original: String
    public let originalName: String
    public let name: String
    public let amount: Double
    public let unit: String
    public let unitShort: String
    public let unitLong: String
    public let possibleUnits: [String]
    public let estimatedCost: EstimatedCost
    public let consistency: String
    public let shoppingListUnits: [String]?
    public let aisle: String
    public let image: String?
    public let meta: [String]
    public let nutrition: Nutrition
    public let categoryPath: [String]

    public var imageURL: URL? {
        guard let image else { return nil }
        return URL(string: "https://img.spoonacular.com/ingredients_500x500/\(image)")
    }

    // Nested structures
    public struct EstimatedCost: Codable, Hashable {
        public let value: Double
        public let unit: String
    }

    public struct Nutrition: Codable, Hashable {
        public let nutrients: [Nutrient]
        public let properties: [Property]
        public let flavonoids: [Flavonoid]
        public let caloricBreakdown: CaloricBreakdown
        public let weightPerServing: WeightPerServing

        public struct Nutrient: Codable, Hashable {
            public let name: String
            public let amount: Double
            public let unit: String
            public let percentOfDailyNeeds: Double
        }

        public struct Property: Codable, Hashable {
            public let name: String
            public let amount: Double
            public let unit: String
        }

        public struct Flavonoid: Codable, Hashable {
            public let name: String
            public let amount: Double
            public let unit: String
        }

        public struct CaloricBreakdown: Codable, Hashable {
            public let percentProtein: Double
            public let percentFat: Double
            public let percentCarbs: Double
        }

        public struct WeightPerServing: Codable, Hashable {
            public let amount: Double
            public let unit: String
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.image == rhs.image
    }
}
