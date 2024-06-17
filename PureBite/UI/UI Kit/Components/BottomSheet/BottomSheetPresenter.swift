import Foundation
import SwiftUI

struct BottomSheetPresenter<ContentView>: UIViewControllerRepresentable where ContentView: View {

    @Binding private var isPresented: Bool

    private let ignoresKeyboard: Bool
    private let showsIndicator: Bool
    private let preferredSheetCornerRadius: CGFloat
    private let preferredSheetBackdropColor: UIColor
    private let preferredSheetSizing: BottomSheetSize
    private let tapToDismissEnabled: Bool
    private let panToDismissEnabled: Bool
    private var onDismiss: (() -> Void)?
    private var contentView: () -> ContentView

    @State private var bottomSheetHostingController: BottomSheetHostingController<ContentView>?

    init(
        isPresented: Binding<Bool>,
        ignoresKeyboard: Bool = true,
        showsIndicator: Bool = true,
        preferredSheetCornerRadius: CGFloat = 16,
        preferredSheetBackdropColor: UIColor = .label,
        preferredSheetSizing: BottomSheetSize = .fit,
        tapToDismissEnabled: Bool = true,
        panToDismissEnabled: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) {
        _isPresented = isPresented
        self.ignoresKeyboard = ignoresKeyboard
        self.showsIndicator = showsIndicator
        self.preferredSheetCornerRadius = preferredSheetCornerRadius
        self.preferredSheetBackdropColor = preferredSheetBackdropColor
        self.preferredSheetSizing = preferredSheetSizing
        self.tapToDismissEnabled = tapToDismissEnabled
        self.panToDismissEnabled = panToDismissEnabled
        self.contentView = contentView
        self.onDismiss = onDismiss
    }

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            if let bottomSheetHostingController = bottomSheetHostingController {
                bottomSheetHostingController.rootView = contentView()
            } else {
                let bottomSheet = BottomSheetHostingController(
                    isPresented: $isPresented,
                    ignoresKeyboard: ignoresKeyboard,
                    showsIndicator: showsIndicator,
                    preferredSheetCornerRadius: preferredSheetCornerRadius,
                    preferredSheetBackdropColor: preferredSheetBackdropColor,
                    preferredSheetSizing: preferredSheetSizing,
                    tapToDismissEnabled: tapToDismissEnabled,
                    panToDismissEnabled: panToDismissEnabled,
                    content: contentView()
                )
                DispatchQueue.main.throttle(interval: 1.0, context: uiViewController) {
                    Presentation.present(modal: bottomSheet, from: uiViewController, animated: true) {
                        bottomSheetHostingController = bottomSheet
                    }
                }
            }
        } else {
            guard bottomSheetHostingController != nil else { return }
            DispatchQueue.main.throttle(interval: 0.1, context: uiViewController) {
                self.bottomSheetHostingController?.dismiss(animated: true, completion: {
                    self.bottomSheetHostingController = nil
                    self.onDismiss?()
                })
            }
        }
    }
}
