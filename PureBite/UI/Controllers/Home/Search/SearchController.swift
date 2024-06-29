import UIKit
import Combine
import EnumsMacros
import EventSenderMacro

@EventSender
public final class SearchController: ViewController {

    @PlainedEnum
    public enum Event {
        case finish
    }

    // MARK: - Private properties

    private let viewModel: SearchViewModel
    private var suiView: SearchView

    // MARK: - Initialization

    public init(viewModel: SearchViewModel) {
        let suiView = SearchView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
        tabBarItem = TabBarItem.search.item
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
