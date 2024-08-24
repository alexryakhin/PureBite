import UIKit
import Combine

public final class SearchController: ViewController {

    public enum Event {
        case openRecipeDetails(id: Int)
    }
    var onEvent: ((Event) -> Void)?

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
        embed(swiftUiView: suiView)
        setupBindings()
    }

    public func activateSearch() {
        viewModel.state.contentProps.shouldActivateSearch = true
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.onEvent?(.openRecipeDetails(id: id))
            }
        }
    }
}
