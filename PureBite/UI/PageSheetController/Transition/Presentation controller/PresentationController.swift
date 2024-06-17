//
//  PresentationController.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 29/06/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

// swiftlint:disable final_class force_unwrapping
class PresentationController: UIPresentationController {

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    var driver: TransitionDriver!
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if completed {
            driver.direction = .dismiss
        }
    }
}
