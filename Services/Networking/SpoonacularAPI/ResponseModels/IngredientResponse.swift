//
//  IngredientResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation
import Core

public struct IngredientResponse: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let original, originalName: String? // 'original' and 'originalName' might be the same as 'name' or slightly different based on query
    public let amount: Double? // Default amount from Spoonacular, not necessarily what user wants
    public let unit, unitShort, unitLong: String? // Default unit from Spoonacular
    public let possibleUnits: [String]?
    public let estimatedCost: EstimatedCost?
    public let consistency: String?
    public let aisle, image: String?
    public let nutrition: Nutrition?
    public let categoryPath: [String]?

    public struct EstimatedCost: Codable {
        public let value: Double?
        public let unit: String?
    }

    public struct Nutrition: Codable {
        public let nutrients: [Property]?
        public let properties: [Property]?
        public let flavonoids: [Property]?
        public let caloricBreakdown: CaloricBreakdown?
        public let weightPerServing: Property?

        public struct Property: Codable {
            public let name, unit: String?
            public let amount, percentOfDailyNeeds: Double?
        }

        public struct CaloricBreakdown: Codable {
            public let percentProtein, percentFat, percentCarbs: Double?
        }
    }
}

extension IngredientResponse.Nutrition.Property {
    var coreModel: Core.IngredientFullInfo.Property {
        Core.IngredientFullInfo.Property(
            name: name,
            unit: unit,
            amount: amount,
            percentOfDailyNeeds: percentOfDailyNeeds
        )
    }
}

public extension IngredientResponse {
    var coreModel: Core.IngredientFullInfo {
        Core.IngredientFullInfo(
            id: id,
            amount: amount ?? .zero,
            imageUrlPath: image,
            unit: unit.orEmpty,
            name: name,
            aisle: aisle.orEmpty,
            possibleUnits: possibleUnits ?? [],
            nutrients: nutrition?.nutrients?.map(\.coreModel),
            properties: nutrition?.properties?.map(\.coreModel),
            flavonoids: nutrition?.flavonoids?.map(\.coreModel),
            percentProtein: nutrition?.caloricBreakdown?.percentProtein,
            percentCarbs: nutrition?.caloricBreakdown?.percentCarbs,
            percentFat: nutrition?.caloricBreakdown?.percentFat,
            weightPerServing: nutrition?.weightPerServing?.coreModel,
            estimatedCost: estimatedCost?.value,
            estimatedCostUnit: estimatedCost?.unit,
            recipeID: nil,
            recipeName: nil
        )
    }
}
