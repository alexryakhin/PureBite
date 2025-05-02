//
//  MultipleSelectionView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/2/25.
//
import SwiftUI

public struct MultipleSelectionView<T: Hashable & RawRepresentable & CaseIterable>: View where T.RawValue == String {
    private let items: [T]
    @Binding private var selected: Set<T>

    public init(
        items: [T],
        selected: Binding<Set<T>>
    ) {
        self.items = items
        self._selected = selected
    }

    public var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                MultipleSelectionRow(
                    title: item.rawValue.capitalized,
                    isSelected: selected.contains(item)
                ) {
                    if selected.contains(item) {
                        selected.remove(item)
                    } else {
                        selected.insert(item)
                    }
                }
            }
        }
    }
}

public struct MultipleSelectionRow: View {
    private let title: String
    private let isSelected: Bool
    private let toggle: () -> Void

    public init(
        title: String,
        isSelected: Bool,
        toggle: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.toggle = toggle
    }

    public var body: some View {
        Button(action: toggle) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}
