import UIKit
import SwiftUI

public extension UIViewController {

    // UIHostingController shrinks SwiftUI view due to keyboard by default, ignoreKeyboard is set to ignore this behavior, true for bringing it back
    func embed<V: View>(
        swiftUiView: V,
        ignoresKeyboard: Bool = true,
        clearBackground: Bool = true,
        isNavigationBarHidden: Bool = false
    ) {
        let vc = HostingController(
            rootView: swiftUiView,
            isNavigationBarHidden: isNavigationBarHidden,
            ignoresKeyboard: ignoresKeyboard
        )
        if clearBackground { vc.view.backgroundColor = .clear }
        vc.willMove(toParent: self)
        addChild(vc)
        view.willMove(toSuperview: vc.view)
        view.embed(subview: vc.view, useSafeAreaGuide: false, useMarginsGuide: false)
        vc.didMove(toParent: self)
    }
}
