//
//  LazyLoadView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/2/25.
//

import SwiftUI
import Core

public struct LazyLoadView<
    Data: RandomAccessCollection,
    LoadingView: View,
    NextPageLoadingErrorView: View,
    EmptyDataView: View,
    ItemView: View
>: View where Data.Element: Identifiable {

    private let data: Data
    private let fetchStatus: PaginationFetchStatus
    private let usingListWithDivider: Bool
    private let canLoadNextPage: Bool
    private let onLoadNextPage: (() -> Void)?
    private let itemView: (Data.Element) -> ItemView
    private let initialLoadingView: () -> LoadingView
    private let nextPageLoadingErrorView: () -> NextPageLoadingErrorView
    private let emptyDataView: () -> EmptyDataView

    public init(
        _ data: Data,
        fetchStatus: PaginationFetchStatus,
        usingListWithDivider: Bool = true,
        canLoadNextPage: Bool,
        onLoadNextPage: (() -> Void)?,
        @ViewBuilder itemView: @escaping (Data.Element) -> ItemView,
        @ViewBuilder initialLoadingView: @escaping () -> LoadingView = { ProgressView() },
        @ViewBuilder nextPageLoadingErrorView: @escaping () -> NextPageLoadingErrorView,
        @ViewBuilder emptyDataView: @escaping () -> EmptyDataView
    ) {
        self.data = data
        self.fetchStatus = fetchStatus
        self.usingListWithDivider = usingListWithDivider
        self.canLoadNextPage = canLoadNextPage
        self.onLoadNextPage = onLoadNextPage
        self.itemView = itemView
        self.initialLoadingView = initialLoadingView
        self.nextPageLoadingErrorView = nextPageLoadingErrorView
        self.emptyDataView = emptyDataView
    }

    public var body: some View {
        VStack(spacing: 16) {
            switch fetchStatus {
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
    }

    @ViewBuilder
    private var dataView: some View {
        if usingListWithDivider {
            ListWithDivider(data) { dataItem in
                itemView(dataItem)
                    .id(dataItem.id)
                    .onAppear {
                        // Load next page when the last item appears
                        if dataItem.id == data.last?.id, fetchStatus != .loadingNextPage, canLoadNextPage {
                            onLoadNextPage?()
                        }
                    }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            LazyVStack(spacing: 12) {
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
        }
    }

    private var nextPageLoaderView: some View {
        ProgressView()
            .frame(width: 24, height: 24)
            .padding(.vertical, 32)
    }
}
