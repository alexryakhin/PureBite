//
//  IngredientSearchRepository.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/1/25.
//
import Foundation
import Combine
import Core

final class IngredientSearchRepository: BasePaginatedSearchRepository<Ingredient> {
    private let networkService: SpoonacularNetworkServiceInterface

    init(networkService: SpoonacularNetworkServiceInterface) {
        self.networkService = networkService
    }

    override func search(query: String) {
        guard !query.isEmpty else { return }
        currentQuery = query
        resetPagination()

        Task {
            do {
                let response = try await networkService.searchIngredients(
                    params: .init(query: query, metaInformation: true, offset: offset, number: 15)
                )
                let items = response.results.map(\.toCoreIngredient)
                appendItems(items, totalResults: response.totalResults)
            } catch {
                errorPublisher.send(error)
            }
        }
    }

    override func loadNextPage() {
        guard canLoadMore else { return }
        search(query: currentQuery)
    }
}
