import UIKit

// swiftlint:disable:next final_class
class ImageView: BaseImageView {

    // MARK: - Private Properties

    private(set) var foregroundStyle: ForegroundStyle?

    // MARK: - Init

    convenience init(image: UIImage? = nil, foregroundStyle: ForegroundStyle?) {
        self.init()
        self.image = image
        self.foregroundStyle = foregroundStyle
        updateAppearance()
    }

    // MARK: - Public Methods

    @discardableResult
    func foregroundStyle(_ foregroundStyle: ForegroundStyle) -> Self {
        self.foregroundStyle = foregroundStyle
        updateAppearance()
        return self
    }

    override func updateAppearance() {
        super.updateAppearance()
        if let foregroundStyle {
            tintColor(foregroundStyle.color)
        }
    }
}
