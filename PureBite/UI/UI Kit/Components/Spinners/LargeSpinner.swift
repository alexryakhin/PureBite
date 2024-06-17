import UIKit

final class LargeSpinner: Spinner {

    enum Style {
        case light, dark, accent, positive
    }

    init(style: Style = .dark) {
        super.init(spinnerProps: BaseSpinner.Props(
            size: CGSize(width: 32, height: 32),
            elementsCount: 12,
            elementSize: CGSize(width: 2, height: 9),
            elementsAnimationDuration: 1,
            elementColor: AnySubject<CGColor>(style.color.cgColor).eraseToAnyPublisher()
        ))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LargeSpinner.Style {

    var color: UIColor {
        switch self {
        case .light:
            return .lightGray
        case .dark:
            return .darkGray
        case .accent:
            return .accent
        case .positive:
            return .accent
        }
    }
}
