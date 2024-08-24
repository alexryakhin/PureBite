import SwiftUI
import Combine

struct AuthorizeView: PageView {

    typealias Props = AuthorizeContentProps
    typealias ViewModel = AuthorizeViewModel

    // MARK: - Private properties

    @ObservedObject var props: Props
    @ObservedObject var viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    // MARK: - Views

    var contentView: some View {
        VStack {
            Button {
                viewModel.onEvent?(.finish)
            } label: {
                Text("Authorize")
            }
        }
    }
}
