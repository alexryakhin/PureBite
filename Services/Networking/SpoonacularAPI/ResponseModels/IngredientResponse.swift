//
//  IngredientResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation
import Core

public struct IngredientResponse: Codable {
    let id: Int
    let original: String
    let originalName: String
    let name: String
    let amount: Double
    let unit: String
    let unitShort: String
    let unitLong: String
    let possibleUnits: [String]
    let estimatedCost: EstimatedCost
    let aisle: String
    let image: String?
    let nutrition: Nutrition

    public struct EstimatedCost: Codable {
        let value: Double
        let unit: String
    }

    public struct Nutrition: Codable {
        let nutrients: [Nutrient]
        let properties: [Property]
        let caloricBreakdown: CaloricBreakdown
        let weightPerServing: WeightPerServing

        public struct Nutrient: Codable {
            let name: String
            let amount: Double
            let unit: String
            let percentOfDailyNeeds: Double
        }

        public struct Property: Codable {
            let name: String
            let amount: Double
            let unit: String
        }

        public struct CaloricBreakdown: Codable {
            let percentProtein: Double
            let percentFat: Double
            let percentCarbs: Double
        }

        public struct WeightPerServing: Codable {
            let amount: Double
            let unit: String
        }
    }
}

public extension IngredientResponse {
    var coreModel: Core.Ingredient {
        Core.Ingredient(
            id: id,
            amount: amount,
            imageUrlPath: image.orEmpty,
            unit: unit,
            name: name,
            aisle: aisle
        )
    }
}
