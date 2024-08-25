import UIKit
import Combine

public final class RecipeDetailsController: ViewController {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: RecipeDetailsViewModel
    private var suiView: RecipeDetailsView

    // MARK: - Initialization

    public init(viewModel: RecipeDetailsViewModel) {
        let suiView = RecipeDetailsView(viewModel: viewModel)
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
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.onEvent?(.finish)
            }
        }
    }
}
