import UIKit

// swiftlint:disable final_class
public class BaseBrandButton: BaseLoadingButton {

    // MARK: - Methods

    @discardableResult
    func leftIcon(icon: UIImage) -> Self {
        accessory(.image(icon, .beforeTitle(padding: 6)))
    }

    @discardableResult
    func rightIcon(icon: UIImage) -> Self {
        accessory(.image(icon, .afterTitle(padding: 6)))
    }

    override public func makeLoaderView() -> UIView {
        MediumSpinner(style: .dark)
    }
}

public class BaseStretchingBrandButton: BaseBrandButton {

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.layoutFittingExpandedSize.width, height: 52)
    }
}
// swiftlint:enable final_class
