import UIKit
import Combine

public final class SavedController: ViewController {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsViewModel.Config)
        case openCategory(config: RecipeCollectionViewModel.Config)
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: SavedViewModel
    private var suiView: SavedView

    // MARK: - Initialization

    public init(viewModel: SavedViewModel) {
        let suiView = SavedView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
        tabBarItem = TabBarItem.saved.item
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        embed(swiftUiView: suiView, ignoresKeyboard: false)
        setupBindings()
        setupSearchBar()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Saved"
        setupSearchBar(placeholder: "Search recipes")
//        navigationItem.searchController?.searchResultsUpdater = self
        resetNavBarAppearance()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let config):
                self?.onEvent?(.openRecipeDetails(config: config))
            case .openCategory(let config):
                self?.onEvent?(.openCategory(config: config))
            }
        }
    }
}
