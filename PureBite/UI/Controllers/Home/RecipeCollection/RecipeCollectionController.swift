import Combine
import UIKit

public final class RecipeCollectionController: ViewController {

    public enum Event {
        case finish
        case openRecipeDetails(config: RecipeDetailsViewModel.Config)
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
        embed(swiftUiView: suiView, ignoresKeyboard: false)
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

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let config):
                self?.onEvent?(.openRecipeDetails(config: config))
            case .finish:
                self?.onEvent?(.finish)
            }
        }
    }
}

extension RecipeCollectionController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.searchTerm = searchText
        }
    }
}
