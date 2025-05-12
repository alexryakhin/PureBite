import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct ShoppingListDashboardWidgetView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: ShoppingListPageViewModel

    // MARK: - Initialization

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        Text("ShoppingListDashboardWidgetView")
            .frame(minHeight: 200)
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyStateView.shoppingListPlaceholder
            .frame(maxHeight: .infinity)
            .clippedWithBackground(.surface)
    }
}
