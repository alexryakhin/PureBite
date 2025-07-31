import SwiftUI

struct ShimmerConfig {

    let lineHeight: CGFloat
    let lineSpacing: CGFloat
    let cornerRadius: CGFloat
    let animationDuration: TimeInterval
    let highlightMaxWidth: CGFloat
    let lastLineTrailingPadding: CGFloat

    init(
        lineHeight: CGFloat = 20,
        lineSpacing: CGFloat = 4,
        cornerRadius: CGFloat = 16,
        animationDuration: TimeInterval = 1,
        highlightMaxWidth: CGFloat = 200,
        lastLineTrailingPadding: CGFloat = 80
    ) {
        self.lineHeight = lineHeight
        self.lineSpacing = lineSpacing
        self.cornerRadius = cornerRadius
        self.animationDuration = animationDuration
        self.highlightMaxWidth = highlightMaxWidth
        self.lastLineTrailingPadding = lastLineTrailingPadding
    }

    static let `default` = ShimmerConfig()
}
