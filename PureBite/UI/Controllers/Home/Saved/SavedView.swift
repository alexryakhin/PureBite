import SwiftUI
import Combine

struct SavedView: PageView {

    typealias Props = SavedContentProps
    typealias ViewModel = SavedViewModel

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
        Text("Saved")
    }
}
