import SwiftUI

protocol ViewWithBackground: View {
    associatedtype Content: View
    associatedtype Background: View

    @ViewBuilder var content: Content { get }
    @ViewBuilder var background: Background { get }
}

extension ViewWithBackground {
    var background: some View {
        Color.systemsBackground
    }

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            content
        }
    }
}
