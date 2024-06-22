public enum AppEnvironment: Int, CaseIterable {
 #if DEBUG
    case debug
 #endif
    case release

    public var name: String {
        switch self {
 #if DEBUG
        case .debug:
            return "debug"
 #endif
        case .release:
            return "release"
        }
    }

    static func named(_ name: String) -> AppEnvironment? {
        return Self.allCases.first(where: { $0.name == name })
    }
}
