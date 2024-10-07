import UIKit
import Combine

public typealias SavedPageViewController = SavedController<SavedPageView>

public final class SavedController<Content: PageView>: PageViewController<SavedPageView>, UISearchResultsUpdating {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsPageViewModel.Config)
        case openCategory(config: RecipeCollectionPageViewModel.Config)
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: SavedPageViewModel

    // MARK: - Initialization

    public init(viewModel: SavedPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: SavedPageView(viewModel: viewModel))
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
            case .openRecipeDetails(let config):
                self?.onEvent?(.openRecipeDetails(config: config))
            case .openCategory(let config):
                self?.onEvent?(.openCategory(config: config))
            }
        }
    }
}
