//
//  IngredientRecipeInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

struct IngredientRecipeInfo: Identifiable, Hashable {

    struct Measures: Hashable, Codable {

        struct Measurement: Hashable, Codable {
            let amount: Double?
            let unitLong: String?
            let unitShort: String?

            init(amount: Double?, unitLong: String?, unitShort: String?) {
                self.amount = amount
                self.unitLong = unitLong
                self.unitShort = unitShort
            }
        }

        let metric: Measurement?
        let us: Measurement?

        init(metric: Measurement?, us: Measurement?) {
            self.metric = metric
            self.us = us
        }
    }

    let aisle: String
    let amount: Double
    let consistency: String?
    let id: Int
    let imageUrlPath: String?
    let measures: Measures?
    let name: String
    let unit: String
    let recipeID: Int
    let recipeName: String

    var imageURL: URL? {
        guard let imageUrlPath else { return nil }
        return ImageHelper.ingredientsImageUrl(for: imageUrlPath)
    }

    var measuresData: Data? {
        try? JSONEncoder().encode(measures)
    }

    init(
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
