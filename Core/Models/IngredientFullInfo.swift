//
//  IngredientFullInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct IngredientFullInfo: Identifiable, Hashable {
    public struct Property: Hashable {
        public let name, unit: String?
        public let amount, percentOfDailyNeeds: Double?

        public init(name: String?, unit: String?, amount: Double?, percentOfDailyNeeds: Double?) {
            self.name = name
            self.unit = unit
            self.amount = amount
            self.percentOfDailyNeeds = percentOfDailyNeeds
        }
    }

    public let id: Int
    public let amount: Double
    public let imageUrlPath: String?
    public let unit: String
    public let name: String
    public let aisle: String
    public let possibleUnits: [String]
    public let nutrients: [Property]?
    public let properties: [Property]?
    public let flavonoids: [Property]?
    public let percentProtein: Double?
    public let percentCarbs: Double?
    public let percentFat: Double?
    public let weightPerServing: Property?
    public let estimatedCost: Double?
    public let estimatedCostUnit: String?

    public let recipeID: Int?
    public let recipeName: String?

    public var imageURL: URL? {
        guard let imageUrlPath else { return nil }
        return ImageHelper.ingredientsImageUrl(for: imageUrlPath)
    }

    public var amountFormatted: String {
        "\(amount.formatted()) \(unit)"
    }

    public init(
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
