//
//  RecipeSearchRepository.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/1/25.
//
import Foundation
import Combine

final class RecipeSearchRepository: BasePaginatedSearchRepository<RecipeShortInfo> {
    private let networkService: SpoonacularNetworkService

    var filters: RecipeSearchFilters = .init()

    override init() {
        self.networkService = SpoonacularNetworkService.shared
    }

    override func search(query: String) {
        guard !query.isEmpty else { return }
        if currentQuery != query || currentFiltersHashValue != filters.hashValue {
            reset()
            currentQuery = query
            currentFiltersHashValue = filters.hashValue
        }

        Task {
            do {
                fetchStatusPublisher.send(offset == 0 ? .loadingFirstPage : .loadingNextPage)
                let response = try await networkService.searchRecipes(
                    params: buildParams(query: query)
                )
                let items = response.results.map(\.recipeShortInfo)
                appendItems(items, totalResults: response.totalResults)
                fetchStatusPublisher.send(items.isEmpty ? .idleNoData : .idle)
            } catch {
                fetchStatusPublisher.send(offset == 0 ? .firstPageLoadingError : .nextPageLoadingError)
            }
        }
    }

    override func loadNextPage() {
        guard canLoadNextPage else { return }
        search(query: currentQuery)
    }

    private func buildParams(query: String) -> SearchRecipesParams {
        return SearchRecipesParams(
            query: query,
            cuisines: Array(filters.selectedCuisines),
            diet: Array(filters.selectedDiets),
            type: filters.mealType,
            maxReadyTime: Int(filters.maxReadyTime),
            sort: filters.sortBy,
            minCarbs: filters.minCarbs,
            maxCarbs: filters.maxCarbs,
            minProtein: filters.minProtein,
            maxProtein: filters.maxProtein,
            minCalories: filters.minCalories,
            maxCalories: filters.maxCalories,
            minFat: filters.minFat,
            maxFat: filters.maxFat,
            offset: offset,
            number: 15
        )
    }
}
