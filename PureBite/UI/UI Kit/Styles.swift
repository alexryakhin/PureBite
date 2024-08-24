import UIKit

// Defines background color
public enum BackgroundStyle {
    case backgroundPrimary
    case surfacePrimary
    case surfaceAccent
    case surfaceOpacity
    case iconPrimary
}

// Defines textColor and tintColor
public enum ForegroundStyle {
    case primary
    case secondary
    case accent
    case disabled
    case negative
}

// Defines font
public enum FontStyle {
    case largeTitle,
    title1,
    title2,
    title3,
    headline,
    subheadline,
    body,
    callout,
    footnote,
    caption1,
    caption2
}

// Defines shadow properties
public enum ShadowStyle {
    case calendar
}

extension BackgroundStyle {

    public var color: UIColor {
        switch self {
        case .backgroundPrimary: return .systemBackground
        case .surfacePrimary: return .secondarySystemBackground
        case .surfaceAccent: return .accent
        case .surfaceOpacity: return .secondarySystemBackground.withAlphaComponent(0.3)
        case .iconPrimary: return .label
        }
    }
}

extension ForegroundStyle {

    public var color: UIColor {
        switch self {
        case .primary: return .label
        case .secondary: return .secondaryLabel
        case .accent: return .accent
        case .disabled: return .tertiaryLabel
        case .negative: return .red
        }
    }
}

extension FontStyle {

    public var textStyle: KTextStyle? {
        switch self {
        case .largeTitle: return .largeTitle
        case .title1: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption1: return .caption1
        case .caption2: return .caption2
        }
    }
}

extension ShadowStyle {

    public var shadowProps: ShadowProps {
        switch self {
        case .calendar:
            return ShadowProps( radius: 16, color: .label, offsetX: 0, offsetY: 8)
        }
    }
}
