//
//  LazyListLoadView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/2/25.
//

import SwiftUI

struct LazyListLoadView<
    Data: RandomAccessCollection,
    InitialView: View,
    LoadingView: View,
    NextPageLoadingErrorView: View,
    EmptyDataView: View,
    ItemView: View
>: View where Data.Element: Identifiable {

    private let data: Data
    private let fetchStatus: PaginationFetchStatus
    private let canLoadNextPage: Bool
    private let onLoadNextPage: (() -> Void)?
    private let itemView: (Data.Element) -> ItemView
    private let initialView: () -> InitialView
    private let initialLoadingView: () -> LoadingView
    private let nextPageLoadingErrorView: () -> NextPageLoadingErrorView
    private let emptyDataView: () -> EmptyDataView

    init(
        _ data: Data,
        fetchStatus: PaginationFetchStatus,
        canLoadNextPage: Bool,
        onLoadNextPage: (() -> Void)?,
        @ViewBuilder itemView: @escaping (Data.Element) -> ItemView,
        @ViewBuilder initialView: @escaping () -> InitialView,
        @ViewBuilder initialLoadingView: @escaping () -> LoadingView = { ProgressView() },
        @ViewBuilder nextPageLoadingErrorView: @escaping () -> NextPageLoadingErrorView,
        @ViewBuilder emptyDataView: @escaping () -> EmptyDataView
    ) {
        self.data = data
        self.fetchStatus = fetchStatus
        self.canLoadNextPage = canLoadNextPage
        self.onLoadNextPage = onLoadNextPage
        self.itemView = itemView
        self.initialView = initialView
        self.initialLoadingView = initialLoadingView
        self.nextPageLoadingErrorView = nextPageLoadingErrorView
        self.emptyDataView = emptyDataView
    }

    @ViewBuilder
    var body: some View {
        switch fetchStatus {
        case .initial:
            initialView()
        case .loadingFirstPage:
            initialLoadingView()
        case .idleNoData:
            emptyDataView()
        default:
            dataView
            switch fetchStatus {
            case .loadingNextPage:
                nextPageLoaderView
            case .nextPageLoadingError:
                nextPageLoadingErrorView()
            default:
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private var dataView: some View {
        ForEach(Array(data.enumerated()), id: \.offset) { index, item in
            let lastIndex = data.count - 1
            itemView(item)
                .id(index)
                .onAppear {
                    // Load next page when the last item appears
                    if index == lastIndex, fetchStatus != .loadingNextPage, canLoadNextPage {
                        onLoadNextPage?()
                    }
                }
        }
    }

    private var nextPageLoaderView: some View {
        ProgressView()
            .frame(width: 24, height: 24)
            .padding(.vertical, 32)
    }
}
