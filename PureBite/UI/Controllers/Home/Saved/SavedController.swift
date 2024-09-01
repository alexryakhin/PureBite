import UIKit
import Combine

public final class SavedController: ViewController {

    public enum Event {
        case openRecipeDetails(id: Int)
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: SavedViewModel
    private var suiView: SavedView

    // MARK: - Initialization

    public init(viewModel: SavedViewModel) {
        let suiView = SavedView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
        tabBarItem = TabBarItem.saved.item
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        embed(swiftUiView: suiView)
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.onEvent?(.openRecipeDetails(id: id))
            }
        }
    }
}
