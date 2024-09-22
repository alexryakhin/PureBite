import UIKit
import Combine

public final class MainController: ViewController {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsViewModel.Config)
        case openSearchScreen
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: MainViewModel
    private var suiView: MainView

    // MARK: - Initialization

    public init(viewModel: MainViewModel) {
        let suiView = MainView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.main.item
        embed(swiftUiView: suiView)
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
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
