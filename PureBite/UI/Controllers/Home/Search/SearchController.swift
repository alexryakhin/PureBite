import UIKit
import Combine
import SwiftUI

public final class SearchController: ViewController {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsViewModel.Config)
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
        embed(swiftUiView: suiView, ignoresKeyboard: false)
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

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
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

extension SearchController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel.isSearchFocused = searchController.isActive
        viewModel.searchTerm = searchController.searchBar.text ?? .empty
    }
}
