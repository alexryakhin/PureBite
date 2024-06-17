import SwiftUI

struct PinDotsView: View {
    var isError: Bool
    var filledCount: Int

    public init(
        isError: Bool,
        filledCount: Int
    ) {
        self.isError = isError
        self.filledCount = filledCount
    }

    public var body: some View {
        HStack(spacing: 20) {
            ForEach(1...4, id: \.self) { num in
                Circle()
                    .fill(fillColor(for: num))
                    .frame(width: 12, height: 12)
            }
        }
    }

    private func fillColor(for num: Int) -> Color {
        guard !isError else { return .red }
        return num <= filledCount ? .accent : .secondary
    }
}
