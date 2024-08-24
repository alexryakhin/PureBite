import SwiftUI

struct ProgressBarView: View {
    private let progress: CGFloat
    private let height: CGFloat
    private let backgroundColor: Color
    private let progressColor: Color

    init(
        progress: CGFloat,
        height: CGFloat = 10,
        backgroundColor: Color = .background,
        progressColor: Color = .accent
    ) {
        self.progress = progress
        self.height = height
        self.backgroundColor = backgroundColor
        self.progressColor = progressColor
    }

    var body: some View {
        let progressMin = min(progress, 1)

        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                backgroundColor
                    .cornerRadius(height / 2)
                progressColor
                    .cornerRadius(height / 2)
                    .frame(width: geometry.size.width * progressMin)
                    .animation(.bouncy, value: progressMin)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    ProgressBarView(progress: 0.5)
}
