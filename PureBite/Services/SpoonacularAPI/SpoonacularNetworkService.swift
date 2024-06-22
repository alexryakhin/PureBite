//
//  SpoonacularNetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public protocol SpoonacularNetworkServiceInterface {
    func fetchRecipes(query: String) async throws -> RecipeSearchResponse
    func recipeInformation(id: Int) async throws -> Recipe
}

public final class SpoonacularNetworkService: SpoonacularNetworkServiceInterface {
    private let networkService: NetworkServiceInterface

    public init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }

    public func fetchRecipes(query: String) async throws -> RecipeSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchRecipes(query: query, number: 10)
        return try await networkService.request(endpoint, responseType: RecipeSearchResponse.self)
    }

    public func recipeInformation(id: Int) async throws -> Recipe {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        return try await networkService.request(endpoint, responseType: Recipe.self)
    }
}
