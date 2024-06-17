import UIKit
import Combine
import SnapKit

// swiftlint:disable:next final_class
open class PageSheetController: ViewController {

    public enum TopCapStyle {
        case plain, rounded
    }

    public enum CloseBehavior {
        // Close on backgroundView tap, swipe and close button tap
        case anyCloseAction
        // Close only on close button tap
        case onlyCloseButtonTap
    }

    open var close: VoidHandler?

    open var topCapStyle: TopCapStyle = .plain
    open var content: UIView = BaseView() {
        didSet {
            setupViews()
        }
    }
    public var closeBehavior: CloseBehavior

    private let transition: PanelTransition
    private let scrollView = UIScrollView()

    // MARK: - Init

    public required init(closeBehavior: CloseBehavior = .anyCloseAction) {
        self.closeBehavior = closeBehavior
        self.transition = PanelTransition(
            with: closeBehavior == .anyCloseAction
                ? [.interactiveSwipeToDismiss]
                : []
        )
        super.init()

        modalPresentationStyle = .custom
        transitioningDelegate = transition
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupViews() {
        let stackView = KVStack { content }
        stackView.directionalLayoutMargins(.all(Constant.hMargin))
        stackView.embed(in: scrollView)
        scrollView.snp.makeConstraints {
            $0.height.equalTo(stackView.snp.height).priority(.medium)
        }
        stackView.snp.makeConstraints {
            $0.width.equalTo(scrollView)
        }

        mainBody().embed(in: self.view, useSafeAreaGuide: false)
    }

    private func mainBody() -> UIView {
        KVStack {
            BaseView()
                .height(UIWindow.safeAreaTopInset)
            BaseView()
                .height(Constant.topSpace)

            BaseView()
                .onTap { [weak self] in
                    guard let self = self else { return }
                    switch self.closeBehavior {
                    case .anyCloseAction:
                        self.dismiss(animated: true) { [weak self] in self?.close?() }
                    case .onlyCloseButtonTap:
                        break
                    }
                }

            BaseBackgroundView(vPadding: 0, hPadding: 0) {
                scrollView
            }
            .roundingCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: topCapStyle == .rounded ? 32 : 0)
            .backgroundColor(.systemBackground)
        }
    }
}

// MARK: - Constants
fileprivate extension PageSheetController {

    enum Constant {
        static let popupIndicatorWidth: CGFloat = 36
        static let popupIndicatorHeight: CGFloat = 4
        static let hMargin: CGFloat = 0
        static let headerHeight: CGFloat = 24
        static let topSpace: CGFloat = 40
    }
}
