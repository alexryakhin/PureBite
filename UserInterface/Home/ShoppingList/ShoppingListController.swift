import UIKit
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared

public final class ShoppingListController: PageViewController<ShoppingListPageView>, NavigationBarVisible {

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
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Shopping List"
        resetNavBarAppearance()
    }
}
