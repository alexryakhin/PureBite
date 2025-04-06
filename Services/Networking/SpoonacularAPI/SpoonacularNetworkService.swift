//
//  SpoonacularNetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation
import Core

public protocol SpoonacularNetworkServiceInterface {
    nonisolated func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse
    nonisolated func searchIngredients(params: SearchIngredientsParams) async throws -> IngredientSearchResponse
    nonisolated func recipeInformation(id: Int) async throws -> Recipe
    nonisolated func ingredientInformation(params: IngredientInformationParams) async throws -> IngredientFull
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
        let apiKey = try getAPIKey()
        var responseHeaders: [String: String?] = [:]
        let response: RecipeSearchResponse = try await networkService.request(
            for: endpoint,
            apiKey: apiKey,
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
        updateQuotas(from: responseHeaders, apiKey: apiKey)
        return response
    }

    public func searchIngredients(params: SearchIngredientsParams) async throws -> IngredientSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchIngredients(params: params)
        let apiKey = try getAPIKey()
        var responseHeaders: [String: String?] = [:]
        let response: IngredientSearchResponse = try await networkService.request(
            for: endpoint,
            apiKey: apiKey,
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
        updateQuotas(from: responseHeaders, apiKey: apiKey)
        return response
    }

    public func recipeInformation(id: Int) async throws -> Recipe {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        let apiKey = try getAPIKey()
        var responseHeaders: [String: String?] = [:]
        let response: Recipe = try await networkService.request(
            for: endpoint,
            apiKey: apiKey,
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
        updateQuotas(from: responseHeaders, apiKey: apiKey)
        return response
    }

    public nonisolated func ingredientInformation(params: IngredientInformationParams) async throws -> IngredientFull {
        let endpoint = SpoonacularAPIEndpoint.ingredientInformation(params: params)
        let apiKey = try getAPIKey()
        var responseHeaders: [String: String?] = [:]
        let response: IngredientFull = try await networkService.request(
            for: endpoint,
            apiKey: apiKey,
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
        updateQuotas(from: responseHeaders, apiKey: apiKey)
        return response
    }

    private func getAPIKey() throws -> String {
        guard let apiKey = apiKeyManager.getRandomAvailableKey() else {
            throw CoreError.networkError(.missingAPIKey)
        }
        return apiKey.key
    }

    private func updateQuotas(from responseHeaders: [String: String?], apiKey: String) {
        if let quotaLeftStr = responseHeaders["x-api-quota-left"],
           let quotaLeftStr,
           let quotaLeft = Double(quotaLeftStr) {
            apiKeyManager.updateQuota(for: apiKey, quotaLeft: quotaLeft)
        }
    }
}

#if DEBUG
public class SpoonacularNetworkServiceMock: SpoonacularNetworkServiceInterface {
    let networkService = NetworkServiceMock()
    let apiKeyManager = SpoonacularAPIKeyManager()

    public init() {}
    public func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchRecipes(params: params)
        var responseHeaders: [String: String?] = [:]
        return try await networkService.request(
            for: endpoint,
            apiKey: getAPIKey(),
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
    }

    public nonisolated func searchIngredients(params: SearchIngredientsParams) async throws -> IngredientSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchIngredients(params: params)
        var responseHeaders: [String: String?] = [:]
        return try await networkService.request(
            for: endpoint,
            apiKey: getAPIKey(),
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
    }

    public func recipeInformation(id: Int) async throws -> Recipe {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        var responseHeaders: [String: String?] = [:]
        return try await networkService.request(
            for: endpoint,
            apiKey: getAPIKey(),
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
    }

    public nonisolated func ingredientInformation(params: IngredientInformationParams) async throws -> IngredientFull {
        let endpoint = SpoonacularAPIEndpoint.ingredientInformation(params: params)
        var responseHeaders: [String: String?] = [:]
        return try await networkService.request(
            for: endpoint,
            apiKey: getAPIKey(),
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
    }

    private func getAPIKey() throws -> String {
        guard let apiKey = apiKeyManager.getRandomAvailableKey() else {
            throw CoreError.networkError(.missingAPIKey)
        }
        return apiKey.key
    }
}
#endif
