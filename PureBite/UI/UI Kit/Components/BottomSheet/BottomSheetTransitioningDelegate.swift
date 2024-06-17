import UIKit

final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    private weak var bottomSheetPresentationController: BottomSheetPresentationController?

    private let preferredSheetCornerRadius: CGFloat
    private let preferredSheetBackdropColor: UIColor
    private let preferredSheetSizing: CGFloat
    private let panToDismissEnabled: Bool
    private let tapToDismissEnabled: Bool

    init(
        preferredSheetCornerRadius: CGFloat,
        preferredSheetBackdropColor: UIColor,
        preferredSheetSizing: CGFloat,
        panToDismissEnabled: Bool,
        tapToDismissEnabled: Bool
    ) {
        self.preferredSheetCornerRadius = preferredSheetCornerRadius
        self.preferredSheetBackdropColor = preferredSheetBackdropColor
        self.preferredSheetSizing = preferredSheetSizing
        self.panToDismissEnabled = panToDismissEnabled
        self.tapToDismissEnabled = tapToDismissEnabled
        super.init()
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let bottomSheetPresentationController = BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source,
            sheetCornerRadius: preferredSheetCornerRadius,
            sheetSizingFactor: preferredSheetSizing,
            sheetBackdropColor: preferredSheetBackdropColor
        )

        bottomSheetPresentationController.tapGestureRecognizer.isEnabled = tapToDismissEnabled
        bottomSheetPresentationController.panToDismissEnabled = panToDismissEnabled

        self.bottomSheetPresentationController = bottomSheetPresentationController

        return bottomSheetPresentationController
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard
            let bottomSheetPresentationController = dismissed.presentationController as? BottomSheetPresentationController,
            bottomSheetPresentationController.bottomSheetInteractiveDismissalTransition.interactiveDismissal
        else {
            return nil
        }

        return bottomSheetPresentationController.bottomSheetInteractiveDismissalTransition
    }

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        animator as? BottomSheetInteractiveDismissalTransition
    }
}
