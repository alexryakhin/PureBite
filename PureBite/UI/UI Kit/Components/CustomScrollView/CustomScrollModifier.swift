import SwiftUI
import SwiftUIIntrospect

struct CustomScrollViewStyleModifier<Style: CustomScrollViewStyle>: ViewModifier {
    @StateObject var coordinator: Style.ScrollContainer
    @Binding var bindingContext: CustomContext?
    @State var context = CustomContext(offset: .zero)

    let style: Style

    init(style: Style, context: Binding<CustomContext?> = .constant(nil)) {
        self.style = style
        self._coordinator = StateObject(wrappedValue: style.makeCoordinator())
        self._bindingContext = context
    }

    func body(content: Content) -> some View {
        style.makeBody(context: context) {
            AnyView(
                content
                    .introspect(.scrollView, on: .iOS(.v15, .v16, .v17)) { scrollView in
                        style.make(uiScrollView: scrollView)
                        scrollView.delegate = coordinator
                    }
                    .background(Color.clear)
                    .onChange(of: coordinator.offset) { newValue in
                        context.offset = newValue
                    }
                    .onChange(of: context) { newValue in
                        guard bindingContext != nil else { return }
                        bindingContext = newValue
                    }
            )
        }
    }
}

public extension View {
    @ViewBuilder
    func customScrollViewStyle<Style: CustomScrollViewStyle>(_ style: Style, context: Binding<CustomContext?> = .constant(nil)) -> some View {
        self
            .coordinateSpace(name: "ScrollView")
            .modifier(CustomScrollViewStyleModifier(style: style, context: context))
    }
}
