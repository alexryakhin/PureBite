#if DEBUG
public enum DebugScreen {
    case homeMain
}

public enum DebugFlow: CaseIterable {

    case home

    var title: String {
        switch self {
        case .home: "Home"
        }
    }

    public var flowScreensConfig: FlowScreensConfig? {
        switch self {
        case .home:
            return .init(screens: [
                .init(title: "Home", screen: .homeMain)
            ])
        }
    }

    public var relatedScreen: DebugScreen? {
        switch self {
        case .home:
            return nil
        }
    }
}
#endif
