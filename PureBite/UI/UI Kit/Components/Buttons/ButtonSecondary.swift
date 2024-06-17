import UIKit

final class ButtonSecondary: BaseStretchingBrandButton {

    override func setupDefaultAppearance() {
        super.setupDefaultAppearance()

        titleLabel?.textStyle(.callout)

        titleColor(.label, for: .normal)
        titleColor(.label, for: .highlighted)
        titleColor(.label, for: .selected)
        titleColor(.label, for: .focused)
        titleColor(.quaternaryLabel, for: .disabled)

        animateBackgroundColor(.secondarySystemFill)

        tintColor(.label)
        accessoryView?.tintColor(.label)

        cornerRadius = 16
    }

    override func setupNormalAppearance() {
        super.setupNormalAppearance()
    }

    override func setupActiveAppearance() {
        super.setupActiveAppearance()
        animateBackgroundColor(.secondarySystemFill)
    }

    override func setupLoadingAppearance() {
        super.setupLoadingAppearance()
        titleColor(.clear, for: .disabled)
        tintColor(.quaternaryLabel)
        accessoryView?.tintColor(.quaternaryLabel)
    }

    override public func setupDisabledAppearance() {
        super.setupDisabledAppearance()
        tintColor(.quaternaryLabel)
        accessoryView?.tintColor(.quaternaryLabel)
    }
}
