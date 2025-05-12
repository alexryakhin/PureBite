import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct GroceryProductSearchPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: GroceryProductSearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        Text("GroceryProductSearchPageView")
    }
}
