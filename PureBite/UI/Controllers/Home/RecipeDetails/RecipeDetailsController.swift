import UIKit
import Combine
import EnumsMacros
import EventSenderMacro

@EventSender
public final class RecipeDetailsController: ViewController {

    @PlainedEnum
    public enum Event {
        case finish
    }

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
        setupNavigationBar()
        embed(swiftUiView: suiView)
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        // title = "Title"
        // navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupBindings() {
        viewModel.on { [weak self] event in
            switch event {
            case .finish:
                self?.send(event: .finish)
            }
        }
    }
}
