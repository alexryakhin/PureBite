//
//  IngredientFullInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

struct IngredientFullInfo: Identifiable, Hashable {
    struct Property: Hashable {
        let name, unit: String?
        let amount, percentOfDailyNeeds: Double?

        init(name: String?, unit: String?, amount: Double?, percentOfDailyNeeds: Double?) {
            self.name = name
            self.unit = unit
            self.amount = amount
            self.percentOfDailyNeeds = percentOfDailyNeeds
        }
    }

    let id: Int
    let amount: Double
    let imageUrlPath: String?
    let unit: String
    let name: String
    let aisle: String
    let possibleUnits: [String]
    let nutrients: [Property]?
    let properties: [Property]?
    let flavonoids: [Property]?
    let percentProtein: Double?
    let percentCarbs: Double?
    let percentFat: Double?
    let weightPerServing: Property?
    let estimatedCost: Double?
    let estimatedCostUnit: String?

    let recipeID: Int?
    let recipeName: String?

    var imageURL: URL? {
        guard let imageUrlPath else { return nil }
        return ImageHelper.ingredientsImageUrl(for: imageUrlPath)
    }

    var amountFormatted: String {
        "\(amount.formatted()) \(unit)"
    }

    init(
        id: Int,
        amount: Double,
        imageUrlPath: String? = nil,
        unit: String,
        name: String,
        aisle: String,
        possibleUnits: [String],
        nutrients: [Property]? = nil,
        properties: [Property]? = nil,
        flavonoids: [Property]? = nil,
        percentProtein: Double? = nil,
        percentCarbs: Double? = nil,
        percentFat: Double? = nil,
        weightPerServing: Property? = nil,
        estimatedCost: Double? = nil,
        estimatedCostUnit: String? = nil,
        recipeID: Int? = nil,
        recipeName: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.imageUrlPath = imageUrlPath
        self.unit = unit
        self.name = name
        self.aisle = aisle
        self.possibleUnits = possibleUnits
        self.nutrients = nutrients
        self.properties = properties
        self.flavonoids = flavonoids
        self.percentProtein = percentProtein
        self.percentCarbs = percentCarbs
        self.percentFat = percentFat
        self.weightPerServing = weightPerServing
        self.estimatedCost = estimatedCost
        self.estimatedCostUnit = estimatedCostUnit
        self.recipeID = recipeID
        self.recipeName = recipeName
    }
}
