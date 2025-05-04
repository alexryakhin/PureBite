import UIKit
import Combine
import Core
import CoreUserInterface
import Shared

public final class SavedRecipesController: PageViewController<SavedRecipesPageView>, NavigationBarVisible, UISearchResultsUpdating {

    public enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
        case openCategory(config: RecipeCollectionPageViewModel.Config)
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: SavedRecipesPageViewModel

    // MARK: - Initialization

    public init(viewModel: SavedRecipesPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: SavedRecipesPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.saved.item
        setupBindings()
        setupSearchBar()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Saved"
        navigationItem.searchController?.searchResultsUpdater = self
        resetNavBarAppearance()
    }

    public func updateSearchResults(for searchController: UISearchController) {
        viewModel.isSearchActive = searchController.isActive
        if let searchText = searchController.searchBar.text {
            viewModel.searchTerm = searchText
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let recipeShortInfo):
                self?.onEvent?(.openRecipeDetails(recipeShortInfo: recipeShortInfo))
            case .openCategory(let config):
                self?.onEvent?(.openCategory(config: config))
            }
        }
    }
}
