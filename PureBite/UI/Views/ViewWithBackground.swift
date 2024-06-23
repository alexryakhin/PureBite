import SwiftUI

@MainActor
protocol ViewWithBackground: View {
    associatedtype Content: View
    associatedtype Background: View

    @ViewBuilder var content: Content { get }
    @ViewBuilder var background: Background { get }
}

extension ViewWithBackground {
    var background: some View {
        Color.background
    }

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            content
        }
    }
}
