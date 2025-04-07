//
//  RecipeShortInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

public struct RecipeShortInfo: Identifiable, Hashable {
    public let id: Int
    public let title: String

    public var imageURL: URL? {
        ImageHelper.recipeImageUrl(for: id)
    }

    public init(
        id: Int,
        title: String
    ) {
        self.id = id
        self.title = title
    }
}

extension RecipeShortInfo {
    public static let mock = RecipeShortInfo(
        id: 660405,
        title: "Smoky Black Bean Soup With Sweet Potato & Kale"
    )
}
