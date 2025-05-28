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
    nonisolated func recipeInformation(id: Int) async throws -> RecipeResponse
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
        let apiKey = try await getAPIKey()
        var responseHeaders: [String: String?] = [:]
        let response: RecipeSearchResponse = try await networkService.request(
            for: endpoint,
            apiKey: apiKey,
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
        await updateQuotas(from: responseHeaders, apiKey: apiKey)
        return response
    }

    public func searchIngredients(params: SearchIngredientsParams) async throws -> IngredientSearchResponse {
        let endpoint = SpoonacularAPIEndpoint.searchIngredients(params: params)
        let apiKey = try await getAPIKey()
        var responseHeaders: [String: String?] = [:]
        let response: IngredientSearchResponse = try await networkService.request(
            for: endpoint,
            apiKey: apiKey,
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
        await updateQuotas(from: responseHeaders, apiKey: apiKey)
        return response
    }

    public func recipeInformation(id: Int) async throws -> RecipeResponse {
        let endpoint = SpoonacularAPIEndpoint.recipeInformation(id: id)
        let apiKey = try await getAPIKey()
        var responseHeaders: [String: String?] = [:]
        let response: RecipeResponse = try await networkService.request(
            for: endpoint,
            apiKey: apiKey,
            responseHeaders: &responseHeaders,
            errorType: SpoonacularServerError.self
        )
        await updateQuotas(from: responseHeaders, apiKey: apiKey)
        return response
    }

    private func getAPIKey() async throws -> String {
        guard let apiKey = await apiKeyManager.getRandomAvailableKey() else {
            throw CoreError.networkError(.missingAPIKey)
        }
        return apiKey.key
    }

    private func updateQuotas(from responseHeaders: [String: String?], apiKey: String) async {
        if let quotaLeftStr = responseHeaders["x-api-quota-left"],
           let quotaLeftStr,
           let quotaLeft = Double(quotaLeftStr) {
            await apiKeyManager.updateQuota(for: apiKey, quotaLeft: quotaLeft)
        }
    }
}
