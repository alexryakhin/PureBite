//
//  IngredientSearchRepository.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/1/25.
//
import Foundation
import Combine

final class IngredientSearchRepository: BasePaginatedSearchRepository<IngredientSearchInfo> {

    static let shared = IngredientSearchRepository()

    @MainActor private let networkService = SpoonacularNetworkService.shared

    override private init() {}

    override func search(query: String) {
        guard !query.isEmpty else { return }
        if currentQuery != query {
            reset()
            currentQuery = query
        }

        Task {
            do {
                info("[INGREDIENT_SEARCH] Searching for: '\(query)'")
                fetchStatusPublisher.send(offset == 0 ? .loadingFirstPage : .loadingNextPage)
                let response = try await networkService.searchIngredients(
                    params: .init(query: query, metaInformation: true, offset: offset, number: 15)
                )
                let items = response.results.map(\.toCoreIngredient)
                info("[INGREDIENT_SEARCH] Found \(items.count) results for '\(query)'")
                appendItems(items, totalResults: response.totalResults)
                fetchStatusPublisher.send(items.isEmpty ? .idleNoData : .idle)
            } catch {
                info("[INGREDIENT_SEARCH] Error searching for '\(query)': \(error)")
                fetchStatusPublisher.send(offset == 0 ? .firstPageLoadingError : .nextPageLoadingError)
            }
        }
    }

    override func loadNextPage() {
        guard canLoadNextPage else { return }
        search(query: currentQuery)
    }
}
