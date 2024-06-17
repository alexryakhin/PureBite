import SwiftUI

struct CustomScrollView: CustomScrollViewStyle {
    @Binding var isDragging: Bool
    @Binding var offset: CGPoint
    private let scrollsToTop: Bool

    init(
        isDragging: Binding<Bool>,
        offset: Binding<CGPoint>,
        scrollsToTop: Bool = true
    ) {
        self._isDragging = isDragging
        self._offset = offset
        self.scrollsToTop = scrollsToTop
    }

    func make(body: AnyView, context: CustomContext) -> some View {
        body
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, scrollsToTop: scrollsToTop)
    }

    final class Coordinator: CustomScrollViewCoordinator {
        var parent: CustomScrollView
        let scrollsToTop: Bool

        init(parent: CustomScrollView, scrollsToTop: Bool) {
            self.parent = parent
            self.scrollsToTop = scrollsToTop
        }

        override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.offset = scrollView.contentOffset
            }
        }

        override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            parent.isDragging = true
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            scrollingFinished(scrollView: scrollView)
        }

        override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if decelerate {
                return
            }
            scrollingFinished(scrollView: scrollView)
        }

        func scrollingFinished(scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.isDragging = false
            }
        }

        override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
            return scrollsToTop
        }
    }
}
