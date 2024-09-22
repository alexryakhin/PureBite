import SwiftUI
import Combine

struct AuthorizeView: PageView {

    typealias ViewModel = AuthorizeViewModel

    // MARK: - Private properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
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
