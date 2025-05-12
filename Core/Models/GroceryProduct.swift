//
//  GroceryProduct.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct GroceryProduct: Identifiable, Hashable {

    public let id: Int
    public let name: String
    public let imageExtension: String?
    public let badges: [GroceryProductBadge]
    public let importantBadges: [GroceryProductBadge]
    public let ingredientCount: Double
    public let ingredientList: String
    public let aisle: String
    public let price: Double
    public let servingsNumber: Double
    public let servingSize: Double
    public let servingUnit: String

    public var imageURL: URL? {
        ImageHelper.productImageUrl(
            for: id,
            imageExtension: imageExtension
        )
    }

    public init(
        id: Int,
        name: String,
        imageExtension: String?,
        badges: [GroceryProductBadge],
        importantBadges: [GroceryProductBadge],
        ingredientCount: Double,
        ingredientList: String,
        aisle: String,
        price: Double,
        servingsNumber: Double,
        servingSize: Double,
        servingUnit: String
    ) {
        self.id = id
        self.name = name
        self.imageExtension = imageExtension
        self.badges = badges
        self.importantBadges = importantBadges
        self.ingredientCount = ingredientCount
        self.ingredientList = ingredientList
        self.aisle = aisle
        self.price = price
        self.servingsNumber = servingsNumber
        self.servingSize = servingSize
        self.servingUnit = servingUnit
    }
}
