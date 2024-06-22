public enum FeatureToggle: String, CaseIterable {

    case mock_data

    public var isEnabledByDefault: Bool {
        switch self {
        case .mock_data:
            true
        }
    }

    public var title: String {
        switch self {
        case .mock_data:
            "Use mock data if available for requests."
        }
    }
}
