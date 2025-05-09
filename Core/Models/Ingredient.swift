//
//  Ingredient.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct Ingredient: Identifiable, Hashable {
    public let id: Int
    public let amount: Double
    public let imageUrlPath: String?
    public let unit: String
    public let name: String
    public let aisle: String

    public var imageURL: URL? {
        guard let imageUrlPath else { return nil }
        return ImageHelper.ingredientsImageUrl(for: imageUrlPath)
    }

    public init(
        id: Int,
        amount: Double,
        imageUrlPath: String?,
        unit: String,
        name: String,
        aisle: String
    ) {
        self.id = id
        self.amount = amount
        self.imageUrlPath = imageUrlPath
        self.unit = unit
        self.name = name
        self.aisle = aisle
    }
}
