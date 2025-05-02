//
//  IngredientSearchRepository.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/1/25.
//
import Foundation
import Combine
import Core

public final class IngredientSearchRepository: BasePaginatedSearchRepository<Ingredient> {
    private let networkService: SpoonacularNetworkServiceInterface

    public init(networkService: SpoonacularNetworkServiceInterface) {
        self.networkService = networkService
    }

    override public func search(query: String) {
        guard !query.isEmpty else { return }
        if currentQuery != query {
            reset()
            currentQuery = query
        }

        Task {
            do {
                fetchStatusPublisher.send(offset == 0 ? .loadingFirstPage : .loadingNextPage)
                let response = try await networkService.searchIngredients(
                    params: .init(query: query, metaInformation: true, offset: offset, number: 15)
                )
                let items = response.results.map(\.toCoreIngredient)
                appendItems(items, totalResults: response.totalResults)
                fetchStatusPublisher.send(items.isEmpty ? .idleNoData : .idle)
            } catch {
                fetchStatusPublisher.send(offset == 0 ? .firstPageLoadingError : .nextPageLoadingError)
            }
        }
    }

    override public func loadNextPage() {
        guard canLoadNextPage else { return }
        search(query: currentQuery)
    }
}
