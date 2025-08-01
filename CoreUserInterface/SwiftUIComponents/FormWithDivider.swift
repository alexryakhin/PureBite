//
//  FormWithDivider.swift
//  My Dictionary
//
//  Created by Aleksandr Riakhin on 2/21/25.
//

import SwiftUI

/// A custom view that mimics a Form and adds dividers between each element.
struct FormWithDivider<Content: View>: View {

    private let content: Content
    private let dividerLeadingPadding: CGFloat
    private let vPadding: CGFloat

    init(
        dividerLeadingPadding: CGFloat = 16,
        vPadding: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.dividerLeadingPadding = dividerLeadingPadding
        self.vPadding = vPadding
    }

    var body: some View {
        _VariadicView.Tree(
            FormWithDividerLayout(
                dividerLeadingPadding: dividerLeadingPadding,
                vPadding: vPadding
            )
        ) {
            content
        }
    }

    struct FormWithDividerLayout: _VariadicView_MultiViewRoot {
        let dividerLeadingPadding: CGFloat
        let vPadding: CGFloat

        @ViewBuilder
        func body(children: _VariadicView.Children) -> some View {
            let last = children.last?.id
            VStack(spacing: 0) {
                ForEach(children) { child in
                    child
                        .padding(.vertical, vPadding)
                    if child.id != last {
                        Divider()
                            .padding(.leading, dividerLeadingPadding)
                    }
                }
            }
        }
    }
}
