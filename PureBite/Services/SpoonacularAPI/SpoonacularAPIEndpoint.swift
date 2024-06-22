//
//  SpoonacularAPIEndpoint.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

enum SpoonacularAPIEndpoint: APIEndpoint {
    case searchRecipes(query: String, number: Int)
    case recipeInformation(id: Int)

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spoonacular.com"
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: Constants.spoonacularApiKey)
        ]

        switch self {
        case .searchRecipes(let query, let number):
            components.path = "/recipes/complexSearch"
            components.queryItems?.append(contentsOf: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "number", value: String(number))
            ])
        case .recipeInformation(let id):
            components.path = "/recipes/\(id)/information"
            components.queryItems?.append(contentsOf: [
                URLQueryItem(name: "includeNutrition", value: "true")
            ])
        }

        return components.url
    }

    #if DEBUG
    var mockFileName: String {
        switch self {
        case .searchRecipes:
            return "searchRecipes"
        case .recipeInformation:
            return "recipeInformation"
        }
    }
    #endif
}
