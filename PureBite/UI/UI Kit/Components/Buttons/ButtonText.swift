import UIKit

final class ButtonText: BaseBrandButton {

    override func setupDefaultAppearance() {
        super.setupDefaultAppearance()

        titleLabel?.textStyle(.callout)
        backgroundColor = .clear

        titleColor(.label, for: .normal)
        titleColor(.label, for: .highlighted)
        titleColor(.label, for: .selected)
        titleColor(.label, for: .focused)
        titleColor(.secondaryLabel, for: .disabled)
    }

    override func setupNormalAppearance() {
        super.setupNormalAppearance()
        tintColor(.label)
        accessoryView?.tintColor(.label)
    }

    override func setupActiveAppearance() {
        super.setupActiveAppearance()
        tintColor(.label)
        accessoryView?.tintColor(.label)
    }

    override func setupLoadingAppearance() {
        super.setupLoadingAppearance()
        titleColor(.clear, for: .disabled)
        tintColor(.label)
        accessoryView?.tintColor(.label)
    }

    override func setupDisabledAppearance() {
        super.setupDisabledAppearance()
        tintColor(.secondarySystemFill)
        accessoryView?.tintColor(.secondaryLabel)
    }
}
