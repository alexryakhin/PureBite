import SwiftUI

// swiftlint:disable:next final_class
open class CustomScrollViewCoordinator: NSObject, CustomScrollViewDelegate {
    @Published public var offset = CGPoint.zero

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.offset = scrollView.contentOffset
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) { }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool { return true }
}

public protocol CustomScrollViewDelegate: AnyObject, ObservableObject, UIScrollViewDelegate {
    var offset: CGPoint { get set }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}
