import SwiftUI

public protocol PageView: ViewWithBackground {
    associatedtype ContentView: View
    associatedtype LoaderView: View
    associatedtype ErrorView: View
    associatedtype PlaceholderView: View

    associatedtype ViewModel: DefaultPageViewModel<Props>
    associatedtype Props: HaveInitialState & Equatable
    typealias ScreenState = PageState<
        Props,
        DefaultLoaderProps,
        DefaultPlaceholderProps,
        DefaultErrorProps
    >

    var viewModel: ViewModel { get set }
    var props: Props { get set }

    @ViewBuilder var contentView: ContentView { get }
    @ViewBuilder func loader(props: ScreenState.LoaderProps) -> LoaderView
    @ViewBuilder func errorView(props: ScreenState.ErrorProps) -> ErrorView
    @ViewBuilder func placeholder(props: ScreenState.PlaceholderProps) -> PlaceholderView
}

public extension PageView {
    var content: some View {
        Group {
            if let additionalState = viewModel.state.additionalState {
                switch additionalState {
                case .loading(let props):
                    loader(props: props)
                case .error(let props):
                    errorView(props: props)
                case .empty(let props):
                    placeholder(props: props)
                }
            } else {
                contentView
            }
        }
        .animation(.easeInOut, value: viewModel.state)
    }

    @ViewBuilder func loader(props: ScreenState.LoaderProps) -> some View {
        PageLoadingView(props: props)
    }

    @ViewBuilder func errorView(props: ScreenState.ErrorProps) -> some View {
        PageErrorView(props: props)
    }

    @ViewBuilder func placeholder(props: ScreenState.PlaceholderProps) -> some View {
        EmptyView()
    }
}
