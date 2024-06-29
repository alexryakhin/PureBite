import UIKit
import Combine
import EnumsMacros
import EventSenderMacro

// Copy to Assembly
/*
    container.register(SavedController.self) { resolver in
        let viewModel = SavedViewModel(arg: 0)
        let controller = SavedController(viewModel: viewModel)
        return controller
    }
*/

@EventSender
public final class SavedController: ViewController {

    @PlainedEnum
    public enum Event {
        case finish
    }

    // MARK: - Private properties

    private let viewModel: SavedViewModel
    private var suiView: SavedView

    // MARK: - Initialization

    public init(viewModel: SavedViewModel) {
        let suiView = SavedView(viewModel: viewModel)
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
