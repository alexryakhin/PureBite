import UIKit
import Combine
import Core
import CoreUserInterface
import Shared

public final class ProfileController: PageViewController<ProfilePageView> {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ProfilePageViewModel

    // MARK: - Initialization

    public init(viewModel: ProfilePageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ProfilePageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        tabBarItem = TabBarItem.profile.item
        setupNavigationBar()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        // title = "Profile"
    }

    private func setupBindings() {
    }
}
