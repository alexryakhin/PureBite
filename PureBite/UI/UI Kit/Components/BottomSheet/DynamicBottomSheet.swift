import SwiftUI

enum DynamicSheetConstants {
    static let mediumWindowHeightMultiplier = 2.2
    static let mediumWindowHeight = UIScreen.main.bounds.height / mediumWindowHeightMultiplier
    static let lowestWindowHeight: CGFloat = 112
    static let lowestYOffset: CGFloat = 300
    static let mediumYOffset: CGFloat = lowestYOffset / 2
}

struct DynamicBottomSheetView<Content: View, TopContent: View>: View {
    @Binding var windowHeight: CGFloat
    @Binding var yOffset: CGFloat

    @State private var currentHeight: CGFloat = .zero

    private let geometryProxy: GeometryProxy
    private let content: Content
    private let topContent: TopContent

    init(
        windowHeight: Binding<CGFloat> = .constant(DynamicSheetConstants.mediumWindowHeight),
        yOffset: Binding<CGFloat> = .constant(0),
        geometryProxy: GeometryProxy,
        @ViewBuilder content: () -> Content,
        @ViewBuilder topContent: () -> TopContent
    ) {
        self._windowHeight = windowHeight
        self._yOffset = yOffset
        self.geometryProxy = geometryProxy
        self.content = content()
        self.topContent = topContent()

        _currentHeight = State(initialValue: windowHeight.wrappedValue)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            topContent
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let yLocation = value.location.y - 30
                            yOffset = max(0, min(yLocation, DynamicSheetConstants.lowestYOffset))
                            if yLocation < 0 && value.translation.height < 0 {
                                let newHeight = currentHeight + 30
                                windowHeight = newHeight
                            }
                        }
                        .onEnded { value in
                            let fullHeight = geometryProxy.size.height
                            if value.translation.height < 0 {
                                // up
                                if windowHeight < DynamicSheetConstants.mediumWindowHeight {
                                    windowHeight = DynamicSheetConstants.mediumWindowHeight
                                } else {
                                    windowHeight = fullHeight
                                }
                            } else {
                                // down
                                if windowHeight - 35 > DynamicSheetConstants.mediumWindowHeight && windowHeight - 35 < fullHeight {
                                    windowHeight = DynamicSheetConstants.mediumWindowHeight
                                } else {
                                    windowHeight = DynamicSheetConstants.lowestWindowHeight
                                }
                            }
                            yOffset = 0
                            currentHeight = windowHeight
                        }
                )
            content
        }
        .background(.primary)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .offset(y: yOffset)
        .frame(height: windowHeight)
        .animation(.easeInOut, value: windowHeight)
        .animation(.easeInOut, value: yOffset)
    }
}
