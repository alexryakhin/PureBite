//
//  PageView.swift
//  Suint One
//
//  Created by Aleksandr Riakhin on 9/30/24.
//

import Foundation
import SwiftUI

public protocol PageView: View {
    associatedtype ContentView: View
    associatedtype LoaderView: View
    associatedtype ErrorView: View
    associatedtype PlaceholderView: View

    associatedtype ViewModel: DefaultPageViewModel

    typealias PageState = AdditionalPageState<DefaultLoaderProps, DefaultPlaceholderProps, DefaultErrorProps>

    var viewModel: ViewModel { get set }

    @ViewBuilder var contentView: ContentView { get }
    @ViewBuilder func loaderView(props: PageState.LoaderProps) -> LoaderView
    @ViewBuilder func placeholderView(props: PageState.PlaceholderProps) -> ErrorView
    @ViewBuilder func errorView(props: PageState.ErrorProps) -> PlaceholderView
}

public extension PageView {
    @ViewBuilder
    var body: some View {
        contentView
            .overlay {
                if let additionalState = viewModel.additionalState {
                    Color.background.ignoresSafeArea()
                    switch additionalState {
                    case .loading(let props):
                        loaderView(props: props)
                    case .error(let props):
                        errorView(props: props)
                    case .placeholder(let props):
                        placeholderView(props: props)
                    }
                }
            }
    }

    @ViewBuilder func loaderView(props: PageState.LoaderProps) -> some View {
        PageLoadingView(props: props)
    }

    @ViewBuilder func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyStateView(title: "There is nothing here")
    }

    @ViewBuilder func errorView(props: PageState.ErrorProps) -> some View {
        PageErrorView(props: props)
    }
}
