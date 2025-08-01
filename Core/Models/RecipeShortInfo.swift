//
//  RecipeShortInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

struct RecipeShortInfo: Identifiable, Hashable, Codable {
    let id: Int
    let title: String
    let imageUrl: URL?
    let score: Double?
    let readyInMinutes: Double?
    let likes: Int?

    init(
        id: Int,
        title: String,
        imageUrl: URL? = nil,
        score: Double? = nil,
        readyInMinutes: Double? = nil,
        likes: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.score = score
        self.readyInMinutes = readyInMinutes
        self.likes = likes
    }

    var imageUrlPath: String? {
        imageUrl?.absoluteString
    }
}

// MARK: - Optimized for Core Data Storage

struct RecipeShortInfoCoreData: Codable {
    let id: Int
    let title: String
    let imageUrl: String?
    let score: Double?
    let readyInMinutes: Double?
    let likes: Int?
    
    init(from recipeShortInfo: RecipeShortInfo) {
        self.id = recipeShortInfo.id
        self.title = recipeShortInfo.title
        self.imageUrl = recipeShortInfo.imageUrl?.absoluteString
        self.score = recipeShortInfo.score
        self.readyInMinutes = recipeShortInfo.readyInMinutes
        self.likes = recipeShortInfo.likes
    }
    
    func toRecipeShortInfo() -> RecipeShortInfo {
        RecipeShortInfo(
            id: id,
            title: title,
            imageUrl: imageUrl.flatMap { URL(string: $0) },
            score: score,
            readyInMinutes: readyInMinutes,
            likes: likes
        )
    }
}
