import UIKit
import Combine

public typealias ShoppingListPageViewController = ShoppingListController<ShoppingListPageView>

public final class ShoppingListController<Content: PageView>: PageViewController<ShoppingListPageView> {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ShoppingListPageViewModel

    // MARK: - Initialization

    public init(viewModel: ShoppingListPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ShoppingListPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.shoppingList.item
        setupNavigationBar()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        // title = "Shopping List"
    }

    private func setupBindings() {
    }
}
