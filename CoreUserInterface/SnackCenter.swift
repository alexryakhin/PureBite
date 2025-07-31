//
//  SnackCenter.swift
//  PureBite
//
//  Created by Alexander Riakhin on 5/29/25.
//
import UIKit
import SwiftUI

public final class SnackCenter {

    public static var shared = SnackCenter()

    // MARK: - Public Properties

    public var snacksQueue: [SnackView.Config] = []

    // MARK: - Private Properties

    private var keyboardHeight: CGFloat?
    private var currentSnack: UIHostingController<SnackView>?

    // MARK: - Public Methods

    public func showSnack(withConfig config: SnackView.Config) {
        assert(Thread.isMainThread)

        guard
            !snacksQueue.contains(config)
        else { return }

        snacksQueue.append(config)

        if currentSnack == nil {
            presentNextSnack()
        }
    }

    private func presentNextSnack() {
        guard !snacksQueue.isEmpty else { return }

        let config = snacksQueue.removeFirst()

        let snack = SnackView(config: config)

        let controller = UIHostingController(rootView: snack)
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.isUserInteractionEnabled = false // Let touches pass through

        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else { return }

        window.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 12),
            controller.view.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            controller.view.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])

        currentSnack = controller

        // Auto-dismiss after 2.5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.dismissCurrentSnack()
        }
    }

    private func dismissCurrentSnack() {
        guard let controller = currentSnack else { return }

        UIView.animate(withDuration: 0.3, animations: {
            controller.view.alpha = 0
        }, completion: { [weak self] _ in
            controller.view.removeFromSuperview()
            self?.currentSnack = nil
            self?.presentNextSnack()
        })
    }
}

public struct SnackView: View {

    public struct Config: Hashable {
        var title: String?
        var message: String?

        public init(title: String? = nil, message: String? = nil) {
            self.title = title
            self.message = message
        }
    }

    var config: Config

    public var body: some View {
        VStack {
            if let title = config.title {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let message = config.message {
                Text(message)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .multilineTextAlignment(.leading)
        .clippedWithPaddingAndBackground(.accent)
        .transition(.opacity)
    }
}
