//
//  PaginationFetchStatus.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/27/25.
//

public enum PaginationFetchStatus {
    case loadingFirstPage
    case loadingNextPage
    case nextPageLoadingError
    case firstPageLoadingError
    case initial
    case idle
    case idleNoData
}
