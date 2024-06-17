import UIKit

extension BaseView {
    @discardableResult
    public func roundingCorners(corners: CACornerMask, radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        return self
    }
}
