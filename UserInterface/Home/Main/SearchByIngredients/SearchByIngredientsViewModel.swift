//
//  SearchByIngredientsViewModel.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class SearchByIngredientsViewModel: SwiftUIBaseViewModel {

    enum Input {
        case search
        case addIngredient(String)
        case removeIngredient(String)
        case clearIngredients
    }

    @Published var ingredients: [String] = []
    @Published var searchResults: [RecipeByIngredientsResponse] = []
    @Published var hasSearched: Bool = false
    
    // MARK: - Private Properties

    private let spoonacularNetworkService: SpoonacularNetworkService
    private var cancellables = Set<AnyCancellable>()

    override init() {
        self.spoonacularNetworkService = SpoonacularNetworkService.shared
        super.init()
    }

    func handle(_ input: Input) {
        switch input {
        case .search:
            searchRecipes()
        case .addIngredient(let ingredient):
            addIngredient(ingredient)
        case .removeIngredient(let ingredient):
            removeIngredient(ingredient)
        case .clearIngredients:
            clearIngredients()
        }
    }

    // MARK: - Private Methods

    private func addIngredient(_ ingredient: String) {
        let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedIngredient.isEmpty && !ingredients.contains(trimmedIngredient) {
            ingredients.append(trimmedIngredient)
        }
    }

    private func removeIngredient(_ ingredient: String) {
        ingredients.removeAll { $0 == ingredient }
    }

    private func clearIngredients() {
        ingredients.removeAll()
        searchResults.removeAll()
        hasSearched = false
    }

    private func searchRecipes() {
        guard !ingredients.isEmpty else { return }
        
        hasSearched = true
        
        Task {
            setLoading(true)
            defer {
                setLoading(false)
            }
            
            do {
                let params = SearchByIngredientsParams(
                    ingredients: ingredients,
                    number: 20,
                    ranking: 1, // Maximize used ingredients
                    ignorePantry: true
                )
                
                let response = try await spoonacularNetworkService.searchByIngredients(params: params)
                searchResults = response
            } catch {
                handleError(error)
            }
        }
    }
} 
