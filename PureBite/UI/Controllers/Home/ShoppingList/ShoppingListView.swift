import SwiftUI
import Combine

struct ShoppingListView: PageView {

    typealias Props = ShoppingListContentProps
    typealias ViewModel = ShoppingListViewModel

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
        Text("ShoppingList")
    }
}
