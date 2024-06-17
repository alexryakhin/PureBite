#if DEBUG
import UIKit

public enum DebugAction {

    case startNormally
    case startEntrance
    case skipAuth
    case startFlow(_ flow: DebugFlow)
    case showScreen(_ screen: DebugScreen)
}

public final class DebugRoutingController: TemplateViewController<BackgroundPrimary> {

    // MARK: - Type Aliases

    public typealias DebugActionHandler = (DebugAction) -> Void

    // MARK: - Types

    private enum Constant {
        static let cornerRadius: CGFloat = 8
    }

    // MARK: - Public Properties

    public var onAction: DebugActionHandler?

    // MARK: - Private Properties

    private let appSession: AppSession
    private var contentView: UIView?

    // MARK: - Init

    public init(appSession: AppSession) {
        self.appSession = appSession
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override public func setup() {
        super.setup()
        title = "[DEBUG] Routing"
        recreateViews()
    }

    // MARK: - Private Methods
    private func recreateViews() {
        contentView?.removeFromSuperview()
        let contentView = BaseScrollView(padding: 16) {
            KVStack {
                RSSpacer(.px24)
                header()
                RSSpacer(.px24)
            }
        }
        contentView.embed(in: view)
        self.contentView = contentView
    }

    private func header() -> UIView {
        KVStack {
            ButtonSecondary(title: "Start")
                .onTap { [weak self] in
                    self?.onAction?(.startNormally)
                }
            RSSpacer(.px4)
            KHStack {
                KLabel(foregroundStyle: .primary, fontStyle: .body)
                    .text(
                        {
                            if appSession.isLoggedIn {
                                "You are logged in"
                            } else {
                                "You are not logged in"
                            }
                        }()
                    )
                    .multiline()
            }.directionalLayoutMargins(.make(hInsets: 8))
            RSSpacer(.px20)
            ButtonSecondary(title: "Start Entrance")
                .onTap { [weak self] in
                    self?.onAction?(.startEntrance)
                }
            RSSpacer(.px20)
            ButtonSecondary(title: "Skip Auth")
                .onTap { [weak self] in
                    self?.onAction?(.skipAuth)
                }
            RSSpacer(.px20)
            ButtonSecondary(title: "Full Reset")
                .onTap { [weak self] in
                    self?.appSession.fullReset()
                    self?.recreateViews()
                }
        }
    }

    private func showDebugRouting(for flow: DebugFlow) {
        let screensActionSheet = UIAlertController(title: flow.title, message: nil, preferredStyle: .actionSheet)
        flow.flowScreensConfig?.screens.forEach { screen in
            screensActionSheet.addAction(
                UIAlertAction(title: screen.title, style: .default) { [weak self] _ in
                    self?.onAction?(.showScreen(screen.screen))
                }
            )
        }
        screensActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(screensActionSheet, animated: true)
    }
}
#endif
