#if DEBUG
import UIKit

public struct FlowScreensConfig {

    public struct FlowScreen {

        public let title: String
        public let screen: DebugScreen

        public init(title: String, screen: DebugScreen) {
            self.title = title
            self.screen = screen
        }
    }

    public let screens: [FlowScreen]

    public init(screens: [FlowScreensConfig.FlowScreen]) {
        self.screens = screens
    }
}

public final class FlowScreensController: PageSheetController {
    public typealias OnScreenTapHandler = (DebugScreen) -> Void

    public var onChooseScreen: OnScreenTapHandler?
    private var config: FlowScreensConfig?

    public convenience init(_ config: FlowScreensConfig) {
        self.init()
        self.config = config
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        content = body()
    }

    private func body() -> UIView {
        config != nil ?
            KVStack {
                KForEach(collection: config?.screens ?? []) { screen in
                   RSSpacer(.px8)
                    ButtonPrimary(title: screen.title)
                        .onTap { [weak self] in
                            self?.dismiss(animated: true) {
                                self?.onChooseScreen?(screen.screen)
                            }
                        }
                }
               RSSpacer(.px8)
            }
        : BaseView()
    }
}
#endif
