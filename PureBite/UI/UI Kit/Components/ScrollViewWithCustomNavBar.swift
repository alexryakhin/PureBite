//
//  ScrollViewWithCustomNavBar.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/1/24.
//
import SwiftUI

public struct ScrollViewWithCustomNavBar<Content: View, NavigationBar: View>: View {

    private let content: () -> Content
    private let navigationBar: () -> NavigationBar

    @State private var scrollOffset: CGFloat = .zero
    @State private var scrollOffsetConst: CGFloat = .zero
    private var navigationBarOpacity: CGFloat {
        min(max(-(scrollOffset-scrollOffsetConst) / 20, 0), 1)
    }

    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder navigationBar: @escaping () -> NavigationBar
    ) {
        self.content = content
        self.navigationBar = navigationBar
    }

    public var body: some View {
        ScrollView {
            content()
                .background(GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named(ScrollOffsetPreferenceKey.coordinateSpaceName)).minY
                    )
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                .onAppear {
                    scrollOffsetConst = scrollOffset
                }
        }
        .safeAreaInset(edge: .top) {
            navigationBar()
                .background {
                    VStack(spacing: 0) {
                        Color.clear.background(.thinMaterial)
                        Divider()
                    }
                    .opacity(navigationBarOpacity)
                }
        }
    }
}

// Preference key for tracking scroll position
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let coordinateSpaceName = "scroll"
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}