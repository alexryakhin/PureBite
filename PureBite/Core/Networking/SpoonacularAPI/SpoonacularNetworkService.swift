//
//  SpoonacularNetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public protocol SpoonacularNetworkServiceInterface {
    nonisolated func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse
    nonisolated func recipeInformation(id: Int) async throws -> Recipe
}

public final class SpoonacularNetworkService: SpoonacularNetworkServiceInterface {
    private let networkService: NetworkServiceInterface
    private let apiKeyManager: SpoonacularAPIKeyManagerInterface

    public init(
        networkService: NetworkServiceInterface,
        apiKeyManager: SpoonacularAPIKeyManagerInterface
    ) {
        self.networkService = networkService
        self.apiKeyManager = apiKeyManager
    }

    public func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchRecipes(params: params)
        return try await networkService.request(for: endpoint, apiKey: getAPIKey(), errorType: SpoonacularServerError.self)
    }

    public func recipeInformation(id: Int) async throws -> Recipe {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        return try await networkService.request(for: endpoint, apiKey: getAPIKey(), errorType: SpoonacularServerError.self)
    }

    private func getAPIKey() throws -> String {
        guard let apiKey = apiKeyManager.getCurrentAPIKey() else {
            throw CoreError.networkError(.missingAPIKey)
        }
        return apiKey
    }
}

#if DEBUG
public class SpoonacularNetworkServiceMock: SpoonacularNetworkServiceInterface {
    let networkService = NetworkServiceMock()
    let apiKeyManager = SpoonacularAPIKeyManager(apiKeys: ["MOCK_API_KEY"])

    public init() {}
    public func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchRecipes(params: params)
        return try await networkService.request(for: endpoint, apiKey: getAPIKey(), errorType: SpoonacularServerError.self)
    }
    
    public func recipeInformation(id: Int) async throws -> Recipe {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        return try await networkService.request(for: endpoint, apiKey: getAPIKey(), errorType: SpoonacularServerError.self)
    }

    private func getAPIKey() throws -> String {
        guard let apiKey = apiKeyManager.getCurrentAPIKey() else {
            throw CoreError.networkError(.missingAPIKey)
        }
        return apiKey
    }
}
#endif
