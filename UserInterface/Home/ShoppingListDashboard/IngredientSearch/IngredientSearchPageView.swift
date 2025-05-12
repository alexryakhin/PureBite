import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct IngredientSearchPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: IngredientSearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        Text("IngredientSearchPageView")
    }
}
