//
//  IngredientRecipeInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct IngredientRecipeInfo: Identifiable, Hashable {

    public struct Measures: Hashable, Codable {

        public struct Measurement: Hashable, Codable {
            public let amount: Double?
            public let unitLong: String?
            public let unitShort: String?

            public init(amount: Double?, unitLong: String?, unitShort: String?) {
                self.amount = amount
                self.unitLong = unitLong
                self.unitShort = unitShort
            }
        }

        public let metric: Measurement?
        public let us: Measurement?

        public init(metric: Measurement?, us: Measurement?) {
            self.metric = metric
            self.us = us
        }
    }

    public let aisle: String
    public let amount: Double
    public let consistency: String?
    public let id: Int
    public let imageUrlPath: String?
    public let measures: Measures?
    public let name: String
    public let unit: String
    public let recipeID: Int
    public let recipeName: String

    public var imageURL: URL? {
        guard let imageUrlPath else { return nil }
        return ImageHelper.ingredientsImageUrl(for: imageUrlPath)
    }

    public var measuresData: Data? {
        try? JSONEncoder().encode(measures)
    }

    public init(
        aisle: String,
        amount: Double,
        consistency: String?,
        id: Int,
        imageUrlPath: String?,
        measures: Measures?,
        name: String,
        unit: String,
        recipeID: Int,
        recipeName: String
    ) {
        self.aisle = aisle
        self.amount = amount
        self.consistency = consistency
        self.id = id
        self.imageUrlPath = imageUrlPath
        self.measures = measures
        self.name = name
        self.unit = unit
        self.recipeID = recipeID
        self.recipeName = recipeName
    }
}
