import UIKit
import Combine
import EnumsMacros
import EventSenderMacro

@EventSender
public final class ShoppingListController: ViewController {

    @PlainedEnum
    public enum Event {
        case finish
    }

    // MARK: - Private properties

    private let viewModel: ShoppingListViewModel
    private var suiView: ShoppingListView

    // MARK: - Initialization

    public init(viewModel: ShoppingListViewModel) {
        let suiView = ShoppingListView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
        tabBarItem = TabBarItem.shoppingList.item
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupNavigationBar()
        embed(swiftUiView: suiView)
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        // title = "Title"
        // navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupBindings() {
    }
}
