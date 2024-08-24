//
//  SpoonacularNetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public protocol SpoonacularNetworkServiceInterface {
    func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse
    func recipeInformation(id: Int) async throws -> Recipe
}

public final class SpoonacularNetworkService: SpoonacularNetworkServiceInterface {
    private let networkService: NetworkServiceInterface

    public init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }

    public func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchRecipes(params: params)
        return try await networkService.request(endpoint, responseType: RecipeSearchResponse.self)
    }

    public func recipeInformation(id: Int) async throws -> Recipe {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        return try await networkService.request(endpoint, responseType: Recipe.self)
    }
}

public struct SpoonacularNetworkServiceMock: SpoonacularNetworkServiceInterface {
    let networkService = NetworkServiceMock()

    public func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchRecipes(params: params)
        return try await networkService.request(endpoint, responseType: RecipeSearchResponse.self)
    }
    
    public func recipeInformation(id: Int) async throws -> Recipe {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        return try await networkService.request(endpoint, responseType: Recipe.self)
    }
}
