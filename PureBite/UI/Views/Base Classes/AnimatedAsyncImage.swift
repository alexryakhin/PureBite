import CachedAsyncImage
import SwiftUI

struct AnimatedAsyncImage<Content: View, Placeholder: View>: View {

    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder = { RoundedRectangle(cornerRadius: 0).shimmering() }) {
            self.url = url
            self.content = content
            self.placeholder = placeholder
    }

    var body: some View {
        CachedAsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        }
    }
}
