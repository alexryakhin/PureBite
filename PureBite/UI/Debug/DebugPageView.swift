import SwiftUI
import Combine

public struct DebugPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: DebugPageViewModel

    // MARK: - Initialization

    public init(viewModel: DebugPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        Text("Debug")
    }
}
