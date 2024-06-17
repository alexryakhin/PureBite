import SwiftUI

struct ChipsView: View {

    @Binding private var selectedChipIndices: [Int]
    private let chips: [String]

    init(
        selectedChipIndices: Binding<[Int]>,
        chips: [String]
    ) {
        self._selectedChipIndices = selectedChipIndices
        self.chips = chips
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(Array(chips.enumerated()), id: \.offset) { index, chip in
                    chipView(
                        for: chip,
                        isSelected: selectedChipIndices.contains(index)
                    )
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.15)) {
                            if let firstIndex = selectedChipIndices.firstIndex(of: index) {
                                selectedChipIndices.remove(at: firstIndex)
                            } else {
                                selectedChipIndices.append(index)
                            }
                        }
                    }
                }
            }
        }
    }

    private func chipView(for chip: String, isSelected: Bool) -> some View {
        Text(chip)
            .textStyle(.caption1)
            .padding(8)
            .background(
                isSelected
                ? .accent.opacity(0.1)
                : .accent
            )
            .foregroundColor(
                isSelected
                ? .accent
                : .secondary
            )
            .clipShape(Capsule())
            .frame(height: 25)
    }
}

#Preview {
    ChipsView(
        selectedChipIndices: .constant([0, 1]), 
        chips: ["beautiful", "because", "become", "before", "behavior", "better", "big", "bill"]
    )
}
