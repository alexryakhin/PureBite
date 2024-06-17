import SwiftUI

struct SegmentedControl: View {
    @Namespace var backgroundGeometry
    @Binding var selectedSegment: Int
    var segments: [String]

    init(
        selectedSegment: Binding<Int>,
        segments: [String]
    ) {
        self._selectedSegment = selectedSegment
        self.segments = segments
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(segments.indices, id: \.self) { index in
                ZStack {
                    if selectedSegment == index {
                        Color.secondary
                            .frame(height: 44)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 8)
                            )
                            .matchedGeometryEffect(
                                id: "bg",
                                in: backgroundGeometry
                            )
                    }
                    Button {
                        withAnimation(.interactiveSpring()) {
                            selectedSegment = index
                        }
                    } label: {
                        Text(segments[index])
                            .textStyle(.body)
                            .foregroundColor(
                                selectedSegment == index
                                ? .primary
                                : .secondary
                            )
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    .secondary,
                    lineWidth: 2
                )
        )
    }
}

#Preview {
    SegmentedControl(selectedSegment: .constant(1), segments: ["String", "2",  "3"])
}
