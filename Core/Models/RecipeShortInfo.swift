//
//  RecipeShortInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

struct RecipeShortInfo: Identifiable, Hashable {
    let id: Int
    let title: String

    var imageURL: URL? {
        ImageHelper.recipeImageUrl(for: id)
    }

    init(
        id: Int,
        title: String
    ) {
        self.id = id
        self.title = title
    }
}

extension RecipeShortInfo {
    static let mock = RecipeShortInfo(
        id: 660405,
        title: "Smoky Black Bean Soup With Sweet Potato & Kale"
    )
}
