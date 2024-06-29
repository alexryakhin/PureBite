import UIKit
import Combine
import EnumsMacros
import EventSenderMacro

// Copy to Assembly
/*
    container.register(ProfileController.self) { resolver in
        let viewModel = ProfileViewModel(arg: 0)
        let controller = ProfileController(viewModel: viewModel)
        return controller
    }
*/

@EventSender
public final class ProfileController: ViewController {

    @PlainedEnum
    public enum Event {
        case finish
    }

    // MARK: - Private properties

    private let viewModel: ProfileViewModel
    private var suiView: ProfileView

    // MARK: - Initialization

    public init(viewModel: ProfileViewModel) {
        let suiView = ProfileView(viewModel: viewModel)
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
    }
}
