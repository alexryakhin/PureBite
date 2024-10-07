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
    @State private var navBarSize: CGSize = .zero
    private var navigationBarOpacity: CGFloat {
        min(max(-(scrollOffset-navBarSize.height-UIWindow.safeAreaTopInset) / 20, 0), 1)
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
        }
        .safeAreaInset(edge: .top) {
            ChildSizeReader(size: $navBarSize) {
                navigationBar()
            }
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
    static let defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}
