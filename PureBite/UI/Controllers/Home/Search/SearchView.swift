import SwiftUI
import Combine

struct SearchView: PageView {

    typealias Props = SearchContentProps
    typealias ViewModel = SearchViewModel

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
        Text("Search")
    }
}
