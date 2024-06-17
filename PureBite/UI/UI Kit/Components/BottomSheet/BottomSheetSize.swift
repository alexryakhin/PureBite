import Foundation

/// Enum that specify how the sheet should size it self based on its content.
/// The sheet sizing act as a loose anchor on how big the sheet should be, and the sheet will always respect its content's constraints.
/// However, the sheet will never extend beyond the top safe area (plus any stretch offset).
public enum BottomSheetSize {
    /// The sheet will try to size itself so that it only just fits its content.
    case fit
    /// The sheet will try to size itself so that it fills 1/4 of available space.
    case small
    /// The sheet will try to size itself so that it fills 1/2 of available space.
    case medium
    /// The sheet will try to size itself so that it fills 3/4 of available space.
    case large
    /// The sheet will try to size itself so that it fills all available space.
    case fill
    /// The sheet will try to size itself so that it fills a custom fraction of available space.
    case custom(CGFloat)

    var value: CGFloat {
        switch self {
        case .fit:
            return 0
        case .small:
            return 0.25
        case .medium:
            return 0.5
        case .large:
            return 0.75
        case .fill:
            return 1
        case .custom(let value):
            return max(0, min(value, 1))
        }
    }
}
