import SwiftUI

@MainActor
public protocol ViewWithBackground: View {
    associatedtype Content: View
    associatedtype Background: View

    @ViewBuilder var content: Content { get }
    @ViewBuilder var background: Background { get }
}

extension ViewWithBackground {
    public var background: some View {
        Color.background
    }

    public var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            content
        }
    }
}
