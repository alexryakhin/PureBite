import UIKit
import Combine

public final class ProfileController: ViewController {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ProfileViewModel
    private var suiView: ProfileView

    // MARK: - Initialization

    public init(viewModel: ProfileViewModel) {
        let suiView = ProfileView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
        tabBarItem = TabBarItem.profile.item
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
