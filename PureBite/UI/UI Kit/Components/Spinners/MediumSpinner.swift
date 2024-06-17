import UIKit

final class MediumSpinner: Spinner {

    enum Style {
        case light, dark, accent, positive
    }

    // MARK: - Properties

    init(style: Style = .dark) {
        super.init(spinnerProps: BaseSpinner.Props(
            size: CGSize(width: 24, height: 24),
            elementsCount: 12,
            elementSize: CGSize(width: 2, height: 7),
            elementsAnimationDuration: 1,
            elementColor: AnySubject<CGColor>(style.color.cgColor).eraseToAnyPublisher()
        ))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MediumSpinner.Style {

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
