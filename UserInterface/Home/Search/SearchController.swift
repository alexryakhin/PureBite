import UIKit
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared

public final class SearchController: PageViewController<SearchPageView>, NavigationBarVisible, UISearchResultsUpdating {

    public enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
    }
    public var onEvent: ((Event) -> Void)?

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

    public func activateSearch(with query: String? = nil) {
        navigationItem.searchController?.searchBar.text = query
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
            case .openRecipeDetails(let recipeShortInfo):
                self?.onEvent?(.openRecipeDetails(recipeShortInfo: recipeShortInfo))
            case .activateSearch(let query):
                self?.activateSearch(with: query)
            }
        }
        onSearchSubmit = { [weak self] query in
            self?.viewModel.handle(.search(query: query))
        }
        onSearchCancel = { [weak self] in
            self?.viewModel.handle(.finishSearch)
        }
    }
}
