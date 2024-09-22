//
//  Ingredient.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public struct Ingredient: Codable, Hashable {
    public let amount: Double?
    public let id: Int?
    public let name: String?
    public let nutrients: [Nutrient]?
    public let unit: String?

    init(
        amount: Double? = nil,
        id: Int? = nil,
        name: String? = nil,
        nutrients: [Nutrient]? = nil,
        unit: String? = nil
    ) {
        self.amount = amount
        self.id = id
        self.name = name
        self.nutrients = nutrients
        self.unit = unit
    }
}
