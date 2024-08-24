import UIKit
import SwiftUI

public extension UIViewController {

    // UIHostingController shrinks SwiftUI view due to keyboard by default, ignoreKeyboard is set to ignore this behaviour, true for bringing it back
    func embed<V: View>(swiftUiView: V, ignoresKeyboard: Bool = true) {
        let vc = UIHostingController(rootView: swiftUiView, ignoresKeyboard: ignoresKeyboard)
        vc.willMove(toParent: self)
        addChild(vc)
        view.willMove(toSuperview: vc.view)
        view.embed(subview: vc.view, useSafeAreaGuide: false, useMarginsGuide: false)
        vc.didMove(toParent: self)
    }
}

// swiftlint:disable final_class
extension UIHostingController {
    convenience public init(rootView: Content, ignoresKeyboard: Bool) {
        self.init(rootView: rootView)

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
                    class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"),
                                    imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method))
                }
                objc_registerClassPair(viewSubclass)
                object_setClass(view, viewSubclass)
            }
        }
    }
}
