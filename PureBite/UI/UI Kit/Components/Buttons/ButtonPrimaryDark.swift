import UIKit

final class ButtonPrimaryDark: BaseStretchingBrandButton {

    override func setupDefaultAppearance() {
        super.setupDefaultAppearance()

        titleLabel?.textStyle(.callout)

        titleColor(.lightText, for: .normal)
        titleColor(.lightText, for: .highlighted)
        titleColor(.lightText, for: .selected)
        titleColor(.lightText, for: .focused)
        titleColor(.lightText, for: .disabled)

        animateBackgroundColor(.label)

        cornerRadius = 16
    }

    override func setupActiveAppearance() {
        super.setupActiveAppearance()
        animateBackgroundColor(.secondaryLabel)
    }

    override func setupLoadingAppearance() {
        super.setupLoadingAppearance()
        titleColor(.clear, for: .disabled)
    }

    override func setupDisabledAppearance() {
        super.setupDisabledAppearance()
        tintColor(.label)
        accessoryView?.tintColor(.label)
    }

    override public func makeLoaderView() -> UIView {
        MediumSpinner(style: .light)
    }
}
