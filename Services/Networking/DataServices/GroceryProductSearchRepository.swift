//
//  GroceryProductSearchRepository.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/1/25.
//
import Foundation
import Combine
import Core

final class GroceryProductSearchRepository: BasePaginatedSearchRepository<GroceryProductShortInfo> {
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
                let response = try await networkService.searchProducts(
                    params: .init(query: query, offset: offset, number: 15)
                )
                let items = response.products.map(\.toCoreShortInfo)
                appendItems(items, totalResults: response.totalProducts)
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
