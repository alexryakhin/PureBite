//
//  IngredientSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation
import Core

public struct ProductSearchResponse: Codable {
    public struct GroceryProduct: Codable, Identifiable, Equatable {
        public let id: Int
        public let title: String
        public let imageType: String?
    }

    public let products: [GroceryProduct]
    public let totalProducts: Int
    public let offset: Int
    public let number: Int
}

public extension ProductSearchResponse.GroceryProduct {
    var toCoreShortInfo: Core.GroceryProductShortInfo {
        return GroceryProductShortInfo(
            id: id,
            name: title,
            imageExtension: imageType
        )
    }
}
