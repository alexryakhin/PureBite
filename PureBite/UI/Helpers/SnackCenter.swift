import UIKit
import SnapKit

// TODO: - Move to CoreUI

public final class SnackCenter {

    public static var shared = SnackCenter()

    // MARK: - Public Properties

    public var snacksQueue: [SnackView] = []

    // MARK: - Private Properties

    private var keyboardHeight: CGFloat?

    // MARK: - Public Methods

    public func showSnack(_ config: SnackView.Config) {
        assert(Thread.isMainThread)
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive }

        guard
            let windowScene = scene as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow }),
            !snacksQueue.contains(where: { $0.config == config })
        else { return }

        let snack = SnackView().configured(with: config)

        snack.onDismiss = { [weak self] in
            guard let self, self.snacksQueue.isNotEmpty else { return }

            self.snacksQueue.remove(at: 0)

            if let snack = self.snacksQueue.first {
                self.place(snack: snack, onWindow: window)
            }
        }

        snacksQueue.append(snack)

        if snacksQueue.count == 1 {
            place(snack: snack, onWindow: window)
        }
    }

    private func place(snack: SnackView, onWindow window: UIView) {
        window.addSubview(snack)
        snack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().inset(16)
            $0.top.equalTo(window.safeAreaLayoutGuide.snp.top)
        }
    }
}
