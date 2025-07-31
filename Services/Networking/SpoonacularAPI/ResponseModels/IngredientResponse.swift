//
//  IngredientResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

struct IngredientResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let original, originalName: String? // 'original' and 'originalName' might be the same as 'name' or slightly different based on query
    let amount: Double? // Default amount from Spoonacular, not necessarily what user wants
    let unit, unitShort, unitLong: String? // Default unit from Spoonacular
    let possibleUnits: [String]?
    let estimatedCost: EstimatedCost?
    let consistency: String?
    let aisle, image: String?
    let nutrition: Nutrition?
    let categoryPath: [String]?

    struct EstimatedCost: Codable {
        let value: Double?
        let unit: String?
    }

    struct Nutrition: Codable {
        let nutrients: [Property]?
        let properties: [Property]?
        let flavonoids: [Property]?
        let caloricBreakdown: CaloricBreakdown?
        let weightPerServing: Property?

        struct Property: Codable {
            let name, unit: String?
            let amount, percentOfDailyNeeds: Double?
        }

        struct CaloricBreakdown: Codable {
            let percentProtein, percentFat, percentCarbs: Double?
        }
    }
}

extension IngredientResponse.Nutrition.Property {
    var coreModel: IngredientFullInfo.Property {
        IngredientFullInfo.Property(
            name: name,
            unit: unit,
            amount: amount,
            percentOfDailyNeeds: percentOfDailyNeeds
        )
    }
}

extension IngredientResponse {
    var coreModel: IngredientFullInfo {
        IngredientFullInfo(
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
