//
//  CellWrapper.swift
//  My Dictionary
//
//  Created by Aleksandr Riakhin on 2/21/25.
//

import SwiftUI

public struct CellWrapper<LeadingContent: View, MainContent: View, TrailingContent: View>: View {
    @Environment(\.isEnabled) var isEnabled: Bool

    private let label: LocalizedStringKey?
    private let vPadding: CGFloat?
    private let hPadding: CGFloat?
    private let leadingContent: () -> LeadingContent
    private let mainContent: () -> MainContent
    private let trailingContent: () -> TrailingContent
    private let onTapAction: (() -> Void)?

    public init(
        _ label: LocalizedStringKey? = nil,
        vPadding: CGFloat? = 8,
        hPadding: CGFloat? = 16,
        onTapAction: (() -> Void)? = nil,
        @ViewBuilder leadingContent: @escaping () -> LeadingContent = { EmptyView() },
        @ViewBuilder mainContent: @escaping () -> MainContent,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent = { EmptyView() }
    ) {
        self.label = label
        self.vPadding = vPadding
        self.hPadding = hPadding
        self.onTapAction = onTapAction
        self.leadingContent = leadingContent
        self.mainContent = mainContent
        self.trailingContent = trailingContent
    }

    public var body: some View {
        HStack(spacing: 12) {
            leadingContent()
            VStack(alignment: .leading, spacing: 4) {
                if let label {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                mainContent()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            trailingContent()
        }
        .ifLet(onTapAction) { view, action in
            view.onTap {
                action()
            }
        }
        .ifLet(hPadding, transform: { view, length in
            view.padding(.horizontal, length)
        })
        .ifLet(vPadding, transform: { view, length in
            view.padding(.vertical, length)
        })
        .allowsHitTesting(isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
    }
}
