import UIKit
import Combine

public typealias DebugPageViewController = DebugController<DebugPageView>

public final class DebugController<Content: PageView>: PageViewController<DebugPageView> {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: DebugPageViewModel

    // MARK: - Initialization

    public init(viewModel: DebugPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: DebugPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
    }

    // MARK: - Private Methods

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .automatic
        title = "Debug Panel"
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    @objc private func closeButtonTapped() {
        onEvent?(.finish)
    }
}
