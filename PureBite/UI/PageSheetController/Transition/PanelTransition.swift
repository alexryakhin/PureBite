//
//  PanelTransition.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 07/07/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

final class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Private Properties

    private let driver: TransitionDriver

    // MARK: - Init

    required init(with options: [PanelTransitionOption]) {
        driver = TransitionDriver(with: options)
        super.init()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        driver.link(to: presented)

        let presentationController = DimPresentationController(presentedViewController: presented,
                                                               presenting: presenting ?? source)
        presentationController.driver = driver
        return presentationController
    }

    // MARK: - Animation
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }

    // MARK: - Interaction
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }
}
