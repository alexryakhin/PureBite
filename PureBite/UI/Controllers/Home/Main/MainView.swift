import Combine
import SwiftUI

struct MainView: View {

    typealias ViewModel = MainViewModel
    typealias State = PageState<
        MainContentProps,
        DefaultLoaderProps,
        DefaultPlaceholderProps,
        DefaultErrorProps
    >

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
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
                contentView(props: viewModel.state.contentProps)
            }
        }
        .animation(.easeInOut, value: viewModel.state)
    }

    private func contentView(props: State.ContentProps) -> MainContentView {
        MainContentView(props: props)
    }

    private func loader(props: State.LoaderProps) -> some View {
        ProgressView()
            .progressViewStyle(.circular)
    }

    private func errorView(props: State.ErrorProps) -> some View {
        EmptyView()
    }

    private func placeholder(props: State.PlaceholderProps) -> some View {
        EmptyView()
    }
}
