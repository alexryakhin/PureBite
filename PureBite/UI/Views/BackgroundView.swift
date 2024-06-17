import SwiftUI

struct BackgroundView<Content: View>: View {

    private var backgroundColor: Color
    @ViewBuilder private var content: () -> Content

    init(
        backgroundColor: Color = .systemsBackground,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.content = content
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            content()
        }
    }
}

#Preview {
    BackgroundView {
        Text("Hello world")
    }
}
