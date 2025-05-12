import SwiftUI
import Combine
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared
import Services

public struct IngredientSearchDashboardWidgetView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: IngredientSearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        VStack(spacing: 0) {
            ListWithDivider(viewModel.searchResults) { item in
                IngredientCellView(ingredient: item) {
                    print("onTap")
                } onShoppingCartAction: {
                    print("onShoppingCartAction")
                }
            }
            .clippedWithBackground(.surface)
        }
        .frame(minHeight: 200)
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyStateView.ingredientsSearchPlaceholder
            .frame(maxHeight: .infinity)
            .clippedWithBackground(.surface)
    }
}
