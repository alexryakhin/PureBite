import SwiftUI

public struct ShimmerView: View {

    private let style: ShimmerConfig
    private var width: CGFloat?
    private var height: CGFloat?
    private var aspectRatio: CGFloat?

    public init(
        style: ShimmerConfig,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        aspectRatio: CGFloat? = nil
    ) {
        self.style = style
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
    }

    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        aspectRatio: CGFloat? = nil
    ) {
        self.init(
            style: .default,
            width: width,
            height: height,
            aspectRatio: aspectRatio
        )
    }

    public var body: some View {
        Color.clear
            .frame(width: width, height: height)
            .aspectRatio(aspectRatio, contentMode: .fill)
            .shimmering(config: style)
    }
}
