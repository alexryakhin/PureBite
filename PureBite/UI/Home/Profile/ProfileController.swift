import UIKit
import Combine

public typealias ProfilePageViewController = ProfileController<ProfilePageView>

public final class ProfileController<Content: PageView>: PageViewController<ProfilePageView> {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

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