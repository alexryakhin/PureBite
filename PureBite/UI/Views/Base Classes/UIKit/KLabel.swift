import UIKit

// swiftlint:disable:next final_class
class KLabel: BaseLabel {

    private(set) var foregroundStyle: ForegroundStyle?
    private(set) var fontStyle: FontStyle?

    convenience init(foregroundStyle: ForegroundStyle?, fontStyle: FontStyle?) {
        self.init()
        self.foregroundStyle = foregroundStyle
        self.fontStyle = fontStyle
        updateAppearance()
    }

    @discardableResult
    func foregroundStyle(_ foregroundStyle: ForegroundStyle) -> Self {
        self.foregroundStyle = foregroundStyle
        updateAppearance()
        return self
    }

    @discardableResult
    func fontStyle(_ fontStyle: FontStyle) -> Self {
        self.fontStyle = fontStyle
        updateAppearance()
        return self
    }

    override func updateAppearance() {
        super.updateAppearance()
        if let foregroundStyle {
            textColor(foregroundStyle.color)
            tintColor(foregroundStyle.color)
        }
        if let fontStyle {
            textStyle(fontStyle.textStyle)
        }
    }
}
