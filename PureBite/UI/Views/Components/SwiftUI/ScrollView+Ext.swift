import SwiftUI

extension ScrollView {
    @ViewBuilder
    func scrollTargetBehaviorIfAvailable() -> some View {
        if #available(iOS 17, *) {
            self.scrollTargetBehavior(.viewAligned)
        } else {
            self
        }
    }
}

extension View {
    @ViewBuilder
    func scrollTargetLayoutIfAvailable() -> some View {
        if #available(iOS 17, *) {
            self.scrollTargetLayout()
        } else {
            self
        }
    }
}
