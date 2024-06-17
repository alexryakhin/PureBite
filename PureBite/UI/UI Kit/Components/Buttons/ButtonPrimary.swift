import UIKit

final class ButtonPrimary: BaseStretchingBrandButton {

    override func setupDefaultAppearance() {
        super.setupDefaultAppearance()

        titleLabel?.textStyle(.callout)

        titleColor(.label, for: .normal)
        titleColor(.tertiaryLabel, for: .highlighted)
        titleColor(.secondaryLabel, for: .selected)
        titleColor(.secondarySystemFill, for: .focused)
        titleColor(.quaternaryLabel, for: .disabled)

        animateBackgroundColor(.accent)

        tintColor(.label)
        accessoryView?.tintColor(.label)

        cornerRadius = 16
    }

    override func setupNormalAppearance() {
        super.setupNormalAppearance()
    }

    override func setupActiveAppearance() {
        super.setupActiveAppearance()
        animateBackgroundColor(.tertiaryLabel)
    }

    override func setupLoadingAppearance() {
        super.setupLoadingAppearance()
        titleColor(.clear, for: .disabled)
        tintColor(.quaternaryLabel)
        accessoryView?.tintColor(.quaternaryLabel)
    }

    override func setupDisabledAppearance() {
        super.setupDisabledAppearance()
        animateBackgroundColor(.accent)
        tintColor(.quaternaryLabel)
        accessoryView?.tintColor(.quaternaryLabel)
    }
}
