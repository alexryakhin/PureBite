//
//  IngredientSearchInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct IngredientSearchInfo: Identifiable, Hashable {

    public let aisle: String
    public let id: Int
    public let imageUrlPath: String?
    public let name: String
    public let possibleUnits: [String]

    public var imageURL: URL? {
        guard let imageUrlPath else { return nil }
        return ImageHelper.ingredientsImageUrl(for: imageUrlPath)
    }

    public init(
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
