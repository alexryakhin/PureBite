import SwiftUI

public protocol CustomScrollViewStyle {
    associatedtype Body: View
    associatedtype ScrollContainer: CustomScrollViewDelegate
    @ViewBuilder @MainActor func make(body: AnyView, context: CustomContext) -> Self.Body
    func make(uiScrollView: UIScrollView)
    func makeCoordinator() -> Self.ScrollContainer
}

extension CustomScrollViewStyle {
    @ViewBuilder @MainActor func makeBody(context: CustomContext, content: @escaping () -> AnyView) -> some View {
        make(body: AnyView(content()), context: context)
    }
}

extension CustomScrollViewStyle {
    func make(uiScrollView: UIScrollView) {
    }
    func makeCoordinator() -> some CustomScrollViewDelegate {
        return CustomScrollViewCoordinator()
    }
}

public struct CustomContext: Equatable {
    public var offset: CGPoint
}
