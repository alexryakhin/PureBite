//
//  PaginatedSearchRepository.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/1/25.
//

import Foundation
import Combine
import Core

public protocol PaginatedSearchRepository {
    associatedtype Item

    var itemsPublisher: CurrentValueSubject<[Item], Never> { get }
    var fetchStatusPublisher: CurrentValueSubject<PaginationFetchStatus, Never> { get }
    var canLoadNextPage: Bool { get }
    var totalResults: Int { get }

    func search(query: String)
    func loadNextPage()
    func reset()
}

open class BasePaginatedSearchRepository<Item>: PaginatedSearchRepository {
    public var itemsPublisher = CurrentValueSubject<[Item], Never>([])
    public var fetchStatusPublisher = CurrentValueSubject<PaginationFetchStatus, Never>(.initial)

    public var canLoadNextPage: Bool = false
    public var totalResults: Int = .zero

    var currentQuery: String = ""
    var currentFiltersHashValue: Int = 0
    var offset: Int = 0

    func appendItems(_ newItems: [Item], totalResults: Int) {
        itemsPublisher.value.append(contentsOf: newItems)
        offset += newItems.count
        canLoadNextPage = offset < totalResults
        if self.totalResults != totalResults {
            self.totalResults = totalResults
        }
    }

    // These methods must be overridden
    open func search(query: String) { fatalError("Override required") }
    open func loadNextPage() { fatalError("Override required") }
    open func reset() {
        offset = 0
        totalResults = 0
        canLoadNextPage = true
        itemsPublisher.send([])
        fetchStatusPublisher.send(.initial)
    }
}
