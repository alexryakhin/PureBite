import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct GroceryProductSearchDashboardWidgetView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: GroceryProductSearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        VStack(spacing: 0) {
            ListWithDivider(viewModel.searchResults) { item in
                GroceryProductCellView(product: item) {

                } onShoppingCartAction: {

                }
            }
            .clippedWithBackground(.surface)
        }
        .frame(minHeight: 200)
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyStateView.groceryProductSearchPlaceholder
            .frame(maxHeight: .infinity)
            .clippedWithBackground(.surface)
    }
}
