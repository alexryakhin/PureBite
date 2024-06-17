import UIKit

// swiftlint:disable:next final_class
open class RSView: BaseView {

    // MARK: - Private Properties

    private(set) var backgroundStyle: BackgroundStyle?
    private(set) var shadowStyle: ShadowStyle?

    // MARK: - Init

    convenience init(backgroundStyle: BackgroundStyle, shadowStyle: ShadowStyle? = nil) {
        self.init()
        self.backgroundStyle = backgroundStyle
        self.shadowStyle = shadowStyle
        updateAppearance()
    }

    // MARK: - Public Methods

    @discardableResult
    func backgroundStyle(_ backgroundStyle: BackgroundStyle) -> Self {
        self.backgroundStyle = backgroundStyle
        backgroundColor(backgroundStyle.color)
        return self
    }

    @discardableResult
    func backgroundStyle(_ shadowStyle: ShadowStyle) -> Self {
        self.shadowStyle = shadowStyle
        shadow(shadowStyle.shadowProps)
        return self
    }

    override open func updateAppearance() {
        super.updateAppearance()
        if let backgroundStyle {
            backgroundColor(backgroundStyle.color)
        }
        if let shadowStyle {
            shadow(shadowStyle.shadowProps)
        }
    }
}
