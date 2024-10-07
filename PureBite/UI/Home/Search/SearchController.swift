import UIKit
import Combine
import SwiftUI

public typealias SearchPageViewController = SearchController<SearchPageView>

public final class SearchController<Content: PageView>: PageViewController<SearchPageView>, UISearchResultsUpdating {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsPageViewModel.Config)
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: SearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: SearchPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: SearchPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.search.item
        setupBindings()
        setupSearchBar()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Search"
        navigationItem.searchController?.searchResultsUpdater = self
        resetNavBarAppearance()
    }

    public func activateSearch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.navigationItem.searchController?.isActive = true
            self?.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
    }

    public func updateSearchResults(for searchController: UISearchController) {
        viewModel.isSearchFocused = searchController.isActive
        viewModel.searchTerm = searchController.searchBar.text ?? .empty
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let config):
                self?.onEvent?(.openRecipeDetails(config: config))
            }
        }
        onSearchSubmit = { [weak self] query in
            self?.viewModel.loadRecipes(for: query)
        }
    }
}
