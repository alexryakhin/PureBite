//
//  RecipeSearchResponse.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public struct RecipeSearchResponse: Codable {
    public let results: [Recipe]
    public let totalResults: Int
    public let offset: Int
    public let number: Int
}
