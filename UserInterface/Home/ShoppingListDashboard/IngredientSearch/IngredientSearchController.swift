import UIKit
import Combine
import Core
import CoreUserInterface
import Shared

public final class IngredientSearchController: PageViewController<IngredientSearchPageView>, NavigationBarVisible {

    public enum Event {
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: IngredientSearchPageViewModel

    // MARK: - Initialization

    public init(viewModel: IngredientSearchPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: IngredientSearchPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.saved.item
        setupBindings()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Ingredients"
        resetNavBarAppearance()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] event in
            switch event {
            }
        }
    }
}
