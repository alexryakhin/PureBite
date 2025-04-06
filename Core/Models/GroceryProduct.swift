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
    public let badges: [GroceryProductBadge]
    public let importantBadges: [GroceryProductBadge]
    public let ingredientCount: Int
    public let ingredientList: String
    public let aisle: String
    public let price: Double
    public let servingsNumber: Int
    public let servingSize: Int
    public let servingUnit: String

    public var imageURL: URL? {
        ImageHelper.productImageUrl(for: id)
    }

    public init(
        id: Int,
        name: String,
        badges: [GroceryProductBadge],
        importantBadges: [GroceryProductBadge],
        ingredientCount: Int,
        ingredientList: String,
        aisle: String,
        price: Double,
        servingsNumber: Int,
        servingSize: Int,
        servingUnit: String
    ) {
        self.id = id
        self.name = name
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
