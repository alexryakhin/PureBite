import UIKit
import Combine
import Core
import CoreUserInterface
import Shared

public final class IngredientDetailsController: PageViewController<IngredientDetailsPageView> {

    public enum Event {
        case finish
    }
    
    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties
    private let viewModel: IngredientDetailsPageViewModel

    // MARK: - Initialization

    public init(viewModel: IngredientDetailsPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: IngredientDetailsPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        setupBindings()
        view.backgroundColor = .clear
    }
    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.onEvent?(.finish)
            }
        }
    }
}
