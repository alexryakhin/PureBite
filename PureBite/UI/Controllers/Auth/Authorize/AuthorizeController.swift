import UIKit
import Combine
import EnumsMacros
import EventSenderMacro

@EventSender
public final class AuthorizeController: ViewController {

    @PlainedEnum
    public enum Event {
        case finish
    }

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
        viewModel.on { [weak self] event in
            switch event {
            case .finish:
                self?.send(event: .finish)
            }
        }
    }
}
