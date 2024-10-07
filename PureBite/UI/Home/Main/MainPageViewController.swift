import UIKit
import Combine

public typealias MainPageViewController = MainController<MainPageView>

public final class MainController<Content: PageView>: PageViewController<MainPageView> {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsPageViewModel.Config)
        case openSearchScreen
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: MainPageViewModel

    // MARK: - Initialization

    public init(viewModel: MainPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: MainPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.main.item
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let config):
                self?.onEvent?(.openRecipeDetails(config: config))
            case .openSearchScreen:
                self?.onEvent?(.openSearchScreen)
            }
        }
    }
}
