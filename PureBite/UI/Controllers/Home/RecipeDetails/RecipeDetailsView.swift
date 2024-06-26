import Combine
import SwiftUI

struct RecipeDetailsView: View {

    typealias ViewModel = RecipeDetailsViewModel
    typealias State = PageState<
        RecipeDetailsContentProps,
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

    private func contentView(props: State.ContentProps) -> RecipeDetailsContentView {
        RecipeDetailsContentView(props: props)
    }

    private func loader(props: State.LoaderProps) -> some View {
        PageLoadingView()
    }

    private func errorView(props: State.ErrorProps) -> some View {
        PageErrorView(props: props)
    }

    private func placeholder(props: State.PlaceholderProps) -> some View {
        EmptyView()
    }
}
