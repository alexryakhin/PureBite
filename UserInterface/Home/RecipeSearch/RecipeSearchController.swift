import UIKit
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared

public final class RecipeSearchController: PageViewController<RecipeSearchPageView>, NavigationBarVisible {

    public enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: RecipeSearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: RecipeSearchPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: RecipeSearchPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.search.item
        setupBindings()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Search"
        resetNavBarAppearance()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let recipeShortInfo):
                self?.onEvent?(.openRecipeDetails(recipeShortInfo: recipeShortInfo))
            case .activateSearch(let query):
                self?.activateSearch(query: query)
            }
        }
    }
}
