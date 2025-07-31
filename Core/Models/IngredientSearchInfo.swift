//
//  IngredientSearchInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

struct IngredientSearchInfo: Identifiable, Hashable {

    let aisle: String
    let id: Int
    let imageUrlPath: String?
    let name: String
    let possibleUnits: [String]

    var imageURL: URL? {
        guard let imageUrlPath else { return nil }
        return ImageHelper.ingredientsImageUrl(for: imageUrlPath)
    }
    
    var suggestedCategory: ShoppingCategory {
        return ShoppingCategory.fromAisle(aisle)
    }

    init(
        aisle: String,
        id: Int,
        imageUrlPath: String?,
        name: String,
        possibleUnits: [String]?
    ) {
        self.aisle = aisle
        self.id = id
        self.imageUrlPath = imageUrlPath
        self.name = name
        self.possibleUnits = possibleUnits ?? []
    }
}
