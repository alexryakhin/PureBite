//
//  SpoonacularNetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

@MainActor
final class SpoonacularNetworkService: ObservableObject {
    static let shared = SpoonacularNetworkService()
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let networkService: NetworkService
    private let apiKeyManager: SpoonacularAPIKeyManager
    
    private init() {
        self.networkService = NetworkService.shared
        self.apiKeyManager = SpoonacularAPIKeyManager.shared
    }
    
    func searchRecipes(params: SearchRecipesParams) async throws -> RecipeSearchResponse {
        isLoading = true
        error = nil
        
        do {
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
            isLoading = false
            return response
        } catch {
            isLoading = false
            self.error = error
            throw error
        }
    }

    func searchIngredients(params: SearchIngredientsParams) async throws -> IngredientSearchResponse {
        isLoading = true
        error = nil
        
        do {
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
            isLoading = false
            return response
        } catch {
            isLoading = false
            self.error = error
            throw error
        }
    }

    func recipeInformation(id: Int) async throws -> RecipeResponse {
        isLoading = true
        error = nil
        
        do {
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
            isLoading = false
            return response
        } catch {
            isLoading = false
            self.error = error
            throw error
        }
    }
    
    func similarRecipes(id: Int) async throws -> [RecipeShortInfo] {
        isLoading = true
        error = nil
        
        do {
            let endpoint = SpoonacularAPIEndpoint.getSimilarRecipes(id: id)
            let apiKey = try await getAPIKey()
            var responseHeaders: [String: String?] = [:]
            let response: [SimilarRecipeResponse] = try await networkService.request(
                for: endpoint,
                apiKey: apiKey,
                responseHeaders: &responseHeaders,
                errorType: SpoonacularServerError.self
            )
            await updateQuotas(from: responseHeaders, apiKey: apiKey)
            isLoading = false
            return response.map { $0.recipeShortInfo }
        } catch {
            isLoading = false
            self.error = error
            throw error
        }
    }
    
    private func getAPIKey() async throws -> String {
        return try await apiKeyManager.getAPIKey()
    }
    
    private func updateQuotas(from headers: [String: String?], apiKey: String) async {
        await apiKeyManager.updateQuotas(from: headers, apiKey: apiKey)
    }
}
