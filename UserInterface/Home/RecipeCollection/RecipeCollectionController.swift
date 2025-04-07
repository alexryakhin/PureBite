import Combine
import UIKit
import Core
import CoreUserInterface
import Shared

public final class RecipeCollectionController: PageViewController<RecipeCollectionPageView>, NavigationBarVisible, UISearchResultsUpdating {

    public enum Event {
        case finish
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: RecipeCollectionPageViewModel

    // MARK: - Initialization

    public init(viewModel: RecipeCollectionPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: RecipeCollectionPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        setupSearchBar()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = viewModel.title
        navigationItem.searchController?.searchResultsUpdater = self
        resetNavBarAppearance()
    }

    public func updateSearchResults(for searchController: UISearchController) {
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
            case .finish:
                self?.onEvent?(.finish)
            }
        }
    }
}
