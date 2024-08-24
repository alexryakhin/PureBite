import UIKit
import Combine

public final class AuthorizeController: ViewController {

    public enum Event {
        case finish
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: AuthorizeViewModel
    private var suiView: AuthorizeView

    // MARK: - Initialization

    public init(viewModel: AuthorizeViewModel) {
        let suiView = AuthorizeView(viewModel: viewModel)
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
         title = "AuthorizeController"
    }

    private func setupBindings() {
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.onEvent?(.finish)
            }
        }
    }
}
