import UIKit
import Combine
import SwiftUI

public final class ShoppingListController: PageViewController<ShoppingListPageView>, UISearchResultsUpdating {

    public enum Event {
        case showIngredientInformation(IngredientDetailsPageViewModel.Config)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ShoppingListPageViewModel

    // MARK: - Initialization

    public init(viewModel: ShoppingListPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ShoppingListPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.shoppingList.item
        setupBindings()
        setupSearchBar(placeholder: "Search Ingredients")
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Shopping List"
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
            case .showIngredientInformation(let config):
                self?.onEvent?(.showIngredientInformation(config))
            }
        }
        onSearchSubmit = { [weak self] query in
            self?.viewModel.handle(.search(query: query))
        }
        onSearchCancel = { [weak self] in
            self?.viewModel.searchTerm = .empty
            self?.viewModel.searchResults.removeAll()
        }
        onSearchEnded = { [weak self] in
            print("search ended")
        }
    }
}
