//
//  WidgetView.swift
//  Suint One
//
//  Created by Aleksandr Riakhin on 9/30/24.
//

import Foundation
import SwiftUI

public protocol WidgetView: View {
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

public extension WidgetView {
    @ViewBuilder
    var body: some View {
        if let additionalState = viewModel.additionalState {
            Group {
                switch additionalState {
                case .loading(let props):
                    loaderView(props: props)
                case .error(let props):
                    errorView(props: props)
                case .placeholder(let props):
                    placeholderView(props: props)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 250, alignment: .center)
            .clippedWithBackground(.surface)
        } else {
            contentView
        }
    }

    @ViewBuilder func loaderView(props: PageState.LoaderProps) -> some View {
        PageLoadingView(props: props)
    }

    @ViewBuilder func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyStateView(title: "There is nothing here")
    }

    @ViewBuilder func errorView(props: PageState.ErrorProps) -> some View {
        WidgetErrorView(props: props)
    }
}
