//
//  PaginatedSearchRepository.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/1/25.
//

import Foundation
import Combine

protocol PaginatedSearchRepository {
    associatedtype Item

    var itemsPublisher: CurrentValueSubject<[Item], Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }

    func search(query: String)
    func loadNextPage()
}

class BasePaginatedSearchRepository<Item>: PaginatedSearchRepository {
    var itemsPublisher = CurrentValueSubject<[Item], Never>([])
    var errorPublisher = PassthroughSubject<Error, Never>()

    var currentQuery: String = ""
    var offset: Int = 0
    var canLoadMore: Bool = false

    func resetPagination() {
        offset = 0
        canLoadMore = true
        itemsPublisher.send([])
    }

    func appendItems(_ newItems: [Item], totalResults: Int) {
        itemsPublisher.value.append(contentsOf: newItems)
        offset += newItems.count
        canLoadMore = offset < totalResults
    }

    // These methods must be overridden
    func search(query: String) { fatalError("Override required") }
    func loadNextPage() { fatalError("Override required") }
}
