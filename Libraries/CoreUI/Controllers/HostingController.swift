//
//  HostingController.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/22/24.
//

import UIKit
import SwiftUI

// swiftlint:disable final_class
public final class HostingController <Content>: UIHostingController<Content> where Content: View {

    private let isNavigationBarHidden: Bool
    private let ignoresKeyboard: Bool

    public init(
        rootView: Content,
        isNavigationBarHidden: Bool = false,
        ignoresKeyboard: Bool = false
    ) {
        self.isNavigationBarHidden = isNavigationBarHidden
        self.ignoresKeyboard = ignoresKeyboard

        super.init(rootView: rootView)

        if ignoresKeyboard {
            guard let viewClass = object_getClass(view) else { return }

            let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoresKeyboard")
            if let viewSubclass = NSClassFromString(viewSubclassName) {
                object_setClass(view, viewSubclass)
            } else {
                guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
                guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }

                if let method = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:")) {
                    let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
                    class_addMethod(
                        viewSubclass,
                        NSSelectorFromString("keyboardWillShowWithNotification:"),
                        imp_implementationWithBlock(keyboardWillShow),
                        method_getTypeEncoding(method)
                    )
                }
                objc_registerClassPair(viewSubclass)
                object_setClass(view, viewSubclass)
            }
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// swiftlint:enable final_class
