import UIKit

public struct ShadowProps {
    let radius: CGFloat
    let color: UIColor
    let offsetX: CGFloat
    let offsetY: CGFloat
}

extension UIView {

    public func shadow(_ shadowProps: ShadowProps) {
        setShadow(
            radius: shadowProps.radius,
            color: shadowProps.color,
            offsetX: shadowProps.offsetX,
            offsetY: shadowProps.offsetY
        )
    }
}
