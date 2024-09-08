import Combine
import UIKit

public final class RecipeCollectionController: ViewController {

    public enum Event {
        case finish
        case openRecipeDetails(id: Int)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: RecipeCollectionViewModel
    private var suiView: RecipeCollectionView

    // MARK: - Initialization

    public init(viewModel: RecipeCollectionViewModel) {
        let suiView = RecipeCollectionView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        embed(swiftUiView: suiView)
        setupBindings()
        setupSearchBar()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = viewModel.state.contentProps.title
        setupSearchBar(placeholder: "Search recipes")
        navigationItem.searchController?.searchResultsUpdater = self
        resetNavBarAppearance()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.onEvent?(.openRecipeDetails(id: id))
            case .finish:
                self?.onEvent?(.finish)
            }
        }
    }
}

extension RecipeCollectionController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.handleSearchInput(searchText)
        }
    }
}
